#legacy style intentions
resource "consul_intention" "demo" {
  source_name      = "svc1"
  destination_name = "svc2"
  action           = "allow"
}


resource "consul_intention" "demo-namespace" {
  source_name      = "svc3"
  source_namespace = consul_namespace.production.name
  destination_name = "svc2"
  action           = "allow"
}
