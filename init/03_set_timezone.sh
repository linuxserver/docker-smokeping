#!/bin/bash

# Set timezone if defined
if [ -e /usr/share/zoneinfo/$TZ ]; then
	rm /etc/localtime
	ln -s /usr/share/zoneinfo/$TZ /etc/localtime
fi
