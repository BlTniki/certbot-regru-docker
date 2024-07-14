#!/bin/bash
set +ex

if [[ -z "$REG_RU_DOMAINS" ]]; then
  echo "Missing REG_RU_DOMAINS env variable!"
  exit 1
fi

DOMAINS=()
for domain in $REG_RU_DOMAINS; do
  DOMAINS+=("-d $domain ")
done

echo "certbot_regru:dns_username=${DNS_USERNAME}" > /etc/letsencrypt/regru.ini
echo "certbot_regru:dns_password=${DNS_PASSWORD}" >> /etc/letsencrypt/regru.ini
chmod 0600 /etc/letsencrypt/regru.ini

LAST_RENEW="/LAST_RENEW"

if [[ ! -f "$LAST_RENEW" ]]; then
  # Первый запуск
  if certbot certonly \
    -a certbot-regru:dns \
    ${DOMAINS[@]} \
    --certbot-regru:dns-propagation-seconds ${REG_RU_PROPAGATION_SECONDS} \
    --certbot-regru:dns-credentials /etc/letsencrypt/regru.ini \
    --non-interactive \
    --agree-tos \
    --email ${EMAIL}; then

    # Создание cron для перевыпуска сертификатов
    CRON_JOB="46 3 * * 0 /usr/bin/certbot renew --quiet"
    (crontab -l ; echo "$CRON_JOB") | crontab -
    echo "Cron job for certificate renewal has been added."

    # Создание файла для пометки первого запуска
    touch $LAST_RENEW
  else
    echo "Failed to obtain certificates. Exiting."
    exit 1
  fi
else
  # Повторный запуск - перевыпуск сертификатов
  certbot renew --quiet

  # Проверка наличия cron задачи
  if ! crontab -l | grep -q '/usr/bin/certbot renew'; then
    CRON_JOB="46 3 * * 0 /usr/bin/certbot renew --quiet"
    (crontab -l ; echo "$CRON_JOB") | crontab -
    echo "Cron job for certificate renewal has been added."
  else
    echo "Cron job for certificate renewal already exists."
  fi
fi

# Удержание контейнера в рабочем состоянии
tail -f /dev/null
