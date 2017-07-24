FROM lsiobase/alpine:3.6
MAINTAINER LinuxServer.io <ironicbadger@linuxserver.io>, sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# install build packages
RUN \
 apk add --no-cache --virtual=build-dependencies \
	g++ \
	gcc \
	make && \

# install packages
 apk add --no-cache \
	apache2 \
	apache2-utils \
	curl \
	smokeping \
	ssmtp \
	sudo \
	ttf-dejavu && \

# compile unraid compatible version and replace existing fping
 mkdir -p \
	/tmp/fping-src && \
 fping_ver=$(apk info fping | grep fping- | cut -d "-" -f2 | head -1) && \
 curl -o \
 /tmp/fping.tar.gz -L \
	"http://fping.org/dist/fping-${fping_ver}.tar.gz" && \
 tar xf \
 /tmp/fping.tar.gz -C \
	/tmp/fping-src --strip-components=1 && \
 cd /tmp/fping-src && \
 ./configure \
	--disable-ipv6 \
	--mandir=/usr/share/man \
	--prefix=/usr && \
 make && \
 make install && \
 chmod 4755 /usr/sbin/fping* && \

# give abc sudo access to traceroute
 echo "abc ALL=(ALL) NOPASSWD: /usr/bin/traceroute" >> /etc/sudoers.d/traceroute && \

# fix path to cropper.js
 sed -i 's#src="/cropper/#/src="cropper/#' /etc/smokeping/basepage.html && \

# cleanup
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config /data
