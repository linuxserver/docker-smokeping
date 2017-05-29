FROM lsiobase/alpine:3.6
MAINTAINER LinuxServer.io <ironicbadger@linuxserver.io>, sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# install packages
RUN \
 apk add --no-cache \
	apache2 \
	apache2-utils \
	curl \
	smokeping \
	ssmtp \
	sudo \
	ttf-dejavu && \

# give abc sudo access to traceroute
 echo "abc ALL=(ALL) NOPASSWD: /usr/bin/traceroute" >> /etc/sudoers.d/traceroute && \

# fix path to cropper.js
 sed -i 's#src="/cropper/#/src="cropper/#' /etc/smokeping/basepage.html

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config /data
