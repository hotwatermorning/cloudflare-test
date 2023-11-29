resource "cloudflare_d1_database" "my_app_db" {
  account_id = var.cloudflare_account_id
  name       = "my-app-db"
  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_d1_database" "my_app_db_preview" {
  account_id = var.cloudflare_account_id
  name       = "my-app-db_preview"
  lifecycle {
    prevent_destroy = true
  }
}

