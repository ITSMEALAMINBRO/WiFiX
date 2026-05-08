#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#--- [ IMPORT MODULES ] ---#
import sys
import subprocess
import os
import time

#--- [ SYSTEM FUNCTIONS ] ---#
def clear():
    os.system('clear' if os.name == 'posix' else 'cls')

def get_line():

    try:
        width = os.get_terminal_size().columns
    except:
        width = 54
    return f"{blue}{'━' * width}{reset}"

#--- [ COLOR CODES ] ---#
green  = "\033[1;32m"
white  = "\033[1;97m"
blue   = "\033[1;34m"
red    = "\033[1;31m" 
yellow = "\033[1;33m"
pink   = "\033[1;35m"
cyan   = "\033[1;36m"
reset  = "\033[0m"

#--- [ NERD FONT ICONS ] ---#
fbb    = "\uf09a" # Facebook
wpp    = "\uf232" # WhatsApp
tgg    = "\uf1d8" # Telegram
ghh    = "\uf09b" # GitHub
tool   = "\uf0ad" # Tool Icon
select = "\uf00c" # Select Icon
lod    = "\uf013" # Loading Icon
err    = "\uf00d" # Error Icon
pwr    = "\uf011" # Exit Icon
done   = "\uf00c" # Success Icon
star   = "\uf005" # Star Icon

#--- [ COMBINED VARIABLES ] ---#
FB_ICON   = f"{blue}{fbb}{reset}"
WA_ICON   = f"{green}{wpp}{reset}"
TG_ICON   = f"{cyan}{tgg}{reset}"
GH_ICON   = f"{white}{ghh}{reset}"
TOOL_ICON = f"{pink}{tool}{reset}"
SELECT    = f"{pink}{select} {white}"
OPENING   = f"{yellow}{lod} {white}"
ERROR     = f"{red}{err} {white}"
EXIT      = f"{red}{pwr} {white}"
SUCCESS   = f"{green}{done} {white}"
STAR      = f"{yellow}{star}{reset}"

# ─────────────────────────────────────────────
#  Social Media Links — MOHAMMAD ALAMIN 
# ─────────────────────────────────────────────
CONTACTS = {
    1: {"name": "Facebook",   "url": "https://m.facebook.com/MOHAMMADALAMIN2K7", "icon": FB_ICON},
    2: {"name": "WhatsApp",   "url": "https://wa.me/+8801748473269", "icon": WA_ICON},
    3: {"name": "Telegram",   "url": "https://t.me/ALAMIN2K7", "icon": TG_ICON},
    4: {"name": "GitHub",     "url": "https://github.com/ALAMIN2K7", "icon": GH_ICON},
    5: {"name": "Open Tool (WiFiX)", "url": "wifix", "icon": TOOL_ICON},
}

def main_banner():
    clear()
    full_line = get_line()

    banner_art = r'''
╔═════════════════════════════════════════════════════════╗
║         ╔╗╔╗╔╗╔══╗╔═══╗╔══╗⌔╔╗ ╔╗╔═══╗╔═══╗╔╗╔═╗        ║
║         ║║║║║║╚╣╠╝║╔══╝╚╣╠╝ ║║ ║║║╔═╗║║╔═╗║║║║╔╝        ║
║         ║║║║║║ ║║ ║╚══╗ ║║  ║╚═╝║║║ ║║║║ ╚╝║╚╝╝         ║
║         ║╚╝╚╝║ ║║ ║╔══╝ ║║  ║╔═╗║║╚═╝║║║ ╔╗║╔╗║         ║
║         ╚╗╔╗╔╝╔╣╠╗║║   ╔╣╠╗ ║║ ║║║╔═╗║║╚═╝║║║║╚╗        ║
║          ╚╝╚╝ ╚══╝╚╝   ╚══╝ ╚╝ ╚╝╚╝ ╚╝╚═══╝╚╝╚═╝        ║
╚═════════════════════════════════════════════════════════╝'''

    info = f"""{full_line}
                 {STAR} Official Contact Menu {STAR}
{full_line}"""

    os.system(f'echo "{banner_art}\n{info}" | lolcat 2>/dev/null || echo "{banner_art}\n{info}"')
    print(" ")

def open_url(url):
    try:
        subprocess.run(['termux-open-url', url], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    except:
        try:
            subprocess.run(['xdg-open', url], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        except:
            print(f"\n{ERROR}Visit manually: {green}{url}")

def run_tool(command):
    print(f"\n{OPENING}Starting {pink}{command}{white}...")
    time.sleep(1)
    try:

        subprocess.run([command])
    except FileNotFoundError:
        print(f"\n{ERROR}Command '{command}' not found!")
        time.sleep(2)

def main():
    while True:
        main_banner()
        
        title = "PLATFORM LIST"
        try:
            width = os.get_terminal_size().columns
        except:
            width = 54
        
        div = "━" * ((width - len(title) - 2) // 2)
        print(f"{blue}{div}{white} {title} {blue}{div}{reset}")
        

        for num, info in sorted(CONTACTS.items()):
            print(f"  {cyan}[{green}{num}{cyan}] {info['icon']} {yellow}{info['name']}{reset}")
        
        print(f"  {cyan}[{red}0{cyan}] {EXIT} {red}Exit{reset}")
        print(f"{get_line()}\n")

        try:
            choice = input(f"{SELECT}Select a platform {white}-> ").strip()

            if choice == '':
                continue

            if choice in ('0', 'q', 'exit'):
                print(f"\n{EXIT}Closing... Stay with us!\n")
                break

            num = int(choice)

            if num in CONTACTS:
                selected = CONTACTS[num]
                if num == 5:
                    run_tool(selected['url'])
                else:
                    print(f"\n{OPENING}Opening {green}{selected['name']}{white}...")
                    time.sleep(1)
                    open_url(selected['url'])
                    print(f"{SUCCESS}Done!{reset}")
                    time.sleep(1.5)
            else:
                print(f"\n{ERROR}Invalid Option!{reset}")
                time.sleep(1)

        except (ValueError, KeyboardInterrupt):
            if isinstance(sys.exc_info()[0], KeyboardInterrupt):
                print(f"\n\n{EXIT}Exiting...{reset}")
                break
            print(f"\n{ERROR}Numbers only!{reset}")
            time.sleep(1)

if __name__ == '__main__':
    main()
