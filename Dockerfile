FROM phusion/baseimage:0.9.16
MAINTAINER LinuxServer.io <ironicbadger@linuxserver.io>
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV TERM screen
# apache environment settings
ENV APACHE_RUN_USER=www-data APACHE_RUN_GROUP=www-data APACHE_LOG_DIR="/var/log/apache2" APACHE_LOCK_DIR="/var/lock/apache2" APACHE_PID_FILE="/var/run/apache2.pid"

#Applying stuff
RUN apt-get update && \
apt-get install -y apache2 smokeping ssmtp && \
rm /etc/ssmtp/ssmtp.conf && \
ln -s /etc/smokeping/apache2.conf /etc/apache2/conf-available/apache2.conf && \
a2enconf apache2 && \
a2enmod cgid && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


#Adding Custom files
ADD config.d/ /etc/smokeping/config.d/
ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
ADD Targets /tmp/Targets
ADD ssmtp.conf /tmp/ssmtp.conf
ADD config /etc/smokeping/config
RUN chmod -v +x /etc/service/*/run
RUN chmod -v +x /etc/my_init.d/*.sh
RUN mkdir /var/run/smokeping

#Adduser
RUN useradd -u 911 -U -s /bin/false abc
RUN usermod -G users abc

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Volumes and Ports
VOLUME /config
VOLUME /data
EXPOSE 80
