# CloudFlare + Svelte Test

CloudFlare Workers に SvelteKit のプロジェクトをデプロイするテスト。

DB に CloudFlare D1 を使用し、マイグレーションと ORM には [Drizzle ORM](https://orm.drizzle.team/) を使用している。

## Prerequisites

* yarn
* Terraform (1.6 or later)

## 使い方

CloudFlare のアカウントを作成する。

その後 https://dash.cloudflare.com/profile/api-tokens にアクセスし、 `Edit Cloudflare Workers` テンプレートに D1 Database の Edit パーミッションを追加してトークンを作成する。

トークンが生成できたら、以下の環境変数を設定する。（CloudFlare のアカウントID は、ダッシュボード画面の URL のパス部分から取得できる）

```sh
export CLOUDFLARE_ACCOUNT_ID="<CloudFlare のアカウント ID>"
export CLOUDFLARE_API_TOKEN="<生成した API トークン>"
```

以上が設定できたら、以下のスクリプトを実行する。これによって CloudFlare に D1 データベースが作成され、ローカルでサンプルアプリケーションが起動する。

```sh
./deploy.sh local
```

ローカルでサンプルアプリケーションをプロダクション用にデプロイする場合は以下のようにすること。

```sh
./deploy.sh prd
```
