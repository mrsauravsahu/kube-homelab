#!/bin/bash

set -e
set -x

# split CONSUMER_PAYOBILLS_CRON_LIST by comma and iterate over each item

for cron in $(echo "${CONSUMER_PAYOBILLS_CRON_LIST}" | tr ',' '\n'); do
  export CRON_SNAKE_CAPITAL="$(echo $cron | tr '-' '_' | tr '[:lower:]' '[:upper:]')"
  export CRON_KEBAB_LOWERED="$(echo $cron | tr '_' '-' | tr '[:upper:]' '[:lower:]')"

  # interpolate cron in yaml file to create intermediate env vars
  export CRON_NOTION_ID_ENVVAR_NAME="CONSUMER_PAYOBILLS_CRON_${CRON_SNAKE_CAPITAL}_NOTION_DB_ID"
  # Set the CONSUMER_PAYOBILLS_CRON_NOTION_ID environment variable to the value of the corresponding cron-based NOTION ID.
  export CONSUMER_PAYOBILLS_CRON_NOTION_DB_ID="${!CRON_NOTION_ID_ENVVAR_NAME}"

  # substitute environment variables using envsubst
  envsubst < consumer--payobills/template-transaction-syncer-cron.yaml | kubectl apply -n payobills -f -
done

set +e
set +x