FROM certbot/certbot:v0.39.0

LABEL maintainer="Maksim Fominov <Maksim.Fominov@gmail.com>"

ENV LANG="en_US.UTF-8" \
  LANGUAGE="en_US.UTF-8" \
  LC_CTYPE="en_US.UTF-8" \
  LC_ALL="en_US.UTF-8" \
  EMAIL="example@example.com" \
  DNS_USERNAME="test" \
  DNS_PASSWORD="test" \
  REG_RU_DOMAINS="" \
  REG_RU_PROPAGATION_SECONDS="360"

COPY ./entrypoint.sh /entrypoint.sh

RUN apk add -U gettext \
  bash && \
  pip install certbot-regru && \
  chmod +x /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

# run example
# docker run -d -e DNS_USERNAME="username" -e DNS_PASSWORD="password" -e REG_RU_DOMAINS="domain or wildcard" -v /etc/letsencrypt:/etc/letsencrypt -v /var/log/letsencrypt:/var/log/letsencrypt/ certbot-regru