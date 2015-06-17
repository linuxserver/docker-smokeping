#!/bin/bash

if [ -f /config/Targets ]; then
  exit 0
else
  cp /etc/smokeping/config.d/Targets /config/
  chown abc:abc /config/Targets
fi