FROM lsiobase/alpine
MAINTAINER LinuxServer.io <ironicbadger@linuxserver.io>, sparklyballs

# install packages
RUN \
 apk add --no-cache \
	apache2 \
	apache2-utils \
	curl \
	smokeping \
	ssmtp \
	sudo \
	ttf-dejavu

# give abc sudo access to traceroute
RUN \
 echo "abc ALL=(ALL) NOPASSWD: /usr/bin/traceroute" >> /etc/sudoers.d/traceroute

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config /data
