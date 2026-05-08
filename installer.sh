#!/data/data/com.termux/files/usr/bin/bash

# ─────────────────────────────────────────────
#  WiFiX Installer — Optimized & Clean Version
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

# --- [ ENVIRONMENT SETUP ] ---
echo -e "\n${BLUE}[ i ] Config: Nerd Font Environment...${RESET}"
if [ -f "font.ttf" ]; then
    mkdir -p ~/.termux/
    cp font.ttf ~/.termux/font.ttf
    termux-reload-settings
    echo -e "${GREEN}[ ✔ ] Nerd Font Applied!${RESET}"
else
    echo -e "${YELLOW}[ ! ] font.ttf not found. Skipping font setup.${RESET}"
fi

# --- [ SYSTEM UPDATE ] ---
echo -e "\n${BLUE}[ * ] Syncing Repositories...${RESET}"
pkg update -y && pkg upgrade -y

echo -e "\n${BLUE}[ * ] Installing Core Dependencies...${RESET}"
pkg install root-repo -y
pkg install git tsu python wpa-supplicant pixiewps iw -y

# --- [ REPO SETUP ] ---
if [ ! -d "$REPO_NAME" ] && [ ! -f "main.py" ]; then
    echo -e "\n${YELLOW}[ * ] Cloning Source from GitHub...${RESET}"
    git clone "$REPO_URL"
    cd "$REPO_NAME" || exit
elif [ -d "$REPO_NAME" ]; then
    cd "$REPO_NAME" || exit
fi

# Current Directory Update
SCRIPT_DIR="$(pwd)"

# --- [ PYTHON SETUP ] ---
echo -e "\n${BLUE}[ * ] Deploying Python Requirements...${RESET}"
pip install -r requirements.txt --break-system-packages
chmod +x main.py

# --- [ COMMAND SHORTCUT CREATION ] ---
BIN_DIR="$PREFIX/bin"
WIFIX_BIN="$BIN_DIR/$BIN_NAME"

echo -e "${BLUE}[ * ] Creating '$BIN_NAME' command shortcut...${RESET}"

cat > "$WIFIX_BIN" <<EOF
#!/data/data/com.termux/files/usr/bin/bash
cd "$SCRIPT_DIR" || exit

# WiFiX Command Switcher
case "\$1" in
    update)
        echo -e "${GREEN}[+] Fetching updates...${RESET}"
        git reset --hard HEAD && git pull origin main
        pip install -r requirements.txt --break-system-packages
        chmod +x main.py
        echo -e "${GREEN}[✔] Successfully Updated!${RESET}"
        ;;
    help)
        python help.py
        ;;
    fix)
        if [ -f fix.sh ]; then bash fix.sh; else echo "Fix script not found!"; fi
        ;;
    contact)
        python contact.py
        ;;
    menu)
        sudo python main.py
        ;;
    "")
        # Default Run
        sudo python main.py -i wlan0 -K
        ;;
    *)
        # Custom Arguments
        sudo python main.py "\$@"
        ;;
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
draw_box_line " - wifix         : Run Tool" "${WHITE}"
draw_box_line " - wifix update  : Update Tool" "${WHITE}"
draw_box_line " - wifix help    : User Guide" "${WHITE}"
draw_box_line " - wifix fix     : Fix Root" "${WHITE}"
draw_box_line " - wifix menu    : Open Menu" "${WHITE}"
echo -e "${GREEN}┣$(for ((i=0; i<WIDTH-2; i++)); do echo -n "━"; done)┫${RESET}"
draw_box_line "Author : MOHAMMAD ALAMIN" "${CYAN}"
draw_box_line "Status : Ready to use" "${GREEN}"
echo -e "${GREEN}┗$(for ((i=0; i<WIDTH-2; i++)); do echo -n "━"; done)┛${RESET}"
echo -e "\n${WHITE}Type ${GREEN}${BIN_NAME}${WHITE} to start your journey.${RESET}\n"
    print_status "Cloning $REPO_NAME repository..."
    git clone "$REPO_URL"
    cd "$REPO_NAME" || exit
elif [ -d "$REPO_NAME" ]; then
    cd "$REPO_NAME" || exit
fi

# বর্তমান ডিরেক্টরি আপডেট করা (যদি ক্লোন করা হয়)
SCRIPT_DIR="$(pwd)"

# --- ৩. পাইথন ডিপেন্ডেন্সি ইন্সটল ---
print_status "Installing Python dependencies..."
pip install -r requirements.txt --break-system-packages
chmod +x main.py

# --- ৪. কমান্ড শর্টকাট (wifix) তৈরি করা ---
print_status "Setting up 'wifix' command..."

cat > "$WiFiX_BIN" <<EOF
#!/data/data/com.termux/files/usr/bin/bash
cd "$SCRIPT_DIR" || exit

case "\$1" in
    update)
        echo -e "${GREEN}[+] Fetching latest updates from MSR's GitHub...${RESET}"
        git reset --hard HEAD > /dev/null 2>&1
        git pull origin main
        echo -e "${GREEN}[+] Checking for new requirements...${RESET}"
        pip install -r requirements.txt --break-system-packages > /dev/null 2>&1
        chmod +x main.py
        echo -e "${GREEN}[+] Re-applying setup...${RESET}"
        bash install.sh > /dev/null 2>&1
        echo -e "${GREEN}[✓] WiFiX updated successfully!${RESET}"
        ;;
    help)
        python help.py
        ;;
    fix)
        bash fix.sh
        ;;
    contact)
        python contact.py
        ;;
    menu)
        sudo python main.py
        ;;
    old)
        sudo python w1.py -i wlan0 -K
        ;;
    "")
        sudo python main.py -i wlan0 -K
        ;;
    *)
        sudo python main.py "\$@"
        ;;
esac
EOF

chmod +x "$WiFiX_BIN"

# --- ৫. সাকসেস মেসেজ ও ইউজার গাইড ---
echo -e "\n${GREEN}[✓] Setup complete successfully!${RESET}"
echo -e "${YELLOW}[✓] No restart needed.${RESET}"

echo -e "\n${CYAN}╔══════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║           📌  READ THIS CAREFULLY            ║${RESET}"
echo -e "${CYAN}╚══════════════════════════════════════════════╝${RESET}"
echo -e "${YELLOW}  ⚠️  Take a screenshot of the info below now!${RESET}"

echo -e "\n${GREEN}  ┌─ Available Commands ──────────────────────┐${RESET}"
echo -e "${GREEN}  │${RESET}  ${WHITE}wifix${RESET}         → Run WiFiX (main tool)"
echo -e "${GREEN}  │${RESET}  ${WHITE}wifix update${RESET}  → Update WiFiX to latest"
echo -e "${GREEN}  │${RESET}  ${WHITE}wifix help${RESET}    → Show help info"
echo -e "${GREEN}  │${RESET}  ${WHITE}wifix fix${RESET}     → Fix root/superuser issues"
echo -e "${GREEN}  │${RESET}  ${WHITE}wifix menu${RESET}    → Run interactive menu"
echo -e "${GREEN}  └───────────────────────────────────────────┘${RESET}"

echo -e "\n${RED}  ⚡ IMPORTANT — If root fails:${RESET}"
echo -e "${WHITE}     \"no superuser binary detected\"${RESET}"
echo -e "${YELLOW}  → Try: ${WHITE}wifix fix${RESET}"
echo -e "${YELLOW}  → Or visit: ${CYAN}$FIX_URL${RESET}"

echo -e "\n${CYAN}══════════════════════════════════════════════${RESET}"
echo -e "${GREEN}  ✅ All done! Type 'wifix' to start.${RESET}"
echo -e "${CYAN}══════════════════════════════════════════════${RESET}\n"
