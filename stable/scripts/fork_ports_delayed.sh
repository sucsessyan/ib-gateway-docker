#!/bin/sh

# Wait for Gateway startup
sleep 30

if [ "$TRADING_MODE" = "paper" ]; then
    LISTEN_PORT=4002
else
    LISTEN_PORT=4001
fi

echo "Starting API port forwarding: ${LISTEN_PORT} -> 4000"

while true; do
    socat "TCP4-LISTEN:${LISTEN_PORT},bind=0.0.0.0,reuseaddr,fork" \
          TCP4:127.0.0.1:4000

    echo "socat exited; retrying in 5 seconds"
    sleep 5
done