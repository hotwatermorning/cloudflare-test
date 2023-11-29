#!/bin/bash

set -e -u -o pipefail

if [ $# -ne 1 ]; then
  echo "Deploy mode is required." 1>&2
  echo "Usage: $0 <local|prd>" 1>&2
  exit 1
fi

DEPLOY_MODE=$1

export TF_VAR_cloudflare_account_id=${CLOUDFLARE_ACCOUNT_ID}
export TF_VAR_cloudflare_api_token=${CLOUDFLARE_API_TOKEN}

cd ./terraform

terraform init
terraform apply

export CLOUDFLARE_ACCOUNT_ID=$(terraform output -json | jq -r ".account_id.value")
DB_ID=$(terraform output -json | jq -r ".db.value.id")
DB_NAME=$(terraform output -json | jq -r ".db.value.name")
DB_PREVIEW_ID=$(terraform output -json | jq -r ".db_preview.value.id")
DB_PREVIEW_NAME=$(terraform output -json | jq -r ".db_preview.value.name")

cd ..

if [ "${DEPLOY_MODE}" = "prd" ]; then
  echo "Deploy production"
  export CLOUDFLARE_DB_ID=${DB_ID}
  export CLOUDFLARE_DB_NAME=${DB_NAME}
  envsubst < wrangler.toml.in > wrangler.toml
  yarn wrangler d1 migrations apply ${CLOUDFLARE_DB_NAME}
  yarn wrangler publish
else
  echo "Deploy local"
  export CLOUDFLARE_DB_ID=${DB_PREVIEW_ID}
  export CLOUDFLARE_DB_NAME=${DB_PREVIEW_NAME}
  envsubst < wrangler.toml.in > wrangler.toml
  yarn wrangler d1 migrations apply ${CLOUDFLARE_DB_NAME} --local
  yarn wrangler dev
fi
