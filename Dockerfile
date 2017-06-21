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

# create folders
RUN mkdir -p \
	/config/site-confs \
	/run/apache2 \
	/var/cache/smokeping && \

# permissions
  chown -R abc:abc \
    /run/apache2 \
    /usr/share/webapps/smokeping \
    /var/cache/smokeping && \

# symlinks
  ln -s /usr/share/webapps/smokeping /var/www/localhost/smokeping && \
  ln -s /var/cache/smokeping /var/www/localhost/smokeping/cache

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config /data
