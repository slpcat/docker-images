agent_prefix "" {
  policy = "read"
}
agent "foo" {
  policy = "write"
}
agent_prefix "bar" {
  policy = "deny"
}
