#!/bin/bash
cp cryptotrip.service /usr/lib/systemd/system/cryptotrip.service
systemctl enable cryptotrip
cat crontab.backup | crontab -