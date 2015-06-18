#!/bin/bash

if [ ! -f /config/Targets ]; then
  cp /tmp/Targets /config/Targets
  chown abc:abc /config/Targets
fi