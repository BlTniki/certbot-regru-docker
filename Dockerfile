FROM certbot/certbot:v0.39.0
ARG PROXY_URL
ARG GIT_REPO
ARG GIT_COMMIT
ARG GIT_DATE

LABEL maintainer="Maksim Fominov <Maksim.Fominov@gmail.com>"

ENV LANG="en_US.UTF-8" \
  LANGUAGE="en_US.UTF-8" \
  LC_CTYPE="en_US.UTF-8" \
  LC_ALL="en_US.UTF-8" \
  DNS_USERNAME="test" \
  DNS_PASSWORD="test" \
  REG_RU_DOMAINS="" \
  REG_RU_PROPAGATION_SECONDS="180" \
  REG_RU_PATH_TO_CREDENTIALS="/root/regru.ini"

ADD regru.ini /root/regru.tpl
ADD entrypoint.sh /root/entrypoint.sh

RUN apk add -U gettext \
  bash && \
  chmod 0600 /root/regru.tpl && \
  pip install certbot-regru && \
  chmod +x /root/entrypoint.sh

ENTRYPOINT /root/entrypoint.sh