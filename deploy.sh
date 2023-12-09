#!/bin/bash

set -e -u -o pipefail

realpath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

SCRIPT_NAME="$(basename "$(realpath "${BASH_SOURCE:-$0}")")"
SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE:-$0}")")"

if [ $# -ne 1 ]; then
  echo "Deploy mode is required." 1>&2
  echo "Usage: ${SCRIPT_NAME} <local|preview|prd>" 1>&2
  exit 1
fi

if ! command -v terraform; then
  echo "terraform is not found." 1>&2
  exit 1
fi

if ! command -v jq; then
  echo "jq is not found." 1>&2
  exit 1
fi

if ! command -v yarn; then
  echo "yarn is not found." 1>&2
  exit 1
fi

DEPLOY_MODE=$1

cd "${SCRIPT_DIR}/terraform"

export TF_VAR_cloudflare_account_id=${CLOUDFLARE_ACCOUNT_ID}
export TF_VAR_cloudflare_api_token=${CLOUDFLARE_API_TOKEN}
terraform init
terraform apply -auto-approve

export CLOUDFLARE_PAGES_PROJECT_NAME=$(terraform output -json | jq -r ".app.value.name")
export CLOUDFLARE_ACCOUNT_ID=$(terraform output -json | jq -r ".account_id.value")
export CLOUDFLARE_DB_ID=$(terraform output -json | jq -r ".db.value.id")
export CLOUDFLARE_DB_NAME=$(terraform output -json | jq -r ".db.value.name")
export CLOUDFLARE_DB_PREVIEW_ID=$(terraform output -json | jq -r ".db_preview.value.id")
export CLOUDFLARE_DB_PREVIEW_NAME=$(terraform output -json | jq -r ".db_preview.value.name")

cd ..

envsubst < wrangler.toml.in > wrangler.toml

yarn
yarn build

if [ "${DEPLOY_MODE}" = "prd" ]; then
  echo "Deploy production"
  echo "y" | yarn wrangler d1 migrations apply ${CLOUDFLARE_DB_NAME}
  yarn wrangler pages deploy .svelte-kit/cloudflare --project-name my-pages-app --branch main
elif [ "${DEPLOY_MODE}" = "preview" ]; then
  echo "Deploy preview"
  echo "y" | yarn wrangler d1 migrations apply ${CLOUDFLARE_DB_PREVIEW_NAME}
  yarn wrangler pages deploy .svelte-kit/cloudflare --project-name my-pages-app --branch preview
else
  echo "Deploy local"
  echo "y" | yarn wrangler d1 migrations apply ${CLOUDFLARE_DB_NAME} --local
  yarn wrangler pages dev .svelte-kit/cloudflare
fi
