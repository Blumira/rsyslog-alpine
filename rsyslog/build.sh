#!/bin/sh

# Build a patched version of rsyslog for Alpine 3.10
set -e
apk add \
	autoconf \
	automake \
	byacc \
	curl-dev \
	flex \
	git \
	gnutls-dev \
	libtool \
	libestr-dev \
	libfastjson-dev \
	libgcrypt-dev \
	util-linux-dev \
	zlib-dev \
	build-base

rm -rf /var/tmp/rsyslog/rsyslog
cd /var/tmp/rsyslog
git clone https://github.com/rsyslog/rsyslog.git
cd rsyslog
git checkout v8.2006.0
# Apply Blumira patches
patch -p1 < ../mmescapelf.patch
patch -p1 < ../cert_request.patch
# Apply Alpine patches
patch -p1 < ../queue.patch

autoreconf -fi
./configure \
	--sysconfdir=/etc \
	\
	--disable-generate-man-pages \
	--disable-rfc3195 \
	--enable-largefile \
	--disable-gssapi-krb5 \
	--disable-mysql \
	--disable-pgsql \
	--disable-libdbi \
	--disable-snmp \
	--disable-elasticsearch \
	--disable-omhttp \
	--disable-clickhouse \
	--enable-gnutls \
	--disable-mail \
	--disable-imdiag \
	--disable-mmnormalize \
	--disable-mmjsonparse \
	--disable-mmaudit \
	--disable-mmanon \
	--disable-mmrm1stspace \
	--disable-mmutf8fix \
	--disable-mmcount \
	--disable-mmsequence \
	--disable-mmdblookup \
	--disable-mmfields \
	--disable-mmpstrucdata \
	--disable-relp \
	--disable-imfile \
	--enable-imptcp \
	--disable-impstats \
	--disable-omprog \
	--disable-omudpspoof \
	--enable-omstdout \
	--disable-pmlastmsg \
	--disable-pmaixforwardedfrom \
	--disable-pmsnare \
	--disable-omuxsock \
	--disable-mmsnmptrapd \
	--disable-omrabbitmq \
	--disable-imczmq \
	--disable-omczmq \
	--disable-omhiredis \
	--disable-imdocker \
	--enable-mmescapelf
make install
mv /var/tmp/rsyslog/run_rsyslog.sh /usr/local/bin
rm -rf /var/tmp/rsyslog
