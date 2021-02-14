FROM ghcr.io/linuxserver/baseimage-alpine:3.13

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SMOKEPING_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="ironicbadger,sparklyballs"

# copy tcpping script
COPY tcpping /defaults/

RUN \
 echo "**** install packages ****" && \
 if [ -z ${SMOKEPING_VERSION+x} ]; then \
	SMOKEPING_VERSION=$(curl -sL "http://dl-cdn.alpinelinux.org/alpine/v3.13/main/x86_64/APKINDEX.tar.gz" | tar -xz -C /tmp \
	&& awk '/^P:smokeping$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://'); \
 fi && \
 apk add --no-cache \
	apache2 \
	apache2-ctl \
	apache2-utils \
	apache-mod-fcgid \
	bc \
	bind-tools \
	curl \
	font-noto-cjk \
	openssh-client \
	smokeping==${SMOKEPING_VERSION} \
	ssmtp \
	sudo \
	tcptraceroute \
	ttf-dejavu && \
 echo "**** give setuid access to traceroute & tcptraceroute ****" && \
 chmod a+s /usr/bin/traceroute && \
 chmod a+s /usr/bin/tcptraceroute && \
 echo "**** fix path to cropper.js ****" && \
 sed -i 's#src="/cropper/#/src="cropper/#' /etc/smokeping/basepage.html && \
 echo "**** install tcping script ****" && \
 install -m755 -D /defaults/tcpping /usr/bin/ && \
 echo "**** remove default apache conf ****" && \
 rm -f /etc/apache2/httpd.conf

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config /data
