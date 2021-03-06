#!/bin/sh

### BEGIN INIT INFO
# Provides:          pws_main
# Required-Start:    $network $remote_fs $syslog $all
# Required-Stop:     $network $remote_fs $syslog $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Phidget Weather Station
# Description:       Connects to Phidget Interface Kit and logs weather station measurements.
### END INIT INFO


# Change the next 3 lines to suit where you install your script and what you want to call it
DIR=/usr/userapps/pws
DAEMON=$DIR/controller_pws_main.py
DAEMON_NAME=pws_main

# This next line determines what user the script runs as.
# Root generally not recommended but necessary if you are using the Raspberry Pi GPIO from Python.
DAEMON_USER=root

# The process ID of the script when it runs is stored here:
PIDFILE=/var/run/$DAEMON_NAME.pid

. /lib/lsb/init-functions

do_start () {
    log_daemon_msg "Starting system $DAEMON_NAME daemon"
    start-stop-daemon --start --background --pidfile $PIDFILE --make-pidfile --user $DAEMON_USER --chuid $DAEMON_USER --startas $DAEMON --chdir $DIR
    log_end_msg $?
}
do_stop () {
    log_daemon_msg "Stopping system $DAEMON_NAME daemon"
    start-stop-daemon --stop --pidfile $PIDFILE --retry 10
    log_end_msg $?
}

case "$1" in

    start|stop)
        do_${1}
        ;;

    restart|reload|force-reload)
        do_stop
        do_start
        ;;

    status)
        status_of_proc "$DAEMON_NAME" "$DAEMON" && exit 0 || exit $?
        ;;

    daemon)
        echo "$DAEMON"
        ;;

    directory)
        echo "$DIR"
        ;;

    *)
        echo "Usage:"
        echo "/etc/init.d/$DAEMON_NAME {start|stop|restart|status}"
        echo " - get current status or change status"
        echo "/etc/init.d/$DAEMON_NAME daemon"
        echo " - print path of daemon executable"
        echo "/etc/init.d/$DAEMON_NAME directory"
        echo " - print path of directory where daemon executable is stored"
        exit 1
        ;;

esac
exit 0
