import curses
import os
import shutil
import subprocess
import sys
import time

def install_termux(stdscr):
    # Exit curses temporarily
    curses.endwin()
    print("\n[+] Installing Termux Environment...")

    # Check for pkg
    if shutil.which("pkg") is None:
        print("[-] Error: 'pkg' command not found. Are you in Termux?")
        input("Press Enter to return to menu...")
        return

    commands = [
        "pkg update -y",
        "pkg upgrade -y",
        "pkg install -y fish starship eza bat jq rclone termux-api termux-x11-nightly xfce4 pulseaudio",
        "chsh -s fish"
    ]

    for cmd in commands:
        print(f"\n[Running] {cmd}")
        try:
            subprocess.run(cmd, shell=True, check=True)
        except subprocess.CalledProcessError as e:
            print(f"[-] Error running command: {cmd}")
            # Continue anyway? Or stop? Let's stop on critical errors.
            # But maybe not update/upgrade failure.
            if "install" in cmd:
                print("[-] Installation failed.")
                input("Press Enter to continue...")
                return

    # Backup existing config
    config_dir = os.path.expanduser("~/.config/fish")
    if os.path.exists(config_dir):
        backup_dir = f"{config_dir}_backup_{int(time.time())}"
        print(f"[+] Backing up existing fish config to {backup_dir}")
        shutil.move(config_dir, backup_dir)

    # Copy new config
    source_dir = os.path.join(os.getcwd(), "fish")
    if not os.path.exists(source_dir):
        print("[-] Error: 'fish' directory not found in current path.")
        input("Press Enter to continue...")
        return

    print(f"[+] Copying configuration from {source_dir} to {config_dir}")
    shutil.copytree(source_dir, config_dir)

    # Fix permissions? Usually copytree preserves permissions.

    print("\n[+] Termux Installation Complete!")
    print("    Please restart Termux for changes to take effect.")
    input("Press Enter to return to menu...")

def install_cachyos(stdscr):
    # Exit curses temporarily
    curses.endwin()
    print("\n[+] Installing CachyOS Environment (Cardinals)...")

    # Check for pacman
    if shutil.which("pacman") is None:
        print("[-] Error: 'pacman' command not found. Are you on an Arch-based system?")
        input("Press Enter to return to menu...")
        return

    # Check for sudo
    sudo_prefix = "sudo " if os.geteuid() != 0 else ""

    commands = [
        f"{sudo_prefix}pacman -Syu --noconfirm",
        f"{sudo_prefix}pacman -S --needed --noconfirm fish starship eza bat jq rclone"
    ]

    for cmd in commands:
        print(f"\n[Running] {cmd}")
        try:
            subprocess.run(cmd, shell=True, check=True)
        except subprocess.CalledProcessError as e:
            print(f"[-] Error running command: {cmd}")
            if "install" in cmd:
                print("[-] Installation failed.")
                input("Press Enter to continue...")
                return

    # Ask for DE
    print("\n[?] Which Desktop Environment would you like to install?")
    print("    1. KDE Plasma (plasma-meta)")
    print("    2. XFCE4 (xfce4)")
    print("    3. Gnome (gnome)")
    print("    4. Hyprland (hyprland)")
    print("    5. None (skip)")
    choice = input("    Enter choice [1-5]: ").strip()

    de_package = None
    if choice == '1':
        de_package = "plasma-meta"
    elif choice == '2':
        de_package = "xfce4"
    elif choice == '3':
        de_package = "gnome"
    elif choice == '4':
        de_package = "hyprland"

    if de_package:
        cmd = f"{sudo_prefix}pacman -S --needed --noconfirm {de_package}"
        print(f"\n[Running] {cmd}")
        try:
            subprocess.run(cmd, shell=True, check=True)
        except subprocess.CalledProcessError:
            print(f"[-] Failed to install {de_package}. Continuing...")

    # Backup existing config
    config_dir = os.path.expanduser("~/.config/fish")
    if os.path.exists(config_dir):
        backup_dir = f"{config_dir}_backup_{int(time.time())}"
        print(f"[+] Backing up existing fish config to {backup_dir}")
        shutil.move(config_dir, backup_dir)

    # Copy new config
    source_dir = os.path.join(os.getcwd(), "fish")
    if not os.path.exists(source_dir):
        print("[-] Error: 'fish' directory not found in current path.")
        input("Press Enter to continue...")
        return

    print(f"[+] Copying configuration from {source_dir} to {config_dir}")
    shutil.copytree(source_dir, config_dir)

    # Set default shell
    print("\n[+] Setting fish as default shell...")
    try:
        subprocess.run(f"chsh -s /usr/bin/fish", shell=True)
    except Exception as e:
        print(f"[-] Could not set default shell automatically: {e}")
        print("    You can run 'chsh -s /usr/bin/fish' manually.")

    print("\n[+] CachyOS Installation Complete!")
    print("    Please log out and log back in for changes to take effect.")
    input("Press Enter to return to menu...")

def main(stdscr):
    # Setup colors
    curses.start_color()
    curses.init_pair(1, curses.COLOR_CYAN, curses.COLOR_BLACK)
    curses.init_pair(2, curses.COLOR_RED, curses.COLOR_BLACK)
    curses.init_pair(3, curses.COLOR_BLACK, curses.COLOR_CYAN) # Highlight

    current_row = 0
    menu = ["Install Termux Environment", "Install CachyOS Environment (Cardinals)", "Exit"]

    while True:
        stdscr.clear()
        h, w = stdscr.getmaxyx()

        # Title
        title = " Fish Environment Installer "
        stdscr.attron(curses.color_pair(1) | curses.A_BOLD)
        stdscr.addstr(h//2 - 4, w//2 - len(title)//2, title)
        stdscr.attroff(curses.color_pair(1) | curses.A_BOLD)

        for idx, row in enumerate(menu):
            x = w//2 - len(row)//2
            y = h//2 - 2 + idx
            if idx == current_row:
                stdscr.attron(curses.color_pair(3))
                stdscr.addstr(y, x, row)
                stdscr.attroff(curses.color_pair(3))
            else:
                stdscr.addstr(y, x, row)

        stdscr.refresh()

        key = stdscr.getch()

        if key == curses.KEY_UP and current_row > 0:
            current_row -= 1
        elif key == curses.KEY_DOWN and current_row < len(menu) - 1:
            current_row += 1
        elif key == curses.KEY_ENTER or key in [10, 13]:
            if current_row == 0:
                install_termux(stdscr)
            elif current_row == 1:
                install_cachyos(stdscr)
            elif current_row == 2:
                break

            # Re-init curses after returning from install functions (since we called endwin())
            # Actually, standard practice is just to clear and refresh, but endwin() might need restore.
            # curses.wrapper handles basic restore, but re-entering curses mode manually is tricky inside wrapper.
            # However, since we're just printing to stdout/stderr in install functions,
            # and wrapper restores terminal state on exit,
            # we might need to manually reset terminal state if we want to redraw the menu.
            # A simpler way is to re-invoke curses logic or just loop.
            # But endwin() doesn't fully kill curses, just restores terminal.
            # To resume, we usually just call refresh() or similar.
            # Let's try just loop and refresh.

if __name__ == "__main__":
    curses.wrapper(main)
