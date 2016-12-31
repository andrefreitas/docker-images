#!/bin/bash
set -e

NAGIOS_BIN=/usr/local/nagios/bin/nagios
NAGIOS_CFG=/usr/local/nagios/etc/nagios.cfg

if [ "$1" = 'check' ]; then
  $NAGIOS_BIN -v $NAGIOS_CFG
elif [ "$1" = 'reload' ]; then
  $NAGIOS_BIN -pv $NAGIOS_CFG
else
  $NAGIOS_BIN -pv $NAGIOS_CFG
  $NAGIOS_BIN -u $NAGIOS_CFG &
  apache2-foreground
fi
