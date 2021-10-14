resource "consul_config_entry" "proxy_defaults" {
  kind = "proxy-defaults"
  # Note that only "global" is currently supported for proxy-defaults and that
  # Consul will override this attribute if you set it to anything else.
  name = "global"

  config_json = jsonencode({
    Config = {
      local_connect_timeout_ms = 1000
      handshake_timeout_ms     = 10000
    }
  })
}

resource "consul_config_entry" "web" {
  name = "web"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol    = "http"
  })
}

resource "consul_config_entry" "admin" {
  name = "admin"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol    = "http"
  })
}

resource "consul_config_entry" "service_resolver" {
  kind = "service-resolver"
  name = consul_config_entry.web.name

  config_json = jsonencode({
    DefaultSubset = "v1"

    Subsets = {
      "v1" = {
        Filter = "Service.Meta.version == v1"
      }
      "v2" = {
        Filter = "Service.Meta.version == v2"
      }
    }
  })
}

resource "consul_config_entry" "service_splitter" {
  kind = "service-splitter"
  name = consul_config_entry.service_resolver.name

  config_json = jsonencode({
    Splits = [
      {
        Weight        = 90
        ServiceSubset = "v1"
      },
      {
        Weight        = 10
        ServiceSubset = "v2"
      },
    ]
  })
}

resource "consul_config_entry" "service_router" {
  kind = "service-router"
  name = "web"

  config_json = jsonencode({
    Routes = [
      {
        Match = {
          HTTP = {
            PathPrefix = "/admin"
          }
        }

        Destination = {
          Service = "admin"
        }
      },
      # NOTE: a default catch-all will send unmatched traffic to "web"
    ]
  })
}

resource "consul_config_entry" "ingress_gateway" {
  name = "us-east-ingress"
  kind = "ingress-gateway"

  config_json = jsonencode({
    TLS = {
      Enabled = true
    }
    Listeners = [{
      Port     = 8000
      Protocol = "http"
      Services = [{ Name  = "*" }]
    }]
  })
}

resource "consul_config_entry" "terminating_gateway" {
  name = "us-west-gateway"
  kind = "terminating-gateway"

  config_json = jsonencode({
    Services = [{ Name = "billing" }]
  })
}