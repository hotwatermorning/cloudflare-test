output "account_id" {
  description = "account id"
  value = var.cloudflare_account_id
}

output "db" {
  description = "database id for production"
  value = cloudflare_d1_database.my_app_db
}

output "db_preview" {
  description = "database id for preview"
  value = cloudflare_d1_database.my_app_db_preview
}
