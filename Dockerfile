FROM phusion/baseimage:0.9.16
MAINTAINER LinuxServer.io <ironicbadger@linuxserver.io
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV TERM screen


#Applying stuff
RUN apt-get update
RUN apt-get install -y apache2 smokeping
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Link config
RUN ln -s /etc/smokeping/apache2.conf /etc/apache2/conf-available/smokeping.conf

#Enable Apache modules
RUN a2enconf smokeping
RUN a2enmod cgid

#Adding Custom files
ADD config.d/ /etc/smokeping/config.d/
#ADD init/ /etc/my_init.d/
#ADD services/ /etc/service/
#RUN chmod -v +x /etc/service/*/run
#RUN chmod -v +x /etc/my_init.d/*.sh

#Adduser
RUN useradd -u 911 -U -s /bin/false abc
RUN usermod -G users abc

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Volumes and Ports
VOLUME /config
EXPOSE 80
