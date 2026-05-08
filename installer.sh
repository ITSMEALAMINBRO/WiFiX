#!/data/data/com.termux/files/usr/bin/bash

# ─────────────────────────────────────────────
#  WiFiX Installer — Logic Fixed (Font After Clone)
# ─────────────────────────────────────────────

# --- [ CONFIG & COLORS ] ---
REPO_URL="https://github.com/ITSMEALAMINBRO/WiFiX"
REPO_NAME="WiFiX"
BIN_NAME="wifix"

GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RED="\033[1;31m"
CYAN="\033[1;36m"
WHITE="\033[1;97m"
RESET="\033[0m"
BOLD="\033[1m"

# --- [ UI FUNCTIONS ] ---
get_width() {
    tput cols 2>/dev/null || echo 50
}

draw_box_line() {
    local msg="$1"
    local color="$2"
    local width=$(get_width)
    local padding=$((width - ${#msg} - 4))
    echo -ne "${CYAN}┃ ${color}${msg}${RESET}"
    for ((i=0; i<padding; i++)); do echo -n " "; done
    echo -e "${CYAN} ┃${RESET}"
}

clear

# --- [ HEADER ] ---
WIDTH=$(get_width)
echo -e "${CYAN}┏$(for ((i=0; i<WIDTH-2; i++)); do echo -n "━"; done)┓${RESET}"
echo -e "${CYAN}┃${WHITE}${BOLD}$(printf " %-$((WIDTH-4))s " "WiFiX AUTOMATED INSTALLER")${CYAN}┃${RESET}"
echo -e "${CYAN}┗$(for ((i=0; i<WIDTH-2; i++)); do echo -n "━"; done)┛${RESET}"

# --- [ STEP 1: SYSTEM UPDATE ] ---
echo -e "\n${BLUE}[ * ] Syncing Repositories...${RESET}"
pkg update -y && pkg upgrade -y

echo -e "\n${BLUE}[ * ] Installing Core Dependencies...${RESET}"
pkg install root-repo -y
pkg install git tsu python wpa-supplicant pixiewps iw -y

# --- [ STEP 2: REPO SETUP ] ---
# এখানে আগে ক্লোন হবে যাতে ফন্ট ফাইলটি পাওয়া যায়
if [ ! -d "$REPO_NAME" ] && [ ! -f "main.py" ]; then
    echo -e "\n${YELLOW}[ * ] Cloning Source from GitHub...${RESET}"
    git clone "$REPO_URL"
    cd "$REPO_NAME" || exit
elif [ -d "$REPO_NAME" ]; then
    cd "$REPO_NAME" || exit
fi

SCRIPT_DIR="$(pwd)"

# --- [ STEP 3: NERD FONT SETUP (After Clone) ] ---
echo -e "\n${BLUE}[ i ] Config: Nerd Font Environment...${RESET}"
if [ -f "font.ttf" ]; then
    mkdir -p ~/.termux/
    cp font.ttf ~/.termux/font.ttf
    termux-reload-settings
    echo -e "${GREEN}[ ✔ ] Nerd Font Applied Successfully!${RESET}"
else
    echo -e "${RED}[ ✘ ] font.ttf not found in repository. Skipping UI sync.${RESET}"
fi

# --- [ STEP 4: PYTHON SETUP ] ---
echo -e "\n${BLUE}[ * ] Deploying Python Requirements...${RESET}"
pip install -r requirements.txt --break-system-packages
chmod +x main.py

# --- [ STEP 5: COMMAND SHORTCUT ] ---
BIN_DIR="$PREFIX/bin"
WIFIX_BIN="$BIN_DIR/$BIN_NAME"

cat > "$WIFIX_BIN" <<EOF
#!/data/data/com.termux/files/usr/bin/bash
cd "$SCRIPT_DIR" || exit

case "\$1" in
    update)
        echo -e "\033[1;32m[+] Updating WiFiX...\033[0m"
        git reset --hard HEAD && git pull origin main
        pip install -r requirements.txt --break-system-packages
        chmod +x main.py
        echo -e "\033[1;32m[✔] Updated! Restarting installer for sync...\033[0m"
        [ -f installer.sh ] && bash installer.sh
        ;;
    help) python help.py ;;
    fix) [ -f fix.sh ] && bash fix.sh || echo "Fix script missing!" ;;
    contact) python contact.py ;;
    menu) sudo python main.py ;;
    "") sudo python main.py -i wlan0 -K ;;
    *) sudo python main.py "\$@" ;;
esac
EOF

chmod +x "$WIFIX_BIN"

# --- [ FINAL SCREEN ] ---
clear
WIDTH=$(get_width)
echo -e "${GREEN}┏$(for ((i=0; i<WIDTH-2; i++)); do echo -n "━"; done)┓${RESET}"
draw_box_line "INSTALLATION SUCCESSFUL" "${WHITE}${BOLD}"
echo -e "${GREEN}┣$(for ((i=0; i<WIDTH-2; i++)); do echo -n "━"; done)┫${RESET}"
draw_box_line "Available Commands:" "${YELLOW}"
draw_box_line " - $BIN_NAME         : Run Tool" "${WHITE}"
draw_box_line " - $BIN_NAME update  : Update Tool" "${WHITE}"
draw_box_line " - $BIN_NAME menu    : Open Menu" "${WHITE}"
echo -e "${GREEN}┣$(for ((i=0; i<WIDTH-2; i++)); do echo -n "━"; done)┫${RESET}"
draw_box_line "Author : MOHAMMAD ALAMIN" "${CYAN}"
draw_box_line "Status : Ready to use" "${GREEN}"
echo -e "${GREEN}┗$(for ((i=0; i<WIDTH-2; i++)); do echo -n "━"; done)┛${RESET}"
echo -e "\n${WHITE}Type ${GREEN}${BIN_NAME}${WHITE} to start.${RESET}\n"
