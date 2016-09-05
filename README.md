[linuxserverurl]: https://linuxserver.io
[forumurl]: https://forum.linuxserver.io
[ircurl]: https://www.linuxserver.io/index.php/irc/
[podcasturl]: https://www.linuxserver.io/index.php/category/podcast/

[![linuxserver.io](https://www.linuxserver.io/wp-content/uploads/2015/06/linuxserver_medium.png)][linuxserverurl]

The [LinuxServer.io][linuxserverurl] team brings you another container release featuring easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io][forumurl]
* [IRC][ircurl] on freenode at `#linuxserver.io`
* [Podcast][podcasturl] covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# linuxserver/smokeping
[![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/smokeping.svg)][hub]
[![Docker Stars](https://img.shields.io/docker/stars/linuxserver/smokeping.svg)][hub]
[![Build Status](http://jenkins.linuxserver.io:8080/buildStatus/icon?job=Dockers/LinuxServer.io/linuxserver-smokeping)](http://jenkins.linuxserver.io:8080/job/Dockers/job/LinuxServer.io/job/linuxserver-smokeping/)
[hub]: https://hub.docker.com/r/linuxserver/smokeping/

Smokeping keeps track of your network latency. For a full example of what this application is capable of visit [UCDavis](http://smokeping.ucdavis.edu/cgi-bin/smokeping.fcgi).

[![smokeping](http://oss.oetiker.ch/smokeping/inc/smokeping-logo.png)][smokeurl]
[smokeurl]: http://oss.oetiker.ch/smokeping/

## Usage

```
docker create \
	--name smokeping \
	-p 8080:80 \
	-e PUID=<UID> -e PGID=<GID> \
	-e TZ=<timezone> \
	-v <path/to/smokeping/data>:/data \
	-v <path/to/smokeping/config>:/config \
	linuxserver/smokeping
```


**Parameters**

* `-p 80` - the port for the webUI
* `-v /data` - Storage location for db and application data (graphs etc)
* `-v /config` - Configure the `Targets` file here
* `-e PGID` for for GroupID - see below for explanation
* `-e PUID` for for UserID - see below for explanation
* `-e TZ` for timezone setting, eg Europe/London

This container is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it smokeping /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" <sup>TM</sup>.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id dockeruser
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application 

Once running the URL will be `http://<host-ip>:8080/smokeping/smokeping.cgi`.

Basics are, edit the Targets file to ping the hosts you're interested in to match the format found there. 
Wait 10 minutes.

## Info

* To monitor the logs of the container in realtime `docker logs -f smokeping`.


**Version**

+ **05.09.16:** Add curl package.
+ **28.08.16:** Add badges to README.
+ **25.07.16:** Rebase to alpine linux.
+ **23.07.16:** Fix apt script confusion.
+ **29.06.15:** This is the first release, it is mostly stable, but may contain minor defects. (thus a beta tag)
