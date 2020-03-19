path "pki/issue/rabbit" {
  capabilities = [ "create", "update" ]
}

path "secret/data/rabbit/*" {
  capabilities = [ "read" ]
}
