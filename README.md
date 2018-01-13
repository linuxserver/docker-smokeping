[linuxserverurl]: https://linuxserver.io
[forumurl]: https://forum.linuxserver.io
[ircurl]: https://www.linuxserver.io/irc/
[podcasturl]: https://www.linuxserver.io/podcast/
[appurl]: http://oss.oetiker.ch/smokeping/
[hub]: https://hub.docker.com/r/linuxserver/smokeping/

[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)][linuxserverurl]

The [LinuxServer.io][linuxserverurl] team brings you another container release featuring easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io][forumurl]
* [IRC][ircurl] on freenode at `#linuxserver.io`
* [Podcast][podcasturl] covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# linuxserver/smokeping
[![](https://images.microbadger.com/badges/version/linuxserver/smokeping.svg)](https://microbadger.com/images/linuxserver/smokeping "Get your own version badge on microbadger.com")[![](https://images.microbadger.com/badges/image/linuxserver/smokeping.svg)](https://microbadger.com/images/linuxserver/smokeping "Get your own image badge on microbadger.com")[![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/smokeping.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/linuxserver/smokeping.svg)][hub][![Build Status](https://ci.linuxserver.io/buildStatus/icon?job=Docker-Builders/x86-64/x86-64-smokeping)](https://ci.linuxserver.io/job/Docker-Builders/job/x86-64/job/x86-64-smokeping/)

Smokeping keeps track of your network latency. For a full example of what this application is capable of visit [UCDavis](http://smokeping.ucdavis.edu/cgi-bin/smokeping.fcgi).

[![smokeping](http://oss.oetiker.ch/smokeping/inc/smokeping-logo.png)][appurl]

## Usage

```
docker create \
	--name smokeping \
	-p 80:80 \
	-e PUID=<UID> -e PGID=<GID> \
	-e TZ=<timezone> \
	-v <path/to/smokeping/data>:/data \
	-v <path/to/smokeping/config>:/config \
	linuxserver/smokeping
```


You can choose between ,using tags, to switch to the unraid version (disabled ipv6).

Add one of the tags,  if required,  to the linuxserver/kodi-headless line of the run/create command in the following format, linuxserver/smokeping:unraid

#### Tags
+ **unraid** : for hosts with ipv6 not enabled in the kernel, eg unraid versions up to and prior to 6.3x.

Important - DO NOT USE :unraid branch with ipv6 enabled hosts as it will fail

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`



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

Once running the URL will be `http://<host-ip>:80/smokeping/smokeping.cgi`.

Basics are, edit the Targets file to ping the hosts you're interested in to match the format found there. 
Wait 10 minutes.

## Info

To monitor the logs of the container in realtime `docker logs -f smokeping`.

* container version number 

`docker inspect -f '{{ index .Config.Labels "build_version" }}' smokeping`

* image version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/smokeping`

## Versions

+ **13.12.17:** Expose httpd_conf to /config.
+ **13.12.17:** Rebase to alpine 3.7.
+ **24.07.17:** Add :unraid tag for hosts without ipv6.
+ **12.07.17:** Add inspect commands to README, move to jenkins build and push.
+ **28.05.17:** Rebase to alpine 3.6.
+ **07.05.17:** Expose smokeping.conf in /config/site-confs to allow user customisations
+ **12.04.17:** Fix cropper.js path, thanks nibbledeez.
+ **09.02.17:** Rebase to alpine 3.5.
+ **17.10.16:** Add ttf-dejavu package as per [LT forum](http://lime-technology.com/forum/index.php?topic=43602.msg507875#msg507875).
+ **10.09.16:** Add layer badges to README.
+ **05.09.16:** Add curl package.
+ **28.08.16:** Add badges to README.
+ **25.07.16:** Rebase to alpine linux.
+ **23.07.16:** Fix apt script confusion.
+ **29.06.15:** This is the first release, it is mostly stable, but may contain minor defects. (thus a beta tag)
