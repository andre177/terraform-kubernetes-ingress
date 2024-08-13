resource "kubernetes_ingress_v1" "this" {
  wait_for_load_balancer = var.ingress_class_name == "alb" ? true : false
  metadata {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    labels      = var.labels
  }

  spec {
    ingress_class_name = var.ingress_class_name

    dynamic "default_backend" {
      for_each = var.default_backend != null ? [var.default_backend] : []
      content {
        service {
          name = default_backend.value.service_name
          port {
            number = default_backend.value.service_port
          }
        }
      }
    }

    dynamic "tls" {
      for_each = var.tls
      content {
        hosts       = tls.value.hosts
        secret_name = tls.value.secret_name
      }
    }

    dynamic "rule" {
      for_each = var.rules
      content {
        host = rule.value.host
        http {
          dynamic "path" {
            for_each = rule.value.http.paths
            content {
              path      = path.value.path
              path_type = path.value.path_type
              backend {
                service {
                  name = path.value.backend.service.name
                  port {
                    number = path.value.backend.service.port.number
                    name   = path.value.backend.service.port.name
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}