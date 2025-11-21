
#directly pass port since no quotation issues
username= cat config.json | jq .username
password= cat config.json | jq .password
docker run \
  --name=firefox \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e seccomp=unconfined \
  -e CUSTOM_USER=$username \
  -e PASSWORD=$password \
  -p $(cat config.json | jq .port):$(cat config.json | jq .port) \
  -p $(cat config.json | jq .dev_port):$(cat config.json | jq .dev_port) \
  -v /docker/appdata/firefox/config:/config \
  --shm-size="1gb" \
  --restart unless-stopped \
  lscr.io/linuxserver/firefox:latest

docker rm $(docker ps -aqs)