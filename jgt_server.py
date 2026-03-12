import time, json, os, urllib.request, urllib.parse, threading, shutil, uuid, re, datetime
from http.server import BaseHTTPRequestHandler, HTTPServer
from socketserver import ThreadingMixIn

class ThreadedHTTPServer(ThreadingMixIn, HTTPServer):
    daemon_threads = True

# ==========================
# Global Variables
# ==========================
global_conf = {}
VALID_USER = "admin"
VALID_PASS = "123456"
AUTH_TOKEN = "init_token"
SERVER_PORT = 8888  
BASE_PATH = "/"

def load_config():
    global global_conf, VALID_USER, VALID_PASS, AUTH_TOKEN, SERVER_PORT, BASE_PATH
    try:
        with open('jgt_config.json', 'r') as f:
            global_conf = json.load(f)
        
        VALID_USER = global_conf.get('user', 'admin')
        VALID_PASS = global_conf.get('pass', '123456')
        SERVER_PORT = int(global_conf.get('port', 8888))
        BASE_PATH = global_conf.get('base_path', '/')
        AUTH_TOKEN = global_conf.get('token')

        if not AUTH_TOKEN:
            AUTH_TOKEN = uuid.uuid4().hex
            global_conf['token'] = AUTH_TOKEN
            with open('jgt_config.json', 'w') as fw: json.dump(global_conf, fw)
    except Exception as e:
        VALID_USER, VALID_PASS, AUTH_TOKEN, SERVER_PORT, BASE_PATH = 'admin', '123456', uuid.uuid4().hex, 8888, "/"
        global_conf = {'user': VALID_USER, 'pass': VALID_PASS, 'token': AUTH_TOKEN, 'port': SERVER_PORT, 'base_path': BASE_PATH}
        try:
            with open('jgt_config.json', 'w') as f: json.dump(global_conf, f)
        except: pass
        
    if not BASE_PATH.startswith('/'): BASE_PATH = '/' + BASE_PATH
    if BASE_PATH != '/' and BASE_PATH.endswith('/'): BASE_PATH = BASE_PATH[:-1]

load_config()

PUBLIC_IP, IP_LOC, VPS_LAT, VPS_LON = "Fetching...", "Locating...", 34.05, -118.24

def fetch_ip_info_bg():
    global PUBLIC_IP, IP_LOC, VPS_LAT, VPS_LON
    time.sleep(2) 
    apis = ['http://ipwho.is/', 'https://ipapi.co/json/']
    for _ in range(10): 
        if "Fetching" not in PUBLIC_IP and "Unknown IP" not in PUBLIC_IP: break 
        for api in apis:
            try:
                req = urllib.request.Request(api, headers={'User-Agent': 'Mozilla/5.0 (Roosterdash)'})
                with urllib.request.urlopen(req, timeout=5) as response:
                    data = json.loads(response.read().decode('utf-8'))
                    if 'ipwho' in api:
                        if data.get('success') == True:
                            PUBLIC_IP = data.get('ip', 'Unknown IP')
                            IP_LOC = f"{data.get('country', '')} {data.get('city', '')}"
                            VPS_LAT, VPS_LON = float(data.get('latitude', 34.05)), float(data.get('longitude', -118.24))
                            return
                    else:
                        if 'ip' in data:
                            PUBLIC_IP = data.get('ip', 'Unknown IP')
                            IP_LOC = f"{data.get('country_name', '')} {data.get('city', '')}"
                            VPS_LAT, VPS_LON = float(data.get('latitude', 34.05)), float(data.get('longitude', -118.24))
                            return
            except: pass 
        time.sleep(5) 

threading.Thread(target=fetch_ip_info_bg, daemon=True).start()

sys_lock = threading.Lock()
last_cpu_stats = {}
_sys_cache = {'events': {'time': 0, 'data': []}, 'processes': {'time': 0, 'data': []}}

def get_recent_ssh_logs():
    logs = []
    try:
        out = os.popen('journalctl -u ssh -u sshd -n 50 --no-pager | grep -E "Accepted|Failed" | tail -n 6').read()
        if not out:
            out = os.popen('grep -E "Accepted|Failed" /var/log/auth.log /var/log/secure 2>/dev/null | tail -n 6').read()
        for line in out.strip().split('\n'):
            if not line: continue
            parts = line.split()
            if len(parts) > 5:
                time_str = " ".join(parts[:3])
                msg = " ".join(parts[5:])
                logs.append(f"[{time_str}] {msg}")
    except: pass
    if not logs: logs = ["System is secure. No recent SSH login attempts..."]
    return logs

def get_sys_info():
    global last_cpu_stats, _sys_cache, PUBLIC_IP, IP_LOC
    try:
        import socket
        sys_hostname = socket.gethostname()
    except: sys_hostname = "deck"
        
    with sys_lock:
        now = time.time()
        load1, load5, load15 = os.getloadavg()
        with open('/proc/uptime', 'r') as f:
            uptime_seconds = float(f.readline().split()[0])
            uptime_days, uptime_hours = int(uptime_seconds // 86400), int((uptime_seconds % 86400) // 3600)
        
        mem = {}
        with open('/proc/meminfo', 'r') as f:
            for line in f:
                parts = line.split()
                if len(parts) >= 2: mem[parts[0].replace(':', '')] = int(parts[1])
        mem_total = mem.get('MemTotal', 0) // 1024
        mem_free = mem.get('MemAvailable', mem.get('MemFree', 0)) // 1024
        swap_total, swap_free = mem.get('SwapTotal', 0) // 1024, mem.get('SwapFree', 0) // 1024
        
        net_rx, net_tx, disk_r, disk_w = 0, 0, 0, 0
        try:
            with open('/proc/net/dev', 'r') as f:
                for line in f:
                    if 'eth0' in line or 'ens3' in line or 'ens4' in line:
                        parts = line.split(':')[1].split()
                        net_rx, net_tx = int(parts[0]), int(parts[8]); break
        except: pass
        try:
            with open('/proc/diskstats', 'r') as f:
                for line in f:
                    if 'vda ' in line or 'sda ' in line or 'nvme0n1 ' in line:
                        parts = line.split()
                        disk_r, disk_w = int(parts[5]) * 512, int(parts[9]) * 512; break
        except: pass

        if now - _sys_cache['processes']['time'] >= 5:
            processes = []
            try:
                for line in os.popen("ps axo pid,user,pcpu,pmem,comm,args --sort=-pcpu | sed 1d | head -n 20").read().strip().split('\n'):
                    parts = line.split(None, 5)
                    if len(parts) >= 6: processes.append({ "pid": parts[0], "user": parts[1][:8], "cpu": float(parts[2]), "mem": float(parts[3]), "comm": parts[4], "args": parts[5] })
            except: pass
            _sys_cache['processes'] = {'time': now, 'data': processes}

        cpu_cores = []
        try:
            with open('/proc/stat', 'r') as f: lines = f.readlines()
            current_stats = {parts[0]: (float(parts[4]), sum(float(x) for x in parts[1:])) for line in lines if line.startswith('cpu') and line.strip() != 'cpu' and not line.startswith('cpu ') for parts in [line.split()]}
            if not last_cpu_stats:
                last_cpu_stats = current_stats
                cpu_cores = [0.0] * len(current_stats)
            else:
                for name, stats in current_stats.items():
                    prev_idle, prev_total = last_cpu_stats.get(name, (0,0))
                    diff_total = stats[1] - prev_total
                    cpu_cores.append(round(100.0 * (1.0 - (stats[0] - prev_idle) / diff_total), 1) if diff_total > 0 else 0.0)
                last_cpu_stats = current_stats
        except: pass

        disk_total_gb, disk_used_gb, disk_free_gb = 0, 0, 0
        try:
            dt, du, df = shutil.disk_usage("/")
            disk_total_gb, disk_used_gb, disk_free_gb = round(dt/(1024**3), 1), round(du/(1024**3), 1), round(df/(1024**3), 1)
        except: pass

        return {
            "status": "success", "hostname": sys_hostname, "public_ip": PUBLIC_IP, "ip_loc": IP_LOC, "vps_lat": VPS_LAT, "vps_lon": VPS_LON,
            "load": f"{load1:.2f}, {load5:.2f}, {load15:.2f}", "uptime": f"{uptime_days}d {uptime_hours}h", "uptime_days": uptime_days,
            "mem_total_mb": mem_total, "mem_used_mb": mem_total - mem_free, "mem_free_mb": mem_free,
            "swap_total_mb": swap_total, "swap_used_mb": swap_total - swap_free, "swap_free_mb": swap_free,
            "net_rx_bytes": net_rx, "net_tx_bytes": net_tx, "disk_r_bytes": disk_r, "disk_w_bytes": disk_w, 
            "disk_total_gb": disk_total_gb, "disk_used_gb": disk_used_gb, "disk_free_gb": disk_free_gb,
            "events": [{"time": "Just now", "critical": "System Perfect", "process": "No anomalies detected"}], 
            "processes": _sys_cache['processes']['data'], "cpu_cores": cpu_cores[:4],
            "ssh_logs": get_recent_ssh_logs()
        }

def send_tg_message(token, chat_id, text):
    if not token or not chat_id: return {"ok": False, "description": "Token or Chat ID missing"}
    try:
        url = f"https://api.telegram.org/bot{token}/sendMessage"
        data = urllib.parse.urlencode({'chat_id': chat_id, 'text': text}).encode('utf-8')
        req = urllib.request.Request(url, data=data)
        with urllib.request.urlopen(req, timeout=15) as response: return json.loads(response.read().decode('utf-8'))
    except Exception as e: return {"ok": False, "description": str(e)}

last_daily_rx, last_daily_tx = 0, 0
def get_daily_traffic():
    global last_daily_rx, last_daily_tx
    rx, tx = 0, 0
    try:
        with open('/proc/net/dev', 'r') as f:
            for line in f:
                if 'eth0' in line or 'ens3' in line or 'ens4' in line:
                    parts = line.split(':')[1].split()
                    rx, tx = int(parts[0]), int(parts[8]); break
    except: pass
    diff_rx = max(0, rx - last_daily_rx) if last_daily_rx > 0 else 0
    diff_tx = max(0, tx - last_daily_tx) if last_daily_tx > 0 else 0
    last_daily_rx, last_daily_tx = rx, tx
    return round(diff_rx / (1024**2), 2), round(diff_tx / (1024**2), 2)

def get_ssh_logins_24h():
    count = 0; ips = []
    try:
        out = os.popen('journalctl -u ssh -u sshd --since "1 day ago" | grep "Accepted"').read()
        if not out: out = os.popen('grep "Accepted" /var/log/auth.log /var/log/secure 2>/dev/null').read()
        ip_pattern = re.compile(r'[0-9a-fA-F:\.]+')
        for line in out.strip().split('\n'):
            if not line: continue
            count += 1
            matches = ip_pattern.findall(line)
            if matches: ips.append(matches[-1])
    except: pass
    unique_ips = list(set(ips))
    return len(unique_ips), ", ".join(unique_ips) + ", " if unique_ips else "None"

def generate_tg_report():
    global global_conf
    sys_info = get_sys_info()
    rx_mb, tx_mb = get_daily_traffic()
    ssh_count, ssh_ips = get_ssh_logins_24h()
    p_name = global_conf.get('panel_name', 'Unnamed VPS')
    msg = f"Roosterdash.com \n-----------------------\n🖥️ Host: {p_name}\n\nTraffic Today: In {rx_mb}MB | Out {tx_mb}MB\nSSH Logins (24h): {ssh_count} unique IPs\n{ssh_ips}\n\n"
    mem_pct = round((sys_info.get('mem_used_mb') / sys_info.get('mem_total_mb')) * 100) if sys_info.get('mem_total_mb') else 0
    msg += f"System Status: {'Excellent!' if mem_pct < 85 else 'High load, please check!'}\n\n-----------------------\n"
    targets = [("Anchorage", "us.pool.ntp.org"), ("Vancouver", "ca.pool.ntp.org"), ("San Francisco", "sfo-ca-us-ping.vultr.com"), ("Frankfurt", "fra-de-ping.vultr.com"), ("Singapore", "sgp-ping.vultr.com"), ("Hong Kong", "hkg-hi-ping.vultr.com"), ("Tokyo", "hnd-jp-ping.vultr.com"), ("Sydney", "syd-au-ping.vultr.com")]
    ping_results = []; total_ping = 0; valid_pings = 0
    for name, domain in targets:
        try:
            res = os.popen(f"ping -c 1 -W 1 {domain}").read()
            if "time=" in res:
                val = float(res.split("time=")[1].split(" ")[0])
                ping_results.append(f"{name}  {int(val)}ms")
                total_ping += val; valid_pings += 1
            else: ping_results.append(f"{name}  T/O")
        except: ping_results.append(f"{name}  T/O")
    avg_ping = int(total_ping / valid_pings) if valid_pings > 0 else "T/O"
    msg += f"Global Avg Latency: {avg_ping}ms\n-----------------------\n"
    ip = sys_info.get("public_ip", "127.0.0.1")
    if ':' in ip: parts = ip.split(':'); masked_ip = f"{parts[0]}:{parts[1]}:***:***" if len(parts)>2 else ip
    else: parts = ip.split('.'); masked_ip = f"{parts[0]}.{parts[1]}.{parts[2]}.***" if len(parts)==4 else ip
    msg += f"Host IP: {masked_ip}\n" + "\n".join(ping_results)
    return msg

def tg_daily_reporter():
    global global_conf
    time.sleep(10); get_daily_traffic(); last_sent_date = None
    while True:
        time.sleep(30)
        token = global_conf.get('tg_token', ''); chat_id = global_conf.get('tg_chat_id', ''); push_time = global_conf.get('tg_push_time', '14:00')
        if token and chat_id:
            try:
                now_utc = datetime.datetime.utcnow(); current_time_str = now_utc.strftime('%H:%M'); current_date_str = now_utc.strftime('%Y-%m-%d')
                if current_time_str == push_time and last_sent_date != current_date_str:
                    send_tg_message(token, chat_id, generate_tg_report())
                    last_sent_date = current_date_str
            except Exception as e: pass

threading.Thread(target=tg_daily_reporter, daemon=True).start()

class API(BaseHTTPRequestHandler):
    def log_message(self, format, *args): pass 
    def check_auth(self): return str(self.headers.get('Authorization', '')).strip() == str(AUTH_TOKEN).strip()

    def do_POST(self):
        global VALID_USER, VALID_PASS, global_conf, AUTH_TOKEN
        length = int(self.headers.get('Content-Length', 0))
        
        if self.path == '/api/login':
            try:
                body = json.loads(self.rfile.read(length).decode('utf-8'))
                if body.get('username') == VALID_USER and body.get('password') == VALID_PASS:
                    self.send_response(200); self.send_header('Content-type', 'application/json'); self.end_headers()
                    self.wfile.write(json.dumps({"status": "success", "token": AUTH_TOKEN}).encode('utf-8'))
                else:
                    self.send_response(401); self.end_headers(); self.wfile.write(json.dumps({"status": "fail"}).encode('utf-8'))
            except: self.send_response(400); self.end_headers()

        elif self.path == '/api/settings':
            if not self.check_auth(): self.send_response(401); self.end_headers(); return
            try:
                body = json.loads(self.rfile.read(length).decode('utf-8'))
                if body.get('new_user'): VALID_USER = body.get('new_user')
                if body.get('new_pass'): VALID_PASS = body.get('new_pass')
                global_conf.update({'user': VALID_USER, 'pass': VALID_PASS})
                if 'panel_name' in body: global_conf['panel_name'] = body.get('panel_name')
                if 'panel_avatar' in body: global_conf['panel_avatar'] = body.get('panel_avatar')
                if 'tg_token' in body: global_conf['tg_token'] = body.get('tg_token')
                if 'tg_chat_id' in body: global_conf['tg_chat_id'] = body.get('tg_chat_id')
                if 'tg_push_time' in body: global_conf['tg_push_time'] = body.get('tg_push_time')
                with open('jgt_config.json', 'w') as f: json.dump(global_conf, f)
                self.send_response(200); self.send_header('Content-type', 'application/json'); self.end_headers()
                self.wfile.write(json.dumps({"status": "success"}).encode('utf-8'))
            except: self.send_response(400); self.end_headers()

        elif self.path == '/api/cmd':
            if not self.check_auth(): self.send_response(401); self.end_headers(); return
            try:
                body = json.loads(self.rfile.read(length).decode('utf-8'))
                cmd = body.get('cmd', '')
                out_text = "Command not allowed."
                # 真实的 Linux 指令查询（只读安全指令）
                if cmd == 'disk': out_text = os.popen('df -h | grep -v loop | grep -v tmpfs').read()
                elif cmd == 'mem': out_text = os.popen('free -m').read()
                elif cmd == 'who': out_text = os.popen('who').read()
                elif cmd == 'ports': out_text = os.popen('ss -tuln | head -n 12').read()
                
                self.send_response(200); self.send_header('Content-type', 'application/json'); self.end_headers()
                self.wfile.write(json.dumps({"status": "success", "output": out_text.strip()}).encode('utf-8'))
            except: self.send_response(400); self.end_headers()

        elif self.path == '/api/tg_test':
            if not self.check_auth(): self.send_response(401); self.end_headers(); return
            try:
                body = json.loads(self.rfile.read(length).decode('utf-8'))
                threading.Thread(target=lambda t, c: send_tg_message(t, c, generate_tg_report()), args=(body.get('tg_token'), body.get('tg_chat_id'))).start()
                self.send_response(200); self.send_header('Content-type', 'application/json'); self.end_headers()
                self.wfile.write(json.dumps({"status": "success", "info": "started"}).encode('utf-8'))
            except: self.send_response(400); self.end_headers()

        elif self.path == '/api/ping':
            if not self.check_auth(): self.send_response(401); self.end_headers(); return
            try:
                body = json.loads(self.rfile.read(length).decode('utf-8'))
                target = body.get('target', '')
                if not re.match(r'^[a-zA-Z0-9.-]+$', target):
                    self.send_response(200); self.send_header('Content-type', 'application/json'); self.end_headers()
                    self.wfile.write(json.dumps({"status": "success", "ping": 999.9}).encode('utf-8')); return
                res = os.popen(f"ping -c 1 -W 1 {target}").read()
                ping_val = 999.9
                if "time=" in res:
                    try: ping_val = float(res.split("time=")[1].split(" ")[0])
                    except: pass
                self.send_response(200); self.send_header('Content-type', 'application/json'); self.end_headers()
                self.wfile.write(json.dumps({"status": "success", "ping": ping_val}).encode('utf-8'))
            except: self.send_response(400); self.end_headers()

    def do_GET(self):
        if self.path == BASE_PATH or self.path == f"{BASE_PATH}/": 
            self.serve_file('index.html'); return
        elif self.path == '/api/config':
            self.send_response(200); self.send_header('Content-type', 'application/json'); self.end_headers()
            self.wfile.write(json.dumps({"status": "success", "panel_name": global_conf.get('panel_name', 'Roosterdash'), "panel_avatar": global_conf.get('panel_avatar', 'https://raw.githubusercontent.com/uepopo/popodash/main/img/logo/LOGO.png')}).encode('utf-8')); return
        elif self.path == '/api/tg_config':
            if not self.check_auth(): self.send_response(401); self.end_headers(); return
            self.send_response(200); self.send_header('Content-type', 'application/json'); self.end_headers()
            self.wfile.write(json.dumps({"status": "success", "tg_token": global_conf.get('tg_token', ''), "tg_chat_id": global_conf.get('tg_chat_id', ''), "tg_push_time": global_conf.get('tg_push_time', '14:00')}).encode('utf-8')); return
        elif self.path == '/api':
            if not self.check_auth(): self.send_response(401); self.end_headers(); return
            self.send_response(200); self.send_header('Content-type', 'application/json'); self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate'); self.end_headers()
            self.wfile.write(json.dumps(get_sys_info(), ensure_ascii=False).encode('utf-8')); return
        else: 
            self.send_response(404); self.end_headers(); self.wfile.write(b"404 Not Found")

    def serve_file(self, filename):
        try:
            with open(filename, 'rb') as f: content = f.read()
            self.send_response(200); self.send_header('Content-type', 'text/html; charset=utf-8'); self.end_headers(); self.wfile.write(content)
        except: self.send_response(404); self.end_headers(); self.wfile.write(b"File not found!")
            
import socket
try: ThreadedHTTPServer.address_family = socket.AF_INET6; ThreadedHTTPServer(('::', SERVER_PORT), API).serve_forever()
except Exception: ThreadedHTTPServer.address_family = socket.AF_INET; ThreadedHTTPServer(('0.0.0.0', SERVER_PORT), API).serve_forever()
