#!/bin/bash

#enable job control in script
set -e -m

#run in background
if [ "$1" = 'redis-server' ]; then
  #####   variables  #####  
  
  ##### pre scripts  #####
  echo "========================================================================"
  echo "prepare the environment:"
  echo "========================================================================"
  
  # set listen addresses
  /usr/bin/ansible local -o -c local -m lineinfile  -a "dest=/etc/redis/redis.conf regexp='^(bind\s*)\S+' line='bind 0.0.0.0'"
  /usr/bin/ansible local -o -c local -m lineinfile  -a "dest=/etc/redis/redis.conf regexp='^(daemonize\s*)\S+' line='daemonize no'"
  /usr/bin/ansible local -o -c local -m lineinfile  -a "dest=/etc/redis/redis.conf regexp='^(logfile\s*)\S+' line='logfile /dev/stdout'"

  ##### run scripts  #####
  exec gosu redis "$@" &

  ##### post scripts #####
  echo "========================================================================"
  echo "configure the environment:"
  echo "========================================================================"
  
  #bring to foreground
  fg
else
  exec "$@"
fi

