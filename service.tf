resource "consul_service" "google" {
  name    = "google"
  node    = "${consul_node.compute.name}"
  port    = 80
  tags    = ["tag0"]
}

resource "consul_node" "compute" {
  name    = "compute-google"
  address = "www.google.com"
}
