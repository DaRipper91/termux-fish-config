function xfce
    echo "[-] Killing zombies..."
    killall -9 termux-x11 xfce4-session dbus-daemon 2>/dev/null
    
    echo "[-] Starting X11 on FRESH Display :4..."
    # We switch to :4 to dodge the stuck socket on :2
    termux-x11 :4 &
    
    echo "[-] Waiting for socket :4..."
    # We wait specifically for the new socket
    for i in (seq 1 10)
        if test -e /data/data/com.termux/files/usr/tmp/.X11-unix/X4
            break
        end
        sleep 0.5
    end
    
    echo "[-] Launching XFCE..."
    # We tell the desktop to paint on :4
    env DISPLAY=:4 dbus-launch --exit-with-session xfce4-session & disown
end
