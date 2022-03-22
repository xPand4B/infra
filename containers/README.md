---
tags: VPS, Docker
---

# Docker Services
## Resources
* [How to install docker compose](https://docs.docker.com/compose/install/)
* [Explore DockerHub](https://hub.docker.com/search?type=image)
* [Linuxserver.io image collection](https://docs.linuxserver.io/)
* [Awesome-Selfhosted](https://github.com/awesome-selfhosted/awesome-selfhosted)
* [Other Resources](#Other-resources)

## How to update container?
https://docs.linuxserver.io/general/updating-our-containers#docker-compose
```bash
docker-compose pull
docker-compose up -d
```

# Services
## [Code Server](https://docs.linuxserver.io/images/docker-code-server)
```yaml
version: "3.8"

services:
  code-server:
    image: lscr.io/linuxserver/code-server
    container_name: code-server
    restart: unless-stopped
    ports:
      - 8443:8443
    environment:
      PUID: 1000
      PGID: 1000
      TZ: "Europe/Berlin"
      PASSWORD: "password" #optional
      HASHED_PASSWORD: #optional
      SUDO_PASSWORD: "password" #optional
      SUDO_PASSWORD_HASH: #optional
      PROXY_DOMAIN: "code-server.my.domain" #optional
      DEFAULT_WORKSPACE: "/config/workspace" #optional
    volumes:
      - ./config:/config
```

## [HedgeDocs](https://docs.hedgedoc.org/)
```yaml
version: "3.8"

services:
  mariadb:
    image: lscr.io/linuxserver/mariadb:latest
    container_name: hedgedoc_mariadb
    restart: always
    environment:
      PGID: 1000
      PUID: 1000
      TZ: "Europe/Berlin"
      MYSQL_ROOT_PASSWORD: "secret"
      MYSQL_DATABASE: "hedgedoc"
      MYSQL_USER: "hedgedoc"
      MYSQL_PASSWORD: "secret"
    volumes:
      - ./mariadb/data:/config

  hedgedoc:
    image: lscr.io/linuxserver/hedgedoc:latest
    container_name: hedgedoc
    restart: always
    ports:
      - 3000:3000
    depends_on:
      - mariadb
    environment:
      PGID: 1000
      PUID: 1000
      TZ: "Europe/Berlin"
      DB_HOST: "mariadb"
      DB_USER: "hedgedoc"
      DB_PASS: "secret"
      DB_NAME: "hedgedoc"
      DB_PORT: 3306
      CMD_DOMAIN: "md.xpand4b.de"
      CMD_PORT: 3000
      CMD_URL_ADDPORT: "false"
      CMD_PROTOCOL_USESSL: "true"
      CMD_HSTS_ENABLE: "true"
    volumes:
      - ./config:/config
```

## [Heimdall](https://docs.linuxserver.io/images/docker-heimdall)
```yaml
version: "3.8"

services:
  heimdall:
    image: lscr.io/linuxserver/heimdall
    container_name: heimdall
    restart: unless-stopped
    ports:
      - 8181:80
    environment:
      PUID: 1000
      PGID: 1000
      TZ: "Europe/Berlin"
    volumes:
      - ./config:/config
```

## [Homer](https://github.com/bastienwirtz/homer#getting-started)
```yaml
version: "3.8"

services:
  homer:
    image: b4bz/homer:latest
    container_name: homer
    restart: unless-stopped
    ports:
      - 8080:8080
    environment:
      UID: 1000
      GID: 1000
    volumes:
      - ./assets:/www/assets
```

## [Minecraft](https://github.com/itzg/docker-minecraft-server/blob/master/README.md)
### [Fabric](https://github.com/itzg/docker-minecraft-server/blob/master/README.md#running-a-fabric-server)
```yaml
version: "3.8"

services:
  mc:
    image: itzg/minecraft-server:java17
    container_name: mc-1181-fabric
    restart: unless-stopped
    ports:
      - 1337:25565
      - 8123:8123       # Dynmap
      - 24454:24454/udp # Voicechat
    environment:
      EULA: "true"
      TYPE: "FABRIC"
      VERSION: "1.18.1"
      MAX_MEMORY: 8G
      OPS: "xPand_4B,Rainerle98"
      MOTD: "\u00A72WaldiCraft SMP \u00A7r|\u00A74 Survival 1.18.1 \u00A7r|\u00A74 Fabric"
      DIFFICULTY: "normal"
      MODE: "survival"
      PVP: "true"
      ENABLE_COMMAND_BLOCK: "true"
      MAX_PLAYERS: 10
      ALLOW_NETHER: "true"
      ALLOW_FLIGHT: "true"
      ANNOUNCE_PLAYER_ACHIEVEMENTS: "true"
      FORCE_GAMEMODE: "true"
      GENERATE_STRUCTURES: "true"
      HARDCORE: "false"
      SNOOPER_ENABLED: "false"
      SPAWN_ANIMALS: "true"
      SPAWN_MONSTERS: "true"
      SPAWN_NPCS: "true"
      SPAWN_PROTECTION: 0
      VIEW_DISTANCE: 14
    volumes:
      - /opt/Minecraft/1181-fabric/data:/data
      - /opt/Minecraft/1181-fabric/mods:/mods:ro

volumes:
  data: {}
```

### Snapshot
```yaml
version: "3.8"

services:
  mc:
    image: itzg/minecraft-server
    container_name: mc-snapshot
    restart: unless-stopped
    ports:
      - 1338:25565
    environment:
      EULA: "true"
      VERSION: "SNAPSHOT"
      MAX_MEMORY: 4G
      OPS: "xPand_4B,Rainerle98"
      MOTD: "\u00A72WaldiCraft \u00A7r|\u00A74 Snapshot"
      DIFFICULTY: "normal"
      MODE: "creative"
      PVP: "true"
      ENABLE_COMMAND_BLOCK: "false"
      MAX_PLAYERS: 5
      ALLOW_NETHER: "true"
      ALLOW_FLIGHT: "true"
      ANNOUNCE_PLAYER_ACHIEVEMENTS: "true"
      FORCE_GAMEMODE: "true"
      GENERATE_STRUCTURES: "true"
      HARDCORE: "false"
      SNOOPER_ENABLED: "false"
      SPAWN_ANIMALS: "true"
      SPAWN_MONSTERS: "true"
      SPAWN_NPCS: "true"
      SPAWN_PROTECTION: 0
      VIEW_DISTANCE: 15
    volumes:
      - data:/data

volumes:
  data: {}
```

### RCON console
See [Interacting with the server](https://github.com/itzg/docker-minecraft-server/blob/master/README.md#interacting-with-the-server) for reference.
```bash
docker exec -i 1181-fabric_mc_1 rcon-cli
```

## [NextCloud](https://hub.docker.com/_/nextcloud)
```yaml
version: "3.8"

services:
  app:
    image: nextcloud:latest
    container_name: nextcloud-app
    restart: unless-stopped
    ports:
      - 8080:80
    depends_on:
      - db
    environment:
      VIRTUAL_HOST: "your.domain.com"
      LETSENCRYPT_HOST: "your.domain.com"
      LETSENCRYPT_EMAIL: "example@test.com"
      NEXTCLOUD_ADMIN_USER: "Admin"
      NEXTCLOUD_ADMIN_PASSWORD: "<secret>"
    volumes:
      - nextcloud:/var/www/html
      - ./app/config:/var/www/html/config
      - ./app/custom_apps:/var/www/html/custom_apps
      - ./app/data:/var/www/html/data
      - ./app/themes:/var/www/html/themes
      - /etc/localtime:/etc/localtime:ro

  db:
    image: mariadb
    container_name: nextcloud-mariadb
    restart: unless-stopped
    command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW --innodb-file-per-table=1 --skip-innodb-read-only-compressed
    environment:
      MYSQL_ROOT_PASSWORD: "<secret>"
      MYSQL_PASSWORD: "<secret>"
      MYSQL_DATABASE: "nextcloud"
      MYSQL_USER: "nextcloud"
    volumes:
      - db:/var/lib/mysql
      - /etc/localtime:/etc/localtime:ro

volumes:
  nextcloud:
  db:
```

## [Nginx Proxy Manager](https://nginxproxymanager.com/)
```yaml
version: "3.8"

services:
  app:
    image: jc21/nginx-proxy-manager:latest
    container_name: nginx-proxy-manager
    restart: always
    ports:
      - 80:80
      - 81:81
      - 443:443
    environment:
      DB_MYSQL_HOST: "db"
      DB_MYSQL_PORT: 3306
      DB_MYSQL_USER: "npm"
      DB_MYSQL_PASSWORD: "<secret>"
      DB_MYSQL_NAME: "npm"
      FORCE_COLOR: 1
    volumes:
      - ./config.json:/app/config/production.json
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
    depends_on:
      - db

  db:
    image: jc21/mariadb-aria:latest
    container_name: nginx-proxy-manager-db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: "<secret>"
      MYSQL_DATABASE: "npm"
      MYSQL_USER: "npm"
      MYSQL_PASSWORD: "<secret>"
    volumes:
      - ./data/mysql:/var/lib/mysql
```

## [Portainer](https://nextgentips.com/2022/01/26/how-to-install-portainer-ce-with-docker-compose/)
```yaml
version: "3.8"

services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: always
    ports:
      - 8383:9000
    security_opt:
      - no-new-privileges:true
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./portainer-data:/data
```

### [I enabled "Force HTTPS only" and now I'm locked out of Portainer. How do I get back in?](https://docs.portainer.io/v/ce-2.11/faq/troubleshooting/i-enabled-force-https-only-and-now-im-locked-out-of-portainer.-how-do-i-get-back-in)
```bash
# Down and remove current portainer container
docker-compose down
docker container ls -a
docker rm <ID>

# Run command to re-enable HTTP
docker run -d -p 8383:9000 --name portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /home/xpand/Sites/Portainer/portainer-data:/data \
    portainer/portainer-ce:latest \
    --http-enabled
    
# Stop and remove container again
docker stop portainer
docker container ls -a
docker rm <ID>

# Start-up docker compose container
docker-compose up -d
```

## [TeamSpeak 3](https://hub.docker.com/_/teamspeak)
```yaml
version: "3.8"

services:
  teamspeak:
    image: teamspeak
    container_name: teamspeak
    restart: always
    ports:
      - 9987:9987/udp
      - 10011:10011
      - 30033:30033
    environment:
      TS3SERVER_DB_PLUGIN: "ts3db_mariadb"
      TS3SERVER_DB_SQLCREATEPATH: "create_mariadb"
      TS3SERVER_DB_HOST: "db"
      TS3SERVER_DB_USER: "root"
      TS3SERVER_DB_PASSWORD: "secret"
      TS3SERVER_DB_NAME: "teamspeak"
      TS3SERVER_DB_WAITUNTILREADY: 30
      TS3SERVER_LICENSE: "accept"

  db:
    image: mariadb
    container_name: teamspeak_db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: "secret"
      MYSQL_DATABASE: "teamspeak"
```
</details>

## [Uptime Kuma](https://github.com/louislam/uptime-kuma)
```yaml
version: "3.8"

services:
  app:
    image: louislam/uptime-kuma:1
    container_name: uptime-kuma
    restart: always
    ports:
      - 8282:3001
    volumes:
      - uptime-kuma:/app/data

volumes:
  uptime-kuma:
    driver: local
```

# Other resources
{%youtube f5jNJDaztqk %}

<details>
  <summary>Click for all links!</summary>
  
* [Homer](https://github.com/bastienwirtz/homer)
* [My custom CSS for Homer](https://github.com/notthebee/infra/blob/main/roles/homer/files/custom.css)
* [Nord colors for Homer](https://pastebin.com/AH9NWmSL)
* [Jellyfin](https://github.com/linuxserver/docker-jellyfin)
* [arch-delugevpn](https://github.com/binhex/arch-delugevpn)
* [Radarr](https://hub.docker.com/r/linuxserver/radarr)
* [Sonarr](https://hub.docker.com/r/linuxserver/sonarr)
* [OpenBooks](https://github.com/evan-buss/openbooks)
* [Nextcloud](https://hub.docker.com/_/nextcloud)
* [PhotoPrism](https://hub.docker.com/r/photoprism/photoprism)
* [Vaultwarden](https://github.com/dani-garcia/vaultwarden)
* [UniFi Controller](https://hub.docker.com/r/linuxserver/unifi-controller)
* [Jackett](https://hub.docker.com/r/linuxserver/jackett)
* [PiKVM](https://github.com/pikvm/pikvm)
* [PiHole + Unbound](https://github.com/chriscrowe/docker-pihole-unbound)
* [Deconz](https://github.com/deconz-community/deconz-docker)
* [Home Assistant](https://hub.docker.com/r/linuxserver/homeassistant)
</details>