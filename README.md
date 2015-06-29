![http://linuxserver.io](http://www.linuxserver.io/wp-content/uploads/2015/06/linuxserver_medium.png)

The [LinuxServer.io](http://linuxserver.io) team brings you another quality container release featuring auto-update on startup, easy user mapping and community support. Be sure to checkout our [forums](http://forum.linuxserver.io) or for real-time support our [IRC](http://www.linuxserver.io/index.php/irc/) on freenode at `#linuxserver.io`.

# linuxserver/smokeping

Smokeping keeps track of your network latency. For a full example of what this application is capable of visit [UCDavis](http://smokeping.ucdavis.edu/cgi-bin/smokeping.fcgi).

## Usage

```
docker create \
	--name smokeping \
	-p 8080:80 \
	-e PUID=<UID> -e PGID=<GID> \
	-v <path/to/smokeping/data>:/data \
	-v <path/to/smokeping/config>:/config \
	linuxserver/smokeping
```

Once running the URL will be `http://<host-ip>:8080/cgi-bin/smokeping.cgi`.

**Parameters**

* `-p 8080` - the port for the webUI
* `-v /data` - Storage location for db and application data (graphs etc)
* `-v /config` - Configure the `Targets` file here
* `-e PGID` for for GroupID - see below for explanation
* `-e PUID` for for UserID - see below for explanation

This container is based on phusion-baseimage with ssh removed, for shell access whilst the container is running do `docker exec -it smokeping /bin/bash`.

### User / Group Identifiers

**TL;DR** - The `PGID` and `PUID` values set the user / group you'd like your container to 'run as' to the host OS. This can be a user you've created or even root (not recommended).

Part of what makes our containers work so well is by allowing you to specify your own `PUID` and `PGID`. This avoids nasty permissions errors with relation to data volumes (`-v` flags). When an application is installed on the host OS it is normally added to the common group called users, Docker apps due to the nature of the technology can't be added to this group. So we added this feature to let you easily choose when running your containers.

## Setting up the application 

Full guide coming soon...

Basics are, edit the Targets file to ping the hosts you're interested in to match the format found here. Restart the container, BOOM!


## Updates

* Upgrade to the latest version simply `docker restart smokeping`.
* To monitor the logs of the container in realtime `docker logs -f smokeping`.


**Credits**

* IronicBadger <ironicbadger@linuxserver.io>
* lonix <lonixx@gmail.com>