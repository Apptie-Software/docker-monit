# Dockerized [Monit](https://mmonit.com/monit/) by Apptie Software

## Summary

Monit is a monitoring utility meant to be used together with M/Monit

- [M/Monit website](https://mmonit.com/)
- [Our Dockerized M/Monit](https://github.com/Apptie-Software/docker-mmonit?tab=readme-ov-file)

>[!IMPORTANT]
> Pay attention to environment variables.
> It's easy to confuse `MMONIT...` (for M/Monit) and `MONIT...` (for Monit)

## Usage

### docker

```sh
docker create \
  --name=monit \
  -e PUID=1000 \
  -e PGID=1000 \
  -e MONIT_PORT=2812 \
  -e TZ=Europe/Kyiv \
  -e MMONIT_URL="https://USERNAME:PASSWORD@mmonit.your.domain:8080/collector"
  --expose 2812 \
  -v </path/to/config>:/etc/monit/config \
  --restart unless-stopped \
  Apptie-Software/monit
```

### docker-compose

```yml
services:
  monit:
    image: Apptie-Software/monit
    container_name: monit
    environment:
      PUID: 1000
      PGID: 1000
      MONIT_PORT: 2812
      TZ: Europe/Kyiv
      MMONIT_URL: "https://USERNAME:PASSWORD@mmonit.your.domain:8080/collector"
    volumes:
      - </path/to/config>:/etc/monit/config
    expose:
      - 2812
    restart: unless-stopped
```

## Parameters

### Port

You can set a custom port with `MONIT_PORT`

>[!NOTE]
> Don't forget to put it in `--expose` or `expose:`

### Environment Variables (`-e` or `environment:`)

| Variable        | Function                                |
| ---        | --------                                |
| PUID=1000  | for UserID - see below for explanation  |
| PGID=1000  | for GroupID - see below for explanation |
| MONIT_PORT=2812  | 2812 is the default port, you can set your own. |
| TZ=UTC     | Specify a timezone to use EG UTC        |
| MMONIT_URL | URL used to communicate with M/Monit    |
| MMONIT_USERNAME | Username for logging into M/Monit    |
| MMONIT_PASSWORD | Password for logging into M/Monit    |

### Volume Mappings (-v)

| Volume  | Function                         |
| ------  | --------                         |
| /etc/monit/config | All the config files reside here |

## Setup

- If provided, Monit configuration is assembled from config files found in `<config>`.

- Otherwise, the configuration will be generated based on existing environment variables.

>[!IMPORTANT]
> `MMONIT_URL`, `MMONIT_USERNAME`, and `MMONIT_PASSWORD` are
> ***required*** to generate config files.

### `/etc/monit/config/httpd.cfg`

`NETWORK` and `NETMASK` are those of the container.

```cfg
set httpd port ${MONIT_PORT}
    allow localhost
    allow "::1"
    allow ${NETWORK}/${NETMASK}
    allow ${MMONIT_USERNAME}:${MMONIT_PASSWORD}
```

### `/etc/monit/config/mmonit.cfg`

```cfg
set monit ${MMONIT_URL}
```
