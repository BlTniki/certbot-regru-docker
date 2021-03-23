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

envsubst </root/regru.tpl >${REG_RU_PATH_TO_CREDENTIALS} && chmod 600 ${REG_RU_PATH_TO_CREDENTIALS} && certbot certonly -a certbot-regru:dns ${DOMAINS[@]} --certbot-regru:dns-propagation-seconds ${REG_RU_PROPAGATION_SECONDS} --certbot-regru:dns-credentials ${REG_RU_PATH_TO_CREDENTIALS}
