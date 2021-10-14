resource "consul_namespace" "production" {
  name        = "production"
  description = "Production namespace"

  meta = {
    foo = "bar"
  }
}

resource "consul_namespace" "monitoring" {
  name        = "monitoring"
  description = "monitoring namespace"

  meta = {
    foo = "bar"
  }
}