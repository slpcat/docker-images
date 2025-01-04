# my-secret是之前创建的secrets
path "my-secret/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
