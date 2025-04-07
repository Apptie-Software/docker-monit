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
| MONIT_PORT=2812  | 2812 is the default port, you can set your own. |
| MONIT_VERSION=5.9  | 5.9 is the latest version at the moment of writing, you can set your own. |
| TZ=UTC     | Specify a timezone to use EG UTC        |
| *MMONIT_PORT=8080 | port used by M/Monit    |
| *MMONIT_URL= | full URL used to communicate with M/Monit    |
| *MMONIT_DOMAIN=your.domain.com | domain used by M/Monit    |
| *MMONIT_MODE=http | transport mode (http, https) used to communicate with M/Monit    |
| MMONIT_USERNAME | Username for logging into M/Monit    |
| MMONIT_PASSWORD | Password for logging into M/Monit    |

`*` - in absence of a `MMONIT_URL` env, it is constructed from `MMONIT_PORT`, `MMONIT_DOMAIN`, `MMONIT_MODE`, `MMONIT_USERNAME` and `MMONIT_PASSWORD`

>[!NOTE]
> You can set either MMONIT_URL or the composite variables. The option exists for people that want more modularity in their setup.

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
set monit ${MMONIT_URL}/collector
```

## TODO

- search for the latest Monit version on the dist
