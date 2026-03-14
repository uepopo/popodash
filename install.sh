#!/bin/bash

# 管道执行时 stdin 被占用，强制从终端读取用户输入
exec </dev/tty

# 确保脚本以 root 权限运行 (安装服务和依赖必须)
if [ "$EUID" -ne 0 ]; then
  echo -e "\033[31mPlease run as root (请使用 root 权限或 sudo 运行此脚本)\033[0m"
  exit 1
fi

# ==========================
# 颜色 & 样式定义
# ==========================
BOLD="\033[1m"
DIM="\033[2m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
WHITE="\033[97m"
RESET="\033[0m"

VERSION="V1.300"

# ==========================
# LOGO 图形
# ==========================
print_banner() {
    echo ""
    echo -e "${CYAN}                ██████████              ██████████"
    echo "            ██████████████████      ████████████████"
    echo "          ██████      ██████    ████████      ██████"
    echo "          ██████          ████    ████          ██████"
    echo "            ██████        ████████████          ████"
    echo "            ██████          ████████          ████    ██████████████"
    echo "██████████████████          ██████            ████████████████████████"
    echo "████████  ████████████        ████          ██████████          ██████"
    echo "██████          ██████        ████          ██████            ████████"
    echo "  ████████          ████      ████████████████            ████████"
    echo "    ██████████        ████████████████████████████      ████████"
    echo "        ████████████████████              ████████████████"
    echo "              ██████████                      ████████"
    echo "              ██████                            ████████"
    echo "            ██████                                    ████"
    echo "██████████████████████████████  ██████████████████████████████"
    echo "██████████              ██████████                ████████████████"
    echo "    ████                ██████████                ████  ██████"
    echo "    ████                ████  ████                ████  ██████"
    echo "    ██████            ████      ██████        ██████    ██████"
    echo "          ██████████████████████████████████████        ██████"
    echo "              ████████████████████████████              ██████"
    echo "          ██████████████████████████████████            ██████"
    echo "        ██████████████████████████████████████          ██████"
    echo "    ██████████████████████████████████████████          ██████"
    echo "  ████████████████████████████████████████████          ██████"
    echo "██████████████████████████████████████████████          ██████"
    echo "  ██████████████████████████████████████████            ██████"
    echo "          ██████████████████████████████                ██████"
    echo "                        ██████████████                    ████████"
    echo "                        ████████                      ██████████"
    echo "                          ████████████████████████████████████"
    echo -e "                              ████████████████████████████${RESET}"
    echo ""
    # 标版区域
    echo -e "${BOLD}${WHITE}  ┌──────────────────────────────────────────────────────────────┐${RESET}"
    echo -e "${BOLD}${WHITE}  │                                                              │${RESET}"
    echo -e "${BOLD}${CYAN}  │                ██████  ██████  ██████  ██████                │${RESET}"
    echo -e "${BOLD}${CYAN}  │                ██  ██  ██  ██  ██  ██  ██  ██                │${RESET}"
    echo -e "${BOLD}${CYAN}  │                ██████  ██  ██  ██████  ██  ██ dash           │${RESET}"
    echo -e "${BOLD}${CYAN}  │                ██      ██  ██  ██      ██  ██                │${RESET}"
    echo -e "${BOLD}${CYAN}  │                ██      ██████  ██      ██████                │${RESET}"
    echo -e "${BOLD}${WHITE}  │                                                              │${RESET}"
    echo -e "${DIM}${WHITE}  │                 Cyber Toy for Your Idle VPS                  │${RESET}"
    echo -e "${DIM}${WHITE}  │                     鸡公头极简 VPS 面板                      │${RESET}"
    echo -e "${DIM}${WHITE}  │                        ·  ·  ·  ·  ·                         │${RESET}"
    echo -e "${DIM}${CYAN}  │                            ${VERSION}                            │${RESET}"
    echo -e "${BOLD}${WHITE}  │                                                              │${RESET}"
    echo -e "${BOLD}${WHITE}  └──────────────────────────────────────────────────────────────┘${RESET}"
    echo ""
}

# ==========================
# 语言选择
# ==========================
set_language() {
    clear
    print_banner
    echo -e "${BOLD}Select Language / 请选择语言 / 言語を選択してください:${RESET}"
    echo -e "  ${CYAN}1.${RESET} English"
    echo -e "  ${CYAN}2.${RESET} 简体中文"
    echo -e "  ${CYAN}3.${RESET} 日本語"
    echo ""
    read -p "👉 [1-3] (Default 2): " LANG_CHOICE

    if [ "$LANG_CHOICE" == "1" ]; then
        INDEX_FILE="Language/index_en.html"
        UI_TITLE="popodash Management Console"
        UI_OPT1="Install / Update / Reconfigure"
        UI_OPT2="Uninstall"
        UI_OPT0="Exit"
        UI_PROMPT="👉 Select option [0-2]: "

        CHECK_ENV="[ 0/6 ] Checking base environment..."
        CHECK_CURL="  → curl not found, auto-installing..."
        CHECK_PY="  → python3 not found, auto-installing..."

        START_INSTALL="Installing popodash minimalist panel"
        INPUT_USER="👉 Panel username (press Enter for default: admin): "
        INPUT_PASS="👉 Panel password (press Enter for default: 123456): "
        WARN_WEAK_PASS="  ⚠  Using default password 123456 — strongly recommended to change it after login!"
        INPUT_PORT="👉 Panel port    (press Enter for default: 2077): "
        INPUT_PATH="👉 Secure path   (press Enter for default: "

        STEP_1="[ 1/6 ] Cleaning up old versions..."
        STEP_2="[ 2/6 ] Creating panel directory ($HOME/popodash)..."
        STEP_3="[ 3/6 ] Writing configuration..."
        STEP_4="[ 4/6 ] Pulling components from GitHub..."
        STEP_5="[ 5/6 ] Installing global shortcut command..."
        STEP_6="[ 6/6 ] Starting service (systemd)..."

        DONE="Installation complete — dashboard is online!"
        URL_V4="  ▶  IPv4:"
        URL_V6="  ▶  IPv6:"
        URL_FB="  ▶  URL :"
        TIP="💡 Tip: type  popodash  in any terminal to reopen this menu."

        WARN_UNINSTALL="⚠  WARNING: This will completely remove the popodash panel!"
        CONFIRM_UN="Are you sure? (y/n): "
        UNINSTALL_DONE="Uninstalled. See you around!"

    elif [ "$LANG_CHOICE" == "3" ]; then
        INDEX_FILE="Language/index_jp.html"
        UI_TITLE="popodash 管理コンソール"
        UI_OPT1="インストール / 更新 / 再設定"
        UI_OPT2="アンインストール"
        UI_OPT0="終了"
        UI_PROMPT="👉 オプションを選択してください [0-2]: "

        CHECK_ENV="[ 0/6 ] 動作環境を確認しています..."
        CHECK_CURL="  → curl が見つかりません。自動インストールします..."
        CHECK_PY="  → python3 が見つかりません。自動インストールします..."

        START_INSTALL="popodash 軽量パネルのインストールを開始します"
        INPUT_USER="👉 ユーザー名 (Enter でデフォルト: admin): "
        INPUT_PASS="👉 パスワード (Enter でデフォルト: 123456): "
        WARN_WEAK_PASS="  ⚠  デフォルトパスワード 123456 を使用中 — ログイン後に変更することを強くお勧めします！"
        INPUT_PORT="👉 ポート番号 (Enter でデフォルト: 2077): "
        INPUT_PATH="👉 セキュアパス (Enter でデフォルト: "

        STEP_1="[ 1/6 ] 旧バージョンをクリーンアップしています..."
        STEP_2="[ 2/6 ] ディレクトリを作成しています ($HOME/popodash)..."
        STEP_3="[ 3/6 ] 設定ファイルを書き込んでいます..."
        STEP_4="[ 4/6 ] GitHub からファイルをダウンロードしています..."
        STEP_5="[ 5/6 ] グローバルショートカットをインストールしています..."
        STEP_6="[ 6/6 ] サービスを起動しています (systemd)..."

        DONE="インストール完了 — パネルがオンラインになりました！"
        URL_V4="  ▶  IPv4:"
        URL_V6="  ▶  IPv6:"
        URL_FB="  ▶  URL :"
        TIP="💡 ヒント: ターミナルで  popodash  と入力するといつでもこのメニューを呼び出せます。"

        WARN_UNINSTALL="⚠  警告: popodash パネルを完全に削除します！"
        CONFIRM_UN="続行しますか？ (y/n): "
        UNINSTALL_DONE="アンインストール完了。またね！"

    else
        INDEX_FILE="Language/index_ch.html"
        UI_TITLE="popodash 管理控制台"
        UI_OPT1="安装 / 更新 / 重新配置"
        UI_OPT2="完全卸载面板"
        UI_OPT0="退出"
        UI_PROMPT="👉 请输入选项 [0-2]: "

        CHECK_ENV="[ 0/6 ] 正在检查基础运行环境..."
        CHECK_CURL="  → 未检测到 curl，正在自动安装..."
        CHECK_PY="  → 未检测到 python3，正在自动安装..."

        START_INSTALL="开始安装 popodash 极简面板"
        INPUT_USER="👉 登录用户名 (直接回车默认: admin): "
        INPUT_PASS="👉 登录密码   (直接回车默认: 123456): "
        WARN_WEAK_PASS="  ⚠  当前使用默认密码 123456，强烈建议登录后立即修改！"
        INPUT_PORT="👉 面板端口   (直接回车默认: 2077): "
        INPUT_PATH="👉 安全访问路径 (直接回车默认: "

        STEP_1="[ 1/6 ] 正在清理旧版本与冲突进程..."
        STEP_2="[ 2/6 ] 正在打造专属鸡窝 ($HOME/popodash)..."
        STEP_3="[ 3/6 ] 正在写入配置文件..."
        STEP_4="[ 4/6 ] 正在从 GitHub 拉取最新组件..."
        STEP_5="[ 5/6 ] 正在植入全局快捷指令..."
        STEP_6="[ 6/6 ] 正在启动守护进程 (systemd)..."

        DONE="安装完成 — 面板已上线！"
        URL_V4="  ▶  IPv4 地址:"
        URL_V6="  ▶  IPv6 地址:"
        URL_FB="  ▶  访问地址:"
        TIP="💡 小技巧：在任意终端输入  popodash  即可随时呼出本菜单。"

        WARN_UNINSTALL="⚠  警告：这将完全删除 popodash 面板！"
        CONFIRM_UN="确定要继续吗？(y/n): "
        UNINSTALL_DONE="卸载完成。江湖再见！"
    fi
}

# ==========================
# 检查依赖
# 【修复】移除了多余的 flask / flask_cors，server.py 根本不需要它们
# 【新增】检测 pacman（Arch Linux）兼容
# ==========================
check_dependencies() {
    echo -e "\n${BOLD}${CYAN}${CHECK_ENV}${RESET}"

    if ! command -v curl &> /dev/null; then
        echo -e "${YELLOW}${CHECK_CURL}${RESET}"
        if   command -v apt-get &> /dev/null; then apt-get update -q > /dev/null 2>&1 && apt-get install -y curl > /dev/null 2>&1
        elif command -v yum     &> /dev/null; then yum install -y curl > /dev/null 2>&1
        elif command -v apk     &> /dev/null; then apk add --no-cache curl > /dev/null 2>&1
        elif command -v pacman  &> /dev/null; then pacman -Sy --noconfirm curl > /dev/null 2>&1
        fi
    fi

    if ! command -v python3 &> /dev/null; then
        echo -e "${YELLOW}${CHECK_PY}${RESET}"
        if   command -v apt-get &> /dev/null; then apt-get update -q > /dev/null 2>&1 && apt-get install -y python3 > /dev/null 2>&1
        elif command -v yum     &> /dev/null; then yum install -y python3 > /dev/null 2>&1
        elif command -v apk     &> /dev/null; then apk add --no-cache python3 > /dev/null 2>&1
        elif command -v pacman  &> /dev/null; then pacman -Sy --noconfirm python3 > /dev/null 2>&1
        fi
    fi
    # jgt_server.py 只用 Python 标准库，无需安装任何第三方包
}

# ==========================
# 全局快捷指令
# ==========================
create_shortcut() {
    cat > /usr/local/bin/popodash << 'EOF'
#!/bin/bash
bash <(curl -sL "https://raw.githubusercontent.com/uepopo/popodash/main/install.sh?t=$RANDOM" | tr -d '\r')
EOF
    chmod +x /usr/local/bin/popodash
}

# ==========================
# 安装主流程
# ==========================
install_jgt() {
    echo ""
    echo -e "${BOLD}${WHITE}  ════════════════════════════════════════════════════${RESET}"
    echo -e "${BOLD}${CYAN}    🐔  ${START_INSTALL}${RESET}"
    echo -e "${BOLD}${WHITE}  ════════════════════════════════════════════════════${RESET}"
    echo ""

    check_dependencies

    RANDOM_SUFFIX=$(tr -dc a-z0-9 </dev/urandom | head -c 8)
    DEFAULT_PATH="/rd_${RANDOM_SUFFIX}"

    echo ""
    read -p "  ${INPUT_USER}" JGT_USER
    JGT_USER=${JGT_USER:-admin}

    read -p "  ${INPUT_PASS}" JGT_PASS
    JGT_PASS=${JGT_PASS:-123456}
    # 【修复】弱密码警告：使用默认密码时提醒用户
    if [ "$JGT_PASS" == "123456" ]; then
        echo -e "${YELLOW}${WARN_WEAK_PASS}${RESET}"
    fi

    read -p "  ${INPUT_PORT}" JGT_PORT
    JGT_PORT=${JGT_PORT:-2077}

    read -p "  ${INPUT_PATH}${DEFAULT_PATH}): " JGT_PATH
    JGT_PATH=${JGT_PATH:-$DEFAULT_PATH}
    if [[ "$JGT_PATH" != /* ]]; then
        JGT_PATH="/$JGT_PATH"
    fi

    echo ""
    echo -e "  ${BOLD}${CYAN}${STEP_1}${RESET}"
    pkill -f "python3 jgt_server.py" 2>/dev/null
    systemctl stop popodash 2>/dev/null
    sleep 1

    echo -e "  ${BOLD}${CYAN}${STEP_2}${RESET}"
    INSTALL_DIR="$HOME/popodash"
    mkdir -p "$INSTALL_DIR"
    rm -f "$INSTALL_DIR/index.html" "$INSTALL_DIR/jgt_server.py" "$INSTALL_DIR/jgt_config.json" 2>/dev/null
    cd "$INSTALL_DIR" || exit

    echo -e "  ${BOLD}${CYAN}${STEP_3}${RESET}"
    echo "{\"user\": \"$JGT_USER\", \"pass\": \"$JGT_PASS\", \"port\": $JGT_PORT, \"base_path\": \"$JGT_PATH\"}" > jgt_config.json

    echo -e "  ${BOLD}${CYAN}${STEP_4}${RESET}"
    curl -sf -o index.html    "https://raw.githubusercontent.com/uepopo/popodash/main/${INDEX_FILE}?t=$RANDOM"
    curl -sf -o jgt_server.py "https://raw.githubusercontent.com/uepopo/popodash/main/jgt_server.py?t=$RANDOM"

    # 【新增】下载失败检测：文件不存在或大小为 0 时报错退出
    if [ ! -s index.html ] || [ ! -s jgt_server.py ]; then
        echo -e "\n${RED}  ✖  Download failed. Please check your network and try again.${RESET}\n"
        exit 1
    fi

    echo -e "  ${BOLD}${CYAN}${STEP_5}${RESET}"
    create_shortcut

    echo -e "  ${BOLD}${CYAN}${STEP_6}${RESET}"
    cat > /etc/systemd/system/popodash.service <<EOF
[Unit]
Description=PopoDash Panel Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=${INSTALL_DIR}
ExecStart=/usr/bin/python3 ${INSTALL_DIR}/jgt_server.py
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable popodash  > /dev/null 2>&1
    systemctl restart popodash
    sleep 2

    # 获取公网 IP
    REAL_IPV4=$(curl -s -m 5 -4 icanhazip.com 2>/dev/null || echo "")
    REAL_IPV6=$(curl -s -m 5 -6 icanhazip.com 2>/dev/null || echo "")

    # 完成提示框
    echo ""
    echo -e "${BOLD}${GREEN}  ┌─────────────────────────────────────────────────────┐${RESET}"
    echo -e "${BOLD}${GREEN}  │  🎉  ${DONE}${RESET}"
    echo -e "${BOLD}${GREEN}  ├─────────────────────────────────────────────────────┤${RESET}"
    if [ -n "$REAL_IPV4" ]; then
        echo -e "${GREEN}  │${RESET}  ${URL_V4}  ${RED}http://${REAL_IPV4}:${JGT_PORT}${JGT_PATH}${RESET}"
    fi
    if [ -n "$REAL_IPV6" ]; then
        echo -e "${GREEN}  │${RESET}  ${URL_V6}  ${RED}http://[${REAL_IPV6}]:${JGT_PORT}${JGT_PATH}${RESET}"
    fi
    if [ -z "$REAL_IPV4" ] && [ -z "$REAL_IPV6" ]; then
        echo -e "${GREEN}  │${RESET}  ${URL_FB}  ${RED}http://<Your-IP>:${JGT_PORT}${JGT_PATH}${RESET}"
    fi
    echo -e "${BOLD}${GREEN}  └─────────────────────────────────────────────────────┘${RESET}"
    echo ""
    echo -e "  ${DIM}${TIP}${RESET}"
    echo ""
}

# ==========================
# 卸载
# ==========================
uninstall_jgt() {
    echo ""
    echo -e "${BOLD}${RED}  ${WARN_UNINSTALL}${RESET}"
    echo ""
    read -p "  ${CONFIRM_UN}" CONFIRM
    if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
        systemctl stop popodash    2>/dev/null
        systemctl disable popodash 2>/dev/null
        rm -f /etc/systemd/system/popodash.service
        systemctl daemon-reload
        pkill -f "python3 jgt_server.py" 2>/dev/null
        rm -rf "$HOME/popodash"
        rm -f /usr/local/bin/popodash
        echo -e "\n${BOLD}${GREEN}  ✅  ${UNINSTALL_DONE}${RESET}\n"
    fi
}

# ==========================
# 主菜单
# ==========================
show_menu() {
    clear
    print_banner
    echo -e "${BOLD}${WHITE}  🐔  ${UI_TITLE}${RESET}"
    echo -e "${WHITE}  ──────────────────────────────────────────────────────${RESET}"
    echo -e "  ${CYAN}1.${RESET}  ${UI_OPT1}"
    echo -e "  ${CYAN}2.${RESET}  ${UI_OPT2}"
    echo -e "  ${DIM}0.  ${UI_OPT0}${RESET}"
    echo -e "${WHITE}  ──────────────────────────────────────────────────────${RESET}"
    echo ""
    read -p "  ${UI_PROMPT}" OPTION

    case $OPTION in
        1) install_jgt ;;
        2) uninstall_jgt ;;
        0) exit 0 ;;
        *) show_menu ;;
    esac
}

set_language
show_menu
