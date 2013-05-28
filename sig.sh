#!/bin/sh
# chkconfig: 2345 85 15
# description: Starts and stops the redis daemon that handles \
#              all redis session requests.

EXEC="/usr/local/bin/node"
PIDFILE=/var/run/sig.pid
CONF="/var/www/sig/trunk/sig.js"

start() {
    if [ -s $PIDFILE ]
        then
                echo "$PIDFILE exists, process is already running or crashed"
        else
                echo "Starting $PIDFILE..."
                nohup $EXEC $CONF > /dev/null 2>&1 &
                echo $! > $PIDFILE
        fi
}

stop() {
    if [ ! -s $PIDFILE ]
        then
                echo "$PIDFILE does not exist, process is not running"
        else
                echo "Stopping $PIDFILE..."
                kill `cat $PIDFILE`
                cat /dev/null > $PIDFILE
        fi
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    *)
        echo "Please use start or stop as first argument"
        ;;
esac

exit 0
