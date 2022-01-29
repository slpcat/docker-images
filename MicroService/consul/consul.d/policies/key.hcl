key_prefix "" {
  policy = "read"
}
key "foo" {
  policy = "write"
}
key "bar" {
  policy = "deny"
}
