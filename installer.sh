#!/data/data/com.termux/files/usr/bin/bash

# --- কনফিগারেশন ও কালার ভেরিয়েবল ---
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
RED="\033[1;31m"
RESET="\033[0m"

REPO_URL="https://github.com/ITSMEALAMINBRO/WiFiX"
REPO_NAME="WiFiX"
BIN_DIR="$PREFIX/bin"
WiFiX_BIN="$BIN_DIR/wifix"
SCRIPT_DIR="$(pwd)"
FIX_URL="https://github.com/msrofficial/fix-termux-root"

# --- হেল্পার ফাংশনসমূহ ---
print_status() {
    echo -e "${GREEN}[+] $1${RESET}"
}

print_warning() {
    echo -e "${YELLOW}[!] $1${RESET}"
}

# --- ১. প্যাকেজ আপডেট এবং ইন্সটলেশন ---
print_status "Updating packages..."
pkg update -y && pkg upgrade -y

print_status "Installing required dependencies..."
pkg install root-repo -y
pkg install git tsu python wpa-supplicant pixiewps iw -y

# --- ২. রিপোজিটরি সেটআপ ---
if [ ! -d "$REPO_NAME" ] && [ ! -f "main.py" ]; then
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
