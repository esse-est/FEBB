#!/bin/bash
#directly pass port since no quotation issues
username= cat config.json | jq .username
password= cat config.json | jq .password
security_mode= cat config.json | jq .seccomp
if [[ $(echo -n $(docker ps -qf name="firefox") | wc -m) != 0 ]]; then
  #reopen port in gh workspace
  docker stop firefox
  docker start firefox -i
else
  docker run \
  --name=firefox \
  -e PUID=1000 \
  -e NO_GAMEPAD=true \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e FIREFOX_CLI=https://www.linuxserver.io/ `#optional` \
  -e seccomp=${security_mode} \
  -e CUSTOM_USER=${username} \
  -e PASSWORD=${password} \
  -p 3000:3000 \
  -p 3001:3001 \
  -v firefox_config:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
  lscr.io/linuxserver/firefox:latest
fi
