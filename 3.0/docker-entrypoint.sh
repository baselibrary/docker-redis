#!/bin/bash

#enable job control in script
set -e -m

#####   variables  #####

# add command if needed
if [ "${1:0:1}" = '-' ]; then
  set -- redis-server "$@"
fi

#run command in background
if [ "$1" = 'redis-server' ]; then
  ##### pre scripts  #####
  echo "========================================================================"
  echo "initialize:"
  echo "========================================================================"
  # set listen addresses
  /usr/bin/ansible local -o -c local -m lineinfile  -a "dest=/etc/redis/redis.conf regexp='^(bind\s*)\S+' line='bind 0.0.0.0'"
  /usr/bin/ansible local -o -c local -m lineinfile  -a "dest=/etc/redis/redis.conf regexp='^(daemonize\s*)\S+' line='daemonize no'"
  /usr/bin/ansible local -o -c local -m lineinfile  -a "dest=/etc/redis/redis.conf regexp='^(logfile\s*)\S+' line='logfile /dev/stdout'"
  
  ##### run scripts  #####
  echo "========================================================================"
  echo "startup:"
  echo "========================================================================"
  exec gosu redis "$@" &

  ##### post scripts #####
  echo "========================================================================"
  echo "configure:"
  echo "========================================================================"
  
  #bring command to foreground
  fg
else
  exec "$@"
fi
