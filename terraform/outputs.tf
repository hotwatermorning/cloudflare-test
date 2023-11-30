output "account_id" {
  description = "account id"
  value = var.cloudflare_account_id
}

output "app" {
  description = "application info"
  value = {
    "id" = cloudflare_pages_project.my_pages_app.id
    "name" = cloudflare_pages_project.my_pages_app.name
  }
}

output "db" {
  description = "database id for production"
  value = cloudflare_d1_database.my_pages_app_db
}

output "db_preview" {
  description = "database id for preview"
  value = cloudflare_d1_database.my_pages_app_db_preview
}
