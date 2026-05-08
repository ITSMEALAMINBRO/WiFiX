#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# ─────────────────────────────────────────────
#  WIFIX Help Guide — by MOHAMMAD ALAMIN
# ─────────────────────────────────────────────

import sys
import subprocess
import os
import time

# ── [ SYSTEM FUNCTIONS ] ─────────────────────
def clear():
    os.system('clear' if os.name != 'nt' else 'cls')

def get_line():
    try:
        width = os.get_terminal_size().columns
    except:
        width = 60
    return f"{blue}{'━' * width}{reset}"

# ── [ COLOR CODES ] ──────────────────────────
green  = "\033[1;32m"
white  = "\033[1;97m"
blue   = "\033[1;34m"
red    = "\033[1;31m" 
yellow = "\033[1;33m"
pink   = "\033[1;35m"
cyan   = "\033[1;36m"
reset  = "\033[0m"

# ── [ NERD FONT ICONS ] ──────────────────────
info_ico   = "\uf05a" # Info
warn_ico   = "\uf071" # Warning
tip_ico    = "\uf005" # Star/Tip
cmd_ico    = "\uf120" # Terminal/Command
done_ico   = "\uf00c" # Success
err_ico    = "\uf00d" # Error
pwr_ico    = "\uf011" # Exit
tool_ico   = "\uf0ad" # Tool

# ── [ COMBINED VARIABLES ] ───────────────────
INFO  = f"{blue}{info_ico} {white}"
WARN  = f"{yellow}{warn_ico} {white}"
TIP   = f"{pink}{tip_ico} {white}"
CMD   = f"{cyan}{cmd_ico} {white}"
DONE  = f"{green}{done_ico} {white}"
ERR   = f"{red}{err_ico} {white}"
EXIT  = f"{red}{pwr_ico} {white}"
TOOL  = f"{blue}{tool_ico} {white}"

# ── [ BANNER ] ───────────────────────────────
def main_banner():
    clear()
    line = get_line()
    banner_art = r'''
╔═════════════════════════════════════════════════════════╗
║         ╔╗╔╗╔╗╔══╗╔═══╗╔══╗⌔╔╗ ╔╗╔═══╗╔═══╗╔╗╔═╗        ║
║         ║║║║║║╚╣╠╝║╔══╝╚╣╠╝ ║║ ║║║╔═╗║║╔═╗║║║║╔╝        ║
║         ║║║║║║ ║║ ║╚══╗ ║║  ║╚═╝║║║ ║║║║ ╚╝║╚╝╝         ║
║         ║╚╝╚╝║ ║║ ║╔══╝ ║║  ║╔═╗║║╚═╝║║║ ╔╗║╔╗║         ║
║         ╚╗╔╗╔╝╔╣╠╗║║   ╔╣╠╗ ║║ ║║║╔═╗║║╚═╝║║║║╚╗        ║
║          ╚╝╚╝ ╚══╝╚╝   ╚══╝ ╚╝ ╚╝╚╝ ╚╝╚═══╝╚╝╚═╝        ║
╚═════════════════════════════════════════════════════════╝'''

    info_text = f"""{line}
              {TIP} Official Help Guide (WIFIX) {TIP}
{line}"""
    
    os.system(f'echo "{banner_art}\n{info_text}" | lolcat 2>/dev/null || echo "{banner_art}\n{info_text}"')

def pause():
    print(f"\n{get_line()}")
    input(f"  {INFO}Press {green}Enter{white} to go back to menu...")

# ─────────────────────────────────────────────
def show_menu():
    main_banner()
    title = "HELP TOPICS"
    try:
        width = os.get_terminal_size().columns
    except:
        width = 60
    
    side_line = "━" * ((width - len(title) - 2) // 2)
    print(f"{blue}{side_line}{white} {title} {blue}{side_line}{reset}")
    
    menu_options = [
        "What is WIFIX? Introduction",
        "How to Install / Setup",
        "Interface & How to find it",
        "All Attack Modes explained",
        "Full Command List (A-Z)",
        "Usage Examples (Copy-Paste)",
        "Troubleshooting Errors",
        "Important Warnings & Rules",
        "Quick Command Reference",
        "Open Tool (Run WIFIX)"  # ১০ নম্বর অপশন
    ]
    
    for i, opt in enumerate(menu_options, 1):
        num_color = green if i < 10 else pink
        print(f"  {cyan}[{num_color}{i}{cyan}] {yellow}{opt}{reset}")
    
    print(f"  {cyan}[{red}0{cyan}] {EXIT} {red}Exit Help{reset}")
    print(f"{get_line()}\n")
    return input(f"  {TIP}Your choice {white}-> ").strip()

# ── [ SECTIONS ] ─────────────────────────────
def section_intro():
    main_banner()
    print(f"  {yellow}1. Introduction to WIFIX{reset}\n")
    print(f"  {INFO}WIFIX is a WPS security testing tool for Termux.")
    print(f"  {INFO}It tests vulnerabilities on authorized routers.")
    print(f"\n  {CMD}{green}Capabilities:{reset}")
    print(f"  {DONE} Pixie Dust Attack (Fast)")
    print(f"  {DONE} Bruteforce Attack (Reliable)")
    print(f"  {DONE} Network Scanner & Session Resume")
    pause()

def section_install():
    main_banner()
    print(f"  {yellow}2. Installation Steps{reset}\n")
    print(f"  {CMD}{cyan}pkg update && pkg upgrade{reset}")
    print(f"  {CMD}{cyan}pkg install python root-repo{reset}")
    print(f"  {CMD}{cyan}pkg install wpa-supplicant pixiewps{reset}")
    print(f"  {CMD}{cyan}su -c python main.py -i wlan0{reset}")
    print(f"\n  {WARN}Root access is strictly required!")
    pause()

def section_interface():
    main_banner()
    print(f"  {yellow}3. Finding Your Interface{reset}\n")
    print(f"  {INFO}Common names: {green}wlan0, wlan1{reset}")
    print(f"  {CMD}{cyan}ip link show{reset}")
    print(f"  {CMD}{cyan}iwconfig{reset}")
    pause()

def section_attacks():
    main_banner()
    print(f"  {yellow}4. Attack Modes{reset}\n")
    print(f"  {TIP}{green}Pixie Dust (-K):{reset} Offline PIN extraction (Seconds)")
    print(f"  {TIP}{green}Bruteforce (-B):{reset} Trying all PINs (Hours)")
    print(f"  {TIP}{green}PBC Mode (--pbc):{reset} Connect via WPS button")
    pause()

def section_commands():
    main_banner()
    print(f"  {yellow}5. Full Argument List{reset}\n")
    print(f"  {green}-i, --interface{reset} : Network Interface")
    print(f"  {green}-b, --bssid{reset}     : Target MAC Address")
    print(f"  {green}-K, --pixie-dust{reset}: Run Pixie Attack")
    print(f"  {green}-B, --bruteforce{reset}: Run Bruteforce")
    print(f"  {green}-v, --verbose{reset}   : Debugging info")
    pause()

def section_examples():
    main_banner()
    print(f"  {yellow}6. Usage Examples{reset}\n")
    print(f"  {CMD}python main.py -i wlan0 -K")
    print(f"  {CMD}python main.py -i wlan0 -b AA:BB:CC... -B")
    print(f"  {CMD}python main.py -i wlan0 -B -d 2 (Delay)")
    pause()

def section_troubleshoot():
    main_banner()
    print(f"  {yellow}7. Troubleshooting{reset}\n")
    print(f"  {ERR}'Run as root' -> Type {cyan}su{reset} before running.")
    print(f"  {ERR}'wpa_supplicant' error -> Run {cyan}pkill wpa_supplicant{reset}")
    print(f"  {ERR}'rfkill' blocked -> Use {cyan}--handle-rfkill{reset} flag.")
    pause()

def section_warnings():
    main_banner()
    print(f"  {red}8. Legal Warnings{reset}\n")
    print(f"  {WARN}Testing without permission is {red}ILLEGAL{reset}.")
    print(f"  {WARN}Only for Educational/Authorized use.")
    print(f"  {TIP}Author: {white}MOHAMMAD ALAMIN{reset}")
    pause()

def section_quick():
    main_banner()
    print(f"  {yellow}9. Quick Commands{reset}\n")
    print(f"  {green}wifix {reset}       : Run tool")
    print(f"  {green}wifix fix{reset}     : Fix root issues")
    print(f"  {green}wifix help{reset}    : Open this guide")
    pause()

def open_tool():
    main_banner()
    print(f"  {TOOL}{yellow}Starting WiFiX Tool...{reset}")
    time.sleep(1.5)
    try:
        subprocess.run(['wifix'])
    except FileNotFoundError:
        print(f"\n  {ERR}{red}Command 'wifix' not found!{reset}")
        print(f"  {INFO}Make sure the tool is installed and shortcut is created.")
        time.sleep(2)
    except Exception as e:
        print(f"\n  {ERR}Error: {e}")
        time.sleep(2)

# ── [ MAIN LOOP ] ─────────────────────────────
def main():
    handlers = {
        '1': section_intro,
        '2': section_install,
        '3': section_interface,
        '4': section_attacks,
        '5': section_commands,
        '6': section_examples,
        '7': section_troubleshoot,
        '8': section_warnings,
        '9': section_quick,
        '10': open_tool,
    }

    while True:
        choice = show_menu()
        if choice == '0':
            clear()
            print(f'\n  {TIP}{pink}Thanks for using WIFIX! {reset}\n')
            sys.exit(0)
        elif choice == '':
            continue
        elif choice in handlers:
            handlers[choice]()
        else:
            print(f'  {ERR}{red}Invalid choice!{reset}')
            time.sleep(1)

if __name__ == '__main__':
    main()
