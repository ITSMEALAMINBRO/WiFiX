#!/bin/bash

# ─────────────────────────────────────────────
#  WiFiX Root Fixer — by MOHAMMAD ALAMIN
# ─────────────────────────────────────────────

# --- [ COLOR CODES ] ---
green='\e[1;32m'
white='\e[1;97m'
blue='\e[1;34m'
red='\e[1;31m'
yellow='\e[1;33m'
pink='\e[1;35m'
cyan='\e[1;36m'
reset='\e[0m'
bold='\e[1m'

# --- [ ICONS ] ---
info_ico="ⓘ"
warn_ico="⚠"
tip_ico="★"
done_ico="✔"
err_ico="✘"

# --- [ TRAP FOR INTERRUPT ] ---
trap 'echo -e "\n${yellow}[ ! ] Script interrupted. Exiting...${reset}"; exit 1' SIGINT

# --- [ SYSTEM FUNCTIONS ] ---
clear_screen() {
    clear
}

get_line() {
    local width=$(tput cols 2>/dev/null)
    : "${width:=54}"
    local line=""
    for ((i=1; i<=width; i++)); do line="${line}━"; done
    echo -e "${blue}${line}${reset}"
}

success() { echo -e "${green}[ ${done_ico} ]${reset} ${green}${1}${reset}"; }
warn() { echo -e "${yellow}[ ${warn_ico} ]${reset} ${yellow}${1}${reset}"; }
error() { echo -e "${red}[ ${err_ico} ]${reset} ${red}${1}${reset}"; }

# --- [ BANNER ] ---
main_banner() {
    clear_screen
    local line=$(get_line)
    echo -e "${green}${bold}"
    cat << "EOF"
╔═════════════════════════════════════════════════════════╗
║         ╔╗╔╗╔╗╔══╗╔═══╗╔══╗⌔╔╗ ╔╗╔═══╗╔═══╗╔╗╔═╗        ║
║         ║║║║║║╚╣╠╝║╔══╝╚╣╠╝ ║║ ║║║╔═╗║║╔═╗║║║║╔╝        ║
║         ║║║║║║ ║║ ║╚══╗ ║║  ║╚═╝║║║ ║║║║ ╚╝║╚╝╝         ║
║         ║╚╝╚╝║ ║║ ║╔══╝ ║║  ║╔═╗║║╚═╝║║║ ╔╗║╔╗║         ║
║         ╚╗╔╗╔╝╔╣╠╗║║   ╔╣╠╗ ║║ ║║║╔═╗║║╚═╝║║║║╚╗        ║
║          ╚╝╚╝ ╚══╝╚╝   ╚══╝ ╚╝ ╚╝╚╝ ╚╝╚═══╝╚╝╚═╝        ║
╚═════════════════════════════════════════════════════════╝
EOF
    echo -e "${reset}"
    echo -e "${line}"
    echo -e "              ${pink}${tip_ico}${white} Official Root Fixer (WiFiX) ${pink}${tip_ico}${reset}"
    echo -e "${line}"
}

# --- [ SPINNER FUNCTION ] ---
run_with_spinner() {
  local msg="$1"
  shift
  "$@" > /dev/null 2>&1 &
  local pid=$!
  local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  
  while kill -0 $pid 2>/dev/null; do
    for ((i=0; i<=9; i++)); do
      echo -ne "\r${green}[ ${spinstr:i:1} ]${reset} ${yellow}${msg}...${reset}"
      sleep 0.1
    done
  done
  
  wait $pid
  local status=$?
  echo -ne "\r\033[K" 
  return $status
}

# --- [ EXECUTION ] ---
main_banner

run_with_spinner "Purging conflicting binaries (tsu)" pkg uninstall tsu -y
run_with_spinner "Syncing repositories & upgrading core" bash -c "pkg update -y && pkg upgrade -y"
run_with_spinner "Injecting 'sudo' environment" pkg install sudo -y

echo -e "\n${green}[ * ]${reset} ${yellow}Checking Root Status...${reset}"

root_matrix() {
  if [ "$(id -u 2>/dev/null)" = "0" ] || (command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null); then
    success "Root access verified."
    return 0
  fi

  SU_PATHS=(/system/bin/su /system/xbin/su /sbin/su /su/bin/su /magisk/.core/bin/su /data/adb/magisk/su)
  for path in "${SU_PATHS[@]}"; do
    if [ -x "$path" ]; then
      success "Root binary found at $path"
      return 0
    fi
  done

  error "Root not detected. Please grant permission in Magisk/KernelSU."
  return 1
}

root_matrix

echo -e "\n${cyan}[ ${tip_ico} ]${reset} ${white}Fixing complete! Launching WiFiX...${reset}"
sleep 2

# --- [ AUTOMATIC TOOL RUN ] ---
if command -v wifix >/dev/null 2>&1; then
    exec wifix
elif [ -f "./main.py" ]; then

    exec python main.py
else
    echo -e "${red}[ ${err_ico} ]${reset} ${yellow}Error: 'wifix' command not found.${reset}"
    echo -e "${white}Hint: Try running 'python main.py' or check installation.${reset}"
    exit 1
fi
