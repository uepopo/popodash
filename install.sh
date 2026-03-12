#!/bin/bash

BOLD="\033[1m"
RED="\033[31m"
RESET="\033[0m"

print_banner() {
    echo ""
    echo "                ██████████              ██████████"
    echo "            ██████████████████      ████████████████"
    echo "          ██████      ██████    ████████      ██████"
    echo "          ██████          ████    ████          ██████"
    echo "            ██████        ████████████          ████"
    echo "            ██████          ████████          ████    ██████████████"
    echo "██████████████████          ██████            ████████████████████████"
    echo "████████  ████████████        ████          ██████████          ██████"
    echo "██████          ██████        ████          ██████            ████████"
    echo "  ████████          ████      ████████████████              ████████"
    echo "    ██████████        ████████████████████████████      ████████"
    echo "        ████████████████████              ████████████████"
    echo "              ██████████                        ████████"
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
    echo "                              ████████████████████████████"
    echo ""
}

set_language() {
    clear
    print_banner
    echo -e "${BOLD}Select Language / 请选择语言 / 言語を選択してください:${RESET}"
    echo "  1. English"
    echo "  2. 简体中文"
    echo "  3. 日本語"
    echo ""
    read -p "👉 [1-3] (Default 2): " LANG_CHOICE

    if [ "$LANG_CHOICE" == "1" ]; then
        INDEX_FILE="Language/index_en.html"
        UI_TITLE="popodash Management Console"
        UI_OPT1="Install / Update / Reconfigure"
        UI_OPT2="Uninstall"
        UI_OPT0="Exit"
        UI_PROMPT="👉 Select option [0-2]: "
        
        CHECK_ENV="0. Checking and configuring base environment..."
        CHECK_CURL="curl not found, attempting auto-install..."
        CHECK_PY="python3 not found, attempting auto-install..."
        
        START_INSTALL="Starting popodash minimalist panel installation"
        INPUT_USER="👉 Set panel username (Default: admin): "
        INPUT_PASS="👉 Set panel password (Default: 123456): "
        INPUT_PORT="👉 Set panel port (Default: 2077): "
        INPUT_PATH="👉 Set panel secure path (Default: "
        
        STEP_1="1. Cleaning up old versions and conflicting processes..."
        STEP_2="2. Building the nest (Deploying to $HOME/popodash)..."
        STEP_3="3. Writing configuration..."
        STEP_4="4. Pulling components from GitHub..."
        STEP_5="5. Implanting global neural commands..."
        STEP_6="6. Starting engine..."
        
        DONE="[Success] Dashboard is online!"
        URL_V4="▶ IPv4 Access URL:"
        URL_V6="▶ IPv6 Access URL:"
        URL_FB="▶ Access URL:"
        TIP="💡 Tip: Type 'popodash' in the terminal to call up this menu anytime!"
        
        WARN_UNINSTALL="⚠️ WARNING: This will completely remove the popodash panel!"
        CONFIRM_UN="Are you sure you want to continue? (y/n): "
        UNINSTALL_DONE="Uninstallation complete. See you around!"
        
    elif [ "$LANG_CHOICE" == "3" ]; then
        INDEX_FILE="Language/index_jp.html"
        UI_TITLE="popodash 管理コンソール"
        UI_OPT1="インストール / 更新 / 再設定"
        UI_OPT2="アンインストール"
        UI_OPT0="終了"
        UI_PROMPT="👉 オプションを選択してください [0-2]: "
        
        CHECK_ENV="0. 動作環境を確認・構成しています..."
        CHECK_CURL="curl が見つかりません。自動インストールを試みます..."
        CHECK_PY="python3 が見つかりません。自動インストールを試みます..."
        
        START_INSTALL="popodash 軽量パネルのインストールを開始します"
        INPUT_USER="👉 ユーザー名を設定 (デフォルト: admin): "
        INPUT_PASS="👉 パスワードを設定 (デフォルト: 123456): "
        INPUT_PORT="👉 ポート番号を設定 (デフォルト: 2077): "
        INPUT_PATH="👉 セキュアアクセスパスを設定 (デフォルト: "
        
        STEP_1="1. 旧バージョンと競合プロセスをクリーンアップしています..."
        STEP_2="2. パネルのディレクトリを作成しています ($HOME/popodash)..."
        STEP_3="3. 構成ファイルを書き込んでいます..."
        STEP_4="4. GitHub からコンポーネントをダウンロードしています..."
        STEP_5="5. グローバルコマンドを組み込んでいます..."
        STEP_6="6. エンジンを起動しています..."
        
        DONE="[完了] パネルがオンラインになりました！"
        URL_V4="▶ IPv4 アクセス URL:"
        URL_V6="▶ IPv6 アクセス URL:"
        URL_FB="▶ アクセス URL:"
        TIP="💡 ヒント: ターミナルで popodash と入力すると、いつでもこのメニューを呼び出せます！"
        
        WARN_UNINSTALL="⚠️ 警告: これにより popodash パネルが完全に削除されます！"
        CONFIRM_UN="続行してもよろしいですか？ (y/n): "
        UNINSTALL_DONE="アンインストールが完了しました。さようなら！"
        
    else
        INDEX_FILE="Language/index_ch.html"
        UI_TITLE="popodash 管理控制台"
        UI_OPT1="安装 / 更新 / 重新配置 面板"
        UI_OPT2="完全卸载面板"
        UI_OPT0="退出"
        UI_PROMPT="👉 请输入选项 [0-2]: "
        
        CHECK_ENV="0. 正在检查并配置基础运行环境..."
        CHECK_CURL="未检测到 curl，正在尝试自动安装..."
        CHECK_PY="未检测到 python3，正在尝试自动安装..."
        
        START_INSTALL="开始安装 popodash 极简面板"
        INPUT_USER="👉 请设置面板登录用户名 (默认: admin): "
        INPUT_PASS="👉 请设置面板登录密码 (默认: 123456): "
        INPUT_PORT="👉 请设置面板运行端口 (默认: 2077): "
        INPUT_PATH="👉 请设置面板安全访问路径 (默认: "
        
        STEP_1="1. 正在清理旧版本与冲突进程..."
        STEP_2="2. 正在打造专属鸡窝 (部署在 $HOME/popodash 目录)..."
        STEP_3="3. 正在写入配置..."
        STEP_4="4. 正在从 GitHub 拉取纯净版组件..."
        STEP_5="5. 正在植入全局神经指令..."
        STEP_6="6. 正在启动引擎..."
        
        DONE="[大功告成] 面板已上线！"
        URL_V4="▶ IPv4 访问地址:"
        URL_V6="▶ IPv6 访问地址:"
        URL_FB="▶ 访问地址:"
        TIP="💡 实用技巧：在终端输入 popodash 即可随时呼出本菜单！"
        
        WARN_UNINSTALL="⚠️ 警告：这将完全删除 popodash 面板！"
        CONFIRM_UN="确定要继续吗？(y/n): "
        UNINSTALL_DONE="卸载完成。江湖再见！"
    fi
}

check_dependencies() {
    echo -e "\n${BOLD}${CHECK_ENV}${RESET}"
    
    if ! command -v curl &> /dev/null; then
        echo "${CHECK_CURL}"
        if command -v apt-get &> /dev/null; then
            apt-get update -y > /dev/null 2>&1
            apt-get install -y curl > /dev/null 2>&1
        elif command -v yum &> /dev/null; then
            yum install -y curl > /dev/null 2>&1
        elif command -v apk &> /dev/null; then
            apk add curl > /dev/null 2>&1
        fi
    fi

    if ! command -v python3 &> /dev/null; then
        echo "${CHECK_PY}"
        if command -v apt-get &> /dev/null; then
            apt-get update -y > /dev/null 2>&1
            apt-get install -y python3 > /dev/null 2>&1
        elif command -v yum &> /dev/null; then
            yum install -y python3 > /dev/null 2>&1
        elif command -v apk &> /dev/null; then
            apk add python3 > /dev/null 2>&1
        fi
    fi
}

create_shortcut() {
    cat > /usr/local/bin/popodash << 'EOF'
#!/bin/bash
bash <(curl -sL "https://raw.githubusercontent.com/uepopo/popodash/main/install.sh?t=$RANDOM" | tr -d '\r')
EOF
    chmod +x /usr/local/bin/popodash
}

install_jgt() {
    echo -e "\n=================================================="
    echo -e "${BOLD}🐔 ${START_INSTALL}${RESET}"
    echo -e "==================================================\n"

    check_dependencies

    RANDOM_SUFFIX=$(tr -dc a-z0-9 </dev/urandom | head -c 8)
    DEFAULT_PATH="/rd_${RANDOM_SUFFIX}"

    read -p "${INPUT_USER}" JGT_USER
    JGT_USER=${JGT_USER:-admin}
    read -p "${INPUT_PASS}" JGT_PASS
    JGT_PASS=${JGT_PASS:-123456}
    read -p "${INPUT_PORT}" JGT_PORT
    JGT_PORT=${JGT_PORT:-2077}
    read -p "${INPUT_PATH}${DEFAULT_PATH}): " JGT_PATH
    JGT_PATH=${JGT_PATH:-$DEFAULT_PATH}

    if [[ "$JGT_PATH" != /* ]]; then
        JGT_PATH="/$JGT_PATH"
    fi

    echo -e "\n${BOLD}${STEP_1}${RESET}"
    pkill -f "python3 jgt_server.py" 2>/dev/null
    sleep 1

    echo -e "${BOLD}${STEP_2}${RESET}"
    INSTALL_DIR="$HOME/popodash"
    mkdir -p "$INSTALL_DIR"
    rm -f "$INSTALL_DIR/index.html" "$INSTALL_DIR/jgt_server.py" "$INSTALL_DIR/jgt_config.json" 2>/dev/null

    cd "$INSTALL_DIR" || exit

    echo -e "${BOLD}${STEP_3}${RESET}"
    echo "{\"user\": \"$JGT_USER\", \"pass\": \"$JGT_PASS\", \"port\": $JGT_PORT, \"base_path\": \"$JGT_PATH\"}" > jgt_config.json

    echo -e "${BOLD}${STEP_4}${RESET}"
    curl -s -o index.html "https://raw.githubusercontent.com/uepopo/popodash/main/${INDEX_FILE}?t=$RANDOM"
    curl -s -o jgt_server.py "https://raw.githubusercontent.com/uepopo/popodash/main/jgt_server.py?t=$RANDOM"

    echo -e "${BOLD}${STEP_5}${RESET}"
    create_shortcut

    echo -e "${BOLD}${STEP_6}${RESET}"
    nohup python3 jgt_server.py >/dev/null 2>&1 &
    sleep 2

    REAL_IPV4=$(curl -s -m 5 -4 icanhazip.com || echo "")
    REAL_IPV6=$(curl -s -m 5 -6 icanhazip.com || echo "")

    echo -e "\n${BOLD}🎉 ${DONE}${RESET}"
    
    if [ -n "$REAL_IPV4" ]; then
        echo -e "${URL_V4} ${RED}http://${REAL_IPV4}:${JGT_PORT}${JGT_PATH}${RESET}"
    fi
    
    if [ -n "$REAL_IPV6" ]; then
        echo -e "${URL_V6} ${RED}http://[${REAL_IPV6}]:${JGT_PORT}${JGT_PATH}${RESET}"
    fi

    if [ -z "$REAL_IPV4" ] && [ -z "$REAL_IPV6" ]; then
        echo -e "${URL_FB} ${RED}http://<IP>:${JGT_PORT}${JGT_PATH}${RESET}"
    fi
    
    echo -e "\n${TIP}\n"
}

uninstall_jgt() {
    echo -e "\n${BOLD}${WARN_UNINSTALL}${RESET}"
    read -p "${CONFIRM_UN}" CONFIRM
    if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
        pkill -f "python3 jgt_server.py" 2>/dev/null
        rm -rf "$HOME/popodash"
        rm -f /usr/local/bin/popodash
        echo -e "${BOLD}✅ ${UNINSTALL_DONE}${RESET}\n"
    fi
}

show_menu() {
    clear
    print_banner
    echo -e "${BOLD}🐔 ${UI_TITLE}${RESET}"
    echo "=================================================="
    echo " 1. ${UI_OPT1}"
    echo " 2. ${UI_OPT2}"
    echo " 0. ${UI_OPT0}"
    echo "=================================================="
    read -p "${UI_PROMPT}" OPTION

    case $OPTION in
        1) install_jgt ;;
        2) uninstall_jgt ;;
        0) exit 0 ;;
        *) show_menu ;;
    esac
}

set_language
show_menu
