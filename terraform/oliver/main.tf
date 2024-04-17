#--------------------------------
# Enable userpass auth method
#--------------------------------

resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

# vault_generic_endpoint allows HTTP API calls through Vault
resource "vault_generic_endpoint" "danielle-user" {
  path                 = "auth/${vault_auth_backend.userpass.path}/users/danielle-vault-user"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "token_policies": ["developer-vault-policy"],
  "password": "pass"
}
EOT
}

resource "vault_policy" "developer-vault-policy" {
  name = "developer-vault-policy"

  policy = <<EOT
path "dev-secrets/+/creds" {
  capabilities = ["create", "update"]
}
path "dev-secrets/+/creds" {
  capabilities = ["read"]
}
## Vault TF provider requires ability to create a child token
path "auth/token/create" {  
  capabilities = ["create", "update", "sudo"]  
}
EOT
}

resource "vault_mount" "dev-secrets" {
  path        = "dev-secrets"
  type        = "kv"
  options     = { version = "2" }
}