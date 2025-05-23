FROM alpine:3.21

# Environment
ENV \
  MONIT_PORT=2812 \
  TZ=UTC \
  MONIT_VERSION="5.34.4" \
  MMONIT_USERNAME="monit" \
  MMONIT_PASSWORD="monit" \
  MMONIT_DOMAIN="localhost" \
  MMONIT_MODE="http" \
  MMONIT_PORT=8080


# install Monit
RUN set -x\
  && apk add --no-cache --virtual mybuild \
  build-base \
  && apk add --no-cache \
  musl \
  openssl-dev \
  lm-sensors \
  libltdl \
  zlib-dev \
  ca-certificates \
  tzdata \
  findmnt \
  && cd /tmp \
  && wget "https://mmonit.com/monit/dist/monit-${MONIT_VERSION}.tar.gz" \
  && tar -zxvf "monit-${MONIT_VERSION}.tar.gz" \
  && cd "monit-${MONIT_VERSION}" \
  && ./configure \
  --prefix=/usr \
  --sysconfdir /etc/monit \
  --mandir=/usr/share/man \
  --localstatedir=/etc/monit/instance \
  --without-pam \
  && make -j $(nproc) \
  && make check \
  && make install \
  && cd \
  && rm -rf /tmp/* \
  && apk del mybuild

# Copy configuration and set ownership to root
COPY ./etc /etc/

# monitrc must have permissions not higher than 600
RUN set -x \
  && chown 0:0 /etc/monit/monitrc \
  && chmod 600 /etc/monit/monitrc \
  && mkdir -p /run/lock

EXPOSE ${MONIT_PORT}

VOLUME /etc/monit/config

HEALTHCHECK --start-period=300s --interval=30s --timeout=30s --retries=3 CMD ["monit", "status"] || exit 1

ENTRYPOINT ["/etc/monit/entrypoint.sh"]

CMD ["/usr/bin/monit", "-I", "-c", "/etc/monit/monitrc"]
