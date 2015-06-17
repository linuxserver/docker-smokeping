#!/bin/bash

if [ -f /config/Targets ]; then
  exit 0
else
  cp /tmp/Targets /config/
  chown abc:abc /config/Targets
fi