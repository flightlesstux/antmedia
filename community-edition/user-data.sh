#!/bin/bash

curl -s "https://api.github.com/repos/ant-media/Ant-Media-Server/releases/latest" | grep "browser_download_url" | cut -d : -f 2,3 | tr -d \" | xargs wget -O /tmp/ant-media-server-latest.zip
curl -L https://raw.githubusercontent.com/ant-media/Scripts/master/install_ant-media-server.sh -o /tmp/install_ant-media-server.sh
cd /tmp/ && bash install_ant-media-server.sh -i ant-media-server-latest.zip
