resource "vault_kv_secret_v2" "creds" {
  mount                      = "dev-secrets"
  name                       = "creds"
  data_json                  = jsonencode(
  {
    password       = "my-long-password",
  }
  )
}

