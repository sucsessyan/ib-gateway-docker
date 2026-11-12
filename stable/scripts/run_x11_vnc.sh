#!/bin/sh

# Wait for Xvfb display socket
for i in $(seq 1 30); do
    if [ -S /tmp/.X11-unix/X1 ]; then
        sleep 2
        break
    fi
    sleep 1
done

# Start VNC server
exec x11vnc \
    -ncache_cr \
    -display :1 \
    -forever \
    -shared \
    -logappend /var/log/x11vnc.log \
    -noipv6 \
    -passwd "$VNC_SERVER_PASSWORD"