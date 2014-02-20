#!/bin/sh

NTPDATE=/usr/sbin/ntpdate
SERVER="IP ADDRESS"

# if running from cron (no tty available), sleep a bit to space
# out update requests to avoid slamming a server at a particular time
if ! test -t 0; then
  MYRAND=$RANDOM
  MYRAND=${MYRAND:=$$}

  if [ $MYRAND -gt 9 ]; then
    sleep `echo $MYRAND | sed 's/.*\(..\)$/\1/' | sed 's/^0//'`
  fi
fi

$NTPDATE -su $SERVER

# update hardware clock on Linux (RedHat?) systems
if [ -f /sbin/hwclock ]; then
  /sbin/hwclock --systohc
fi

