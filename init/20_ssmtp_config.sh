#!/bin/bash
if [ ! -f /config/smtp.conf ]; then
cp /tmp/ssmtp.conf /config/smtp.conf
fi
chown abc:abc /config/smtp.conf
cp /config/smtp.conf /etc/ssmtp/ssmtp.conf
