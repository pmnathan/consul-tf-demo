resource "consul_config_entry" "config-entry-intentions" {
  kind = "service-intentions"
  name = "db"

  config_json = jsonencode({
    Sources = [
  {
    Name   = "web"
    Action = "deny"
  },
  {
    Name   = "api"
    Action = "deny"
  },
     {
    Name   = "api2"
    Action = "allow"
  }
]
  })
}



resource "consul_config_entry" "config-entry-intentions-namespace" {
  kind = "service-intentions"
  name = "*"
  namespace = "*"

  config_json = jsonencode({
    Sources = [
  {
    Name      = "prometheus"
    Namespace = "monitoring"
    Action = "deny"
  }
]
  })
}
