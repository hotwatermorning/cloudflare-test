resource "cloudflare_d1_database" "my_pages_app_db" {
  account_id = var.cloudflare_account_id
  name       = "my-pages-app-db"
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_d1_database" "my_pages_app_db_preview" {
  account_id = var.cloudflare_account_id
  name       = "my-pages-app-db_preview"
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_pages_project" "my_pages_app" {
  account_id = var.cloudflare_account_id
  name = "my-pages-app"
  production_branch = "main"

  deployment_configs {
    preview {
      d1_databases = {
        DB = cloudflare_d1_database.my_pages_app_db_preview.id
      }
    }
    production {
      d1_databases = {
        DB = cloudflare_d1_database.my_pages_app_db.id
      }
    }
  }
}
