FROM quay.io/baselibrary/ubuntu:14.04
MAINTAINER ShawnMa <qsma@thoughtworks.com>

## Add repository
RUN \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7917B12 &&\
  echo "deb http://ppa.launchpad.net/chris-lea/redis-server/ubuntu trusty main" > /etc/apt/sources.list.d/redis.list

## Install packages
RUN \
  apt-get update &&\
  apt-get install -y redis-server=3:3.0.3-2chl1~trusty1 redis-tools=3:3.0.3-2chl1~trusty1 &&\
  rm -rf /var/lib/apt/lists/*

## Install scripts
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod a+x            /docker-entrypoint.sh

EXPOSE 6379

WORKDIR /var/lib/redis

ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]

VOLUME ["/var/lib/redis"]

CMD ["redis-server"]


