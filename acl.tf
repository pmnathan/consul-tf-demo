#Documentation for writing policies in TF
#https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/acl_policy

resource "consul_acl_policy" "test" {
  name        = "my_policy"
  datacenters = ["prakash"]
  rules       = <<-RULE
    node_prefix "" {
      policy = "read"
    }
    RULE
}


resource "consul_acl_policy" "test_namespace" {
  name        = "my_policy_namespace"
  datacenters = ["prakash"]
  namespace = "production"
  rules       = <<-RULE
    node_prefix "" {
      policy = "read"
    }
    RULE
}