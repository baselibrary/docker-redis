FROM baselibrary/baseimage:1.0.0
MAINTAINER ShawnMa <qsma@thoughtworks.com>

## Version
ENV REDIS_MAJOR   2.8
ENV REDIS_VERSION 2:2.8.4-2

## Repository
RUN \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7917B12 &&\
  echo "deb http://ppa.launchpad.net/chris-lea/redis-server/ubuntu trusty main" > /etc/apt/sources.list.d/redis.list

## Packages
RUN \
  apt-get update &&\
  apt-get install -y redis-server=2:2.8.4-2 redis-tools=2:2.8.4-2 &&\
  rm -rf /var/lib/apt/lists/*

## Scripts
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod a+x            /docker-entrypoint.sh

EXPOSE 6379

WORKDIR /var/lib/redis

ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]

VOLUME ["/var/lib/redis"]

CMD ["redis-server"]


