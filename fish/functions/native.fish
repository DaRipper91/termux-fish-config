function native
    # Kill any hanging native sessions to keep it clean
    killall -9 termux-x11 xfce4-session 2>/dev/null
    
    # Start audio server
    pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
    
    # Start X11 on Display :2
    termux-x11 :2 -xstartup "xfce4-session" &
    
    echo "[-] Native Desktop Launching on Display :2..."
end
