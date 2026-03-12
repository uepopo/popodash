<div align="center">
  <img src="https://raw.githubusercontent.com/uepopo/popodash/main/img/logo/LOGO.png" alt="popodash Logo" width="120" style="pointer-events: none;">
  <h1>popodash</h1>
</div>

<br>

<details open>
<summary><b>🇺🇸 English Version (Click to unfold/fold)</b></summary>
<br>

<div align="center">
  <h2>popodash (Minimalist VPS Panel)</h2>
  <p><b>A Cyber-toy for Your Dust-Collecting Potato VPS</b></p>
  <p><i>"Even a 128MB potato server deserves a sexy dashboard."</i></p>
</div>

About twenty years ago, I spent two brief years as a graphic designer. This is my first open-source project on GitHub—and actually, my first real attempt at UI design.

The project was originally named "Roosterdash," but I renamed it after realizing it sounded a bit too much like a... specialized adult toy. To ensure it runs on even the weakest "potato servers," I’ve obsessively refined this lightweight, slightly cyberpunk VPS panel. With over 300 commits, my coding style might make professional developers cringe, but the result is a one-click script that intelligently adapts to almost any environment. Thus, I give you: Popodash Minimalist VPS Panel V1.300+.
<div align="center">
  <div style="width: 70%; height: 1px; background-image: linear-gradient(to right, transparent, #8e8e93 50%, transparent); background-size: 8px 1px; background-repeat: repeat-x;"></div>
</div>
<div align="center">
  <img src="https://github.com/user-attachments/assets/8ffc0ab7-b7f4-4b27-886f-d8bc6fa50126" 
       width="300" 
       alt="popodash Demo GIF" 
       style="image-rendering: -webkit-optimize-contrast; 
              image-rendering: crisp-edges;
              pointer-events: none;
              user-select: none;">
</div>
<div align="center">
  <div style="width: 70%; height: 1px; background-image: linear-gradient(to right, transparent, #8e8e93 50%, transparent); background-size: 8px 1px; background-repeat: repeat-x;"></div>
</div>

<p><b>One-Click Installation Script</b></p>

```bash
bash <(curl -sL "https://raw.githubusercontent.com/jigongtou/popodash/main/install.sh?t=$RANDOM" | tr -d '\r')
```
<br><br>
I used port `2077` by default as a tribute to Cyberpunk 2077. You can change it if you want.
 
After installation, the script will directly print out your access URL (IPv4 and IPv6 supported).

- **Default Username**: `admin`
- **Default Password**: `123456`
<br><br>
<br><br>

<p><b>Features of popodash</b></p>
<div align="center">
  <br>
  <img width="800" alt="Dashboard View" src="https://github.com/user-attachments/assets/2313607d-3e8b-4f36-b5d0-31b968e8c3cc" style="pointer-events: none; user-select: none;">
  <br><br>
</div>

**1. Egg Radar (Hardware Info)**
There's an egg on the homepage showing your potato server's hardware info. Click it, and it will twitch while testing real-time latency to major media platforms, instantly showing if you can connect to Google or Netflix.

**2. Global Node Latency Speed Test**
I built in 50 nodes from major countries and regions. Click the "Easter Egg" in the middle of the page to watch a radar animation testing your potato's latency to data centers worldwide. It has no practical value, but it's highly stress-relieving and purely for visual enjoyment.

**3. Nerfed Terminal**
At the bottom of the panel, there is a command-line window running in a read-only sandbox. I originally wanted to make it an SSH tool, but for absolute security, I heavily nerfed it. You can still type `ping`, `top`, `neofetch`, or even `rm -rf /` in it. It gives you real visual feedback but will NEVER delete any files on your server. Fulfills the need to show off safely.

**4. Rooster Companion**
When your potato server's CPU is maxed out or RAM is about to explode, the backend monitors it in real-time and pops up chat bubbles on the UI to complain. Click the potato server to trigger random complaints (e.g., "Boss, the RAM is almost eaten up!"). I wanted to make a full Tamagotchi, but the workload was too heavy, and many 128MB potato servers couldn't handle it, so I gave up on that part.

**5. Telegram Intel (Scheduled Reports)**
Just bind a Telegram bot and set the time. Every day, like a little secretary, it will organize your potato server's traffic consumption and SSH login audits (checking for sneaky unknown IPs) into a clean report and send it to your phone. You can also click to send an instant report anytime.

**6. Freebie Keep-Alive**
Many "Always Free" VPS (like Oracle) have a reclamation mechanism: if left idle for a long time, the system will reclaim it for resource wasting. popodash has a built-in smart "heartbeat" keep-alive function: no need to manually brush traffic, it maintains that "survival baseline" with extremely low resource consumption (<20MB RAM), ensuring your free instances stay truly "Always Free".
<br><br>
<br><br>

<p><b>Which Potato Servers Can Install This?</b></p>
Currently, popodash has been tested in various bizarre environments. Whether it's a freebie you grabbed or a potato server you paid for, as long as it's a Linux system, it basically works on the first try:

- **The Gods of Freebies**: Perfectly adapts to Oracle (Always Free), Polish Frogs (Zabka/Webmin), German Heirlooms (Euserv IPv6), and the legendary Serv00 (although you can't monitor the host machine state on Serv00, the panel still runs sexily).
- **Cost-Effective Fighters**: Various low-end AMD/Intel potato servers from Cloudcone, RackNerd (RN), BandwagonHost, etc.
- **Extreme Environment Tests**: Supports various NAT instances, pure IPv6 potato servers, and those minimalist VPS with only 128MB of RAM.

In short, no matter how bizarre your server environment is, just connect to the SSH terminal, copy the code, and hit Enter all the way. I did meticulous environment detection (can't guarantee 100% foolproof, but it basically installs whatever is missing), so your potato servers will no longer collect dust.
<br><br>
<br><br>

<h1>popodash (Dev Diary)</h1>
<br><br>
The original intention of developing this minimalist VPS platform was like this. I joined various VPS groups, initially following everyone to learn how to grab freebies and cheap potato servers. 
Later, my post-80s midlife crisis broke out—no brothers to drink with, no friends to brag to. Surprisingly, getting a tiny free VPS brought a little bit of joy to my stagnant life. But I only knew how to hit Enter on the big bosses' one-click commands, and felt completely lost when problems occurred.

Then, with the help of AI, I started learning to play around, asking AI to make various little things I imagined in my head. Next, I wanted to make a more fun little toy for myself:
**It doesn't need to be omnipotent, as long as it's light enough, allows all my garbage potato servers to install it, looks good enough, and is fun enough.**

I thought developing with AI meant feeding it a bunch of requirements and waiting for the finished product. But that wasn't the case at all. AI is like an extremely smart child with no common sense. I found I had to take responsibility for every word I said to it, guiding and correcting it attentively like a child to get good results.

My daily development routine looked like this:

**1. Conception and Sketches**: First, I used Photoshop to draw the UI mockups I wanted in my head, detailing the layout down to every pixel. I don't know CSS, so I started this project using the grid methods I used for magazine prints back in the day.

**2. Antique Tool Annotation**: Then I used Freehand (an ancient graphic design software from the dinosaur era) to cover the screenshots with dense red lines, arrows, and modification suggestions. There was no way to output the result at once; it was a page-by-page splicing process. If the chat context got too long, the AI would go crazy, so I had to open a new chat and continue. I sent these screenshots with dense annotations to the AI, letting it modify the frontend CSS and backend line by line.

<br><br>
<div align="center">
  <div style="width: 70%; height: 1px; background-image: linear-gradient(to right, transparent, #8e8e93 50%, transparent); background-size: 8px 1px; background-repeat: repeat-x;"></div>
</div>
<div align="center">
  <img src="https://github.com/user-attachments/assets/e7f5836a-0ec4-475c-8e83-4ef060ebc7ad" 
       width="800" 
       alt="popodash Demo GIF" 
       style="image-rendering: -webkit-optimize-contrast; 
              image-rendering: crisp-edges; 
              border-radius: 20px; 
              border: 2px solid #111111; 
              display: block;
              pointer-events: none;
              user-select: none;">
</div>
<div align="center">
  <div style="width: 70%; height: 1px; background-image: linear-gradient(to right, transparent, #8e8e93 50%, transparent); background-size: 8px 1px; background-repeat: repeat-x;"></div>
</div>
<br><br>
  <p><i>(Note: This is my "communication method" with AI—not knowing code, but being extremely stubborn. The practicality of heavy machinery met with pixel-level OCD.)</i></p>

<p><b>popodash. It requires no large dependencies and uses less than 20MB of RAM.</b></p>
It is a late-night safe haven—a place to check server status, run radar tests, and watch indicator lights blink in a sandbox terminal.

Salute to everyone who feels happy and finds joy in instantly owning a small, low-spec server.

Even a small potato server deserves a beautiful soul. Have fun!

</details>

<br>

<details>
<summary><b>🇨🇳 简体中文版本 (点击展开/折叠)</b></summary>
<br>

<div align="center">
  <h2>popodash (鸡公头极简 VPS 面板)</h2>
  <p><b>吃灰 VPS 的赛博玩具</b></p>
  <p><i>“即便是 128MB 的小弱鸡 VPS服务器，也配拥有一个骚气的面板。”</i></p>
</div>

大家好，你现在看到的这个极简、轻量、带点赛博朋克风的 VPS 面板，可以支持各种 VPS 甚至是NAT 或者纯IPV6 的小弱鸡，后台智能适配大多数环境。可以让你的VPS一键拥有一个漂亮的监控面板。
<div align="center">
  <div style="width: 70%; height: 1px; background-image: linear-gradient(to right, transparent, #8e8e93 50%, transparent); background-size: 8px 1px; background-repeat: repeat-x;"></div>
</div>
<div align="center">
  <img src="https://github.com/user-attachments/assets/8ffc0ab7-b7f4-4b27-886f-d8bc6fa50126" 
       width="300" 
       alt="popodash Demo GIF" 
       style="image-rendering: -webkit-optimize-contrast; 
              image-rendering: crisp-edges;
              pointer-events: none;
              user-select: none;">
</div>
<div align="center">
  <div style="width: 70%; height: 1px; background-image: linear-gradient(to right, transparent, #8e8e93 50%, transparent); background-size: 8px 1px; background-repeat: repeat-x;"></div>
</div>

<p><b>一键安装脚本</b></p>

```bash
bash <(curl -sL "https://raw.githubusercontent.com/jigongtou/popodash/main/install.sh?t=$RANDOM" | tr -d '\r')
```
<br><br>
我默认使用了 `2077` 端口，向赛博朋克 2077 致敬，你也可以更改端口。
 
安装完成后，脚本会直接打印出你的访问地址（支持 IPv4 和 IPv6）。

- **默认账号**：`admin`
- **默认密码**：`123456`
<br><br>
<br><br>
<p><b>鸡公头极简 VPS 面板 的功能特性</b></p>
<div align="center">
  <br>
  <img width="800" alt="Dashboard View" src="https://github.com/user-attachments/assets/2313607d-3e8b-4f36-b5d0-31b968e8c3cc" style="pointer-events: none; user-select: none;">
  <br><br>
</div>

**1. 蛋蛋雷达测速 (Global Radar)**
首页搞了颗鸡蛋，平时显示VPS的硬件信息，只要点一下就能抽搐，并测试主要媒体平台的即时延迟，立刻就能看看谷歌，看看奈飞什么的能不能连上。

**2. 全球节点延迟测速 (Global Radar)**
我在内置了 50 个主要国家和地区的节点。点一下页面中间的“彩蛋”，就能看着雷达动画测试你这台VPS连接全球各地数据中心的延迟。没有什么实用价值，但看着非常解压，纯粹的视觉享受。

**3. 阉鸡终端” (Nerfed Terminal)**
面板底部有一个运行在只读沙盒的命令行窗口。一开始是想做成 SSH 工具，但为了确保绝对安全，我阉割了很多功能，所以我现在命名为“阉鸡终端”。但依然可以在里面输入 `ping`、`top`、`neofetch` 甚至 `rm -rf /`。它会给你真实的视觉反馈，但绝不会真的删掉你服务器上的任何文件。满足安全装 X 的需求。

**4. 鸡公伴侣**
VPS的 CPU 跑满了或内存快爆了，后台会实时监控，并在 UI 页面上弹气泡吐槽，点一下VPS，会随机触发不同吐槽。例如（“老板，内存快吃光啦！”）。我本想做成一只电子鸡，但是工程量太大了，很多126兆的VPS可能吃不消就放弃了。

**5. 电报定时报告 (Telegram Intel)**
只要绑定 Telegram 机器人，设定好时间。它每天会像小秘书一样，把VPS的流量消耗、有没有被陌生 IP 偷偷登录过（SSH 审计），整理成清爽的报告发到你手机上。你也可以随时点击一下就发送即时报告。

**6. 羊毛鸡保活**
很多「永久免費」的 VPS（如甲骨文等）都有回收机制：如果长期闲置（CPU 或內存佔用过低），系统会判定资源浪费强制回收。鸡公头面板 內置了聰明的「心跳保活」功能：無需手動刷流量，它會以極低的資源消耗（<20MB RAM）維持那條「生存紅線」，確保你的免費實例真正做到「永久免費」。
<br><br>
<br><br>
<p><b>哪些VPS可以安装？</b></p>
目前 popodash 已经在各种奇葩环境下测试通过。不论是薅来的免费羊毛，还是你自己掏钱的VPS，只要是 Linux 系统，基本上都能一把过：

- **白嫖界的神机**：完美适配 Oracle 甲骨文 (Always Free)、波兰小青蛙 (Zabka/Webmin)、德意志传家宝 (Euserv IPv6) 以及传说中的 Serv00（虽然在 Serv00 上无法监控母鸡状态，但面板依然能骚气地跑起来）。
- **性价比战斗机**：如 Cloudcone、RackNerd (RN)、BandwagonHost (搬瓦工) 的各种低配 AMD/Intel VPS。
- **极限环境测试**：支持各类 NAT 实例、纯 IPv6 VPS 以及那些内存只有 128MB 的极简 VPS。

总之不管你的服务器环境有多奇葩，只要连上 SSH 终端，复制代码，一路回车即可。我做了精细的环境检测（虽然不敢保证 100% 灵，但基本缺啥补啥），让你的VPS不再吃灰。

<br><br>
<br><br>

<p><b>popodash。它不需要任何大型依赖，内存占用不到 20MB。</b></p>
它是一个深夜避风港——一个可以查看服务器状态、运行雷达测试、并在沙盒终端中观察指示灯闪烁的地方。

向所有即时拥有一个小型、低配置服务器就感到开心和乐趣的人致敬。

即使是小弱鸡 VPS 也值得拥有美好的心灵。玩得开心！

</details>

<br><br>
<div align="center">
  <a href="mailto:uepopo@autistici.org"><img src="https://img.shields.io/badge/Email-UEPOPO-gray?style=flat-square&logo=gmail" alt="Email"></a>
  &nbsp;
  <a href="https://github.com/uepopo/popodash"><img src="https://img.shields.io/badge/GitHub-UEPOPO-black?style=flat-square&logo=github" alt="GitHub"></a>
  &nbsp;
  <a href="https://x.com/uepopoer?s=21"><img src="https://img.shields.io/badge/X-UEPOPOER-gray?style=flat-square&logo=x" alt="X"></a>
  &nbsp;
  <a href="https://www.youtube.com/@uepopo"><img src="https://img.shields.io/badge/YouTube-UEPOPO-red?style=flat-square&logo=youtube" alt="YouTube"></a>
  &nbsp;
  <a href="https://t.me/uepopo"><img src="https://img.shields.io/badge/Telegram-UEPOPO-blue?style=flat-square&logo=telegram" alt="Telegram"></a>
</div>
<div align="center">
  <font color="#888888" size="2">© 2026 popodash. Released under the MIT License.</font>
</div>
