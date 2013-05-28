#!/bin/sh

# chkconfig: 2345 95 20
# description: Start sig server
# processname: sig

node="/usr/local/bin/node"
script="/var/www/sig/trunk/sig.js"
log="/var/log/sig/sig.log"
server="sig"


do_start()
{
    echo -n "Starting $server: "
   `$node $script >> $log 2>&1 &` && echo "Success" || echo "Fail"
}
do_stop()
{
    echo -n "Stopping $server: "
    pid=`ps ax | grep -i 'node' | grep -i 'sig.js' | awk '{print $1}'`
    kill -9 $pid && echo "Success" || echo "Fail"
}

case "$1" in
    start)
        do_start
        ;;
    stop)
        do_stop
        ;;
    restart)
        do_stop
        do_start
        ;;
    *)
    echo "Usage: $0 {start|stop|restart}"
esac
