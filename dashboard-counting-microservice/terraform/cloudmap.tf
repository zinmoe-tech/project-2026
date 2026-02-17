# ============================================================
# Cloud Map - Private DNS for service discovery
# Dashboard finds Counting via: counting.microservices.local
# ============================================================

resource "aws_service_discovery_private_dns_namespace" "main" {
  name = "microservices.local"
  vpc  = data.aws_vpc.default.id
}

resource "aws_service_discovery_service" "counting" {
  name = "counting"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "dashboard" {
  name = "dashboard"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
