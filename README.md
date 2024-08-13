# Kubernetes ingress module
Terraform module which creates an ingress in a Kubernetes cluster. It is useful when you have a single ingress in a cluster or if you need to create an ingress using Terragrunt.

## Usage

### Creating an ingress
```hcl
module "my_ingress" {
  source  = "andre177/ingress/kubernetes"
  version = "0.0.1"

  name      = "my-ingress"
  namespace = "my-namespace"

  annotations = {
    "kubernetes.io/ingress.class" = "alb"
  }

  rules = [
    {
      host = "example.com"
      http = {
        paths = [
          {
            path      = "/api"
            path_type = "Prefix"
            backend = {
              service = {
                name = "api-service"
                port = {
                  number = 8080
                }
              }
            }
          },
          {
            path      = "/"
            path_type = "Prefix"
            backend = {
              service = {
                name = "web-service"
                port = {
                  number = 80
                }
              }
            }
          }
        ]
      }
    }
  ]

  tls = [
    {
      hosts       = ["example.com"]
      secret_name = "example-tls-secret"
    }
  ]
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_ingress_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_annotations"></a> [annotations](#input\_annotations) | An unstructured key value map stored with the ingress that may be used to store arbitrary metadata | `map(string)` | `{}` | no |
| <a name="input_default_backend"></a> [default\_backend](#input\_default\_backend) | A default backend capable of servicing requests that don't match any rule. At least one of 'backend' or 'rules' must be specified. This field is optional to allow the loadbalancer controller or defaulting logic to specify a global default. | <pre>object({<br>    service_name = string<br>    service_port = number<br>  })</pre> | `null` | no |
| <a name="input_ingress_class_name"></a> [ingress\_class\_name](#input\_ingress\_class\_name) | ingressClassName is the name of an IngressClass cluster resource. Ingress controller implementations use this field to know whether they should be serving this Ingress resource, by a transitive connection (controller -> IngressClass -> Ingress resource). Although the kubernetes.io/ingress.class annotation (simple constant name) was never formally defined, it was widely supported by Ingress controllers to create a direct binding between Ingress controller and Ingress resources. Newly created Ingress resources should prefer using the field. However, even though the annotation is officially deprecated, for backwards compatibility reasons, ingress controllers should still honor that annotation if present. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Map of string keys and values that can be used to organize and categorize (scope and select) the ingress. May match selectors of replication controllers and services. | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the ingress, must be unique. Cannot be updated. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace defines the space within which name of the ingress must be unique. | `string` | `"default"` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | Forwarding rules for backend services | <pre>list(object({<br>    host = optional(string)<br>    http = object({<br>      paths = list(object({<br>        path      = string<br>        path_type = string<br>        backend = object({<br>          service = object({<br>            name = string<br>            port = object({<br>              number = optional(number)<br>              name   = optional(string)<br>            })<br>          })<br>        })<br>      }))<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_tls"></a> [tls](#input\_tls) | tls represents the TLS configuration. Currently the Ingress only supports a single TLS port, 443. If multiple members of this list specify different hosts, they will be multiplexed on the same port according to the hostname specified through the SNI TLS extension, if the ingress controller fulfilling the ingress supports SNI. | <pre>list(object({<br>    hosts       = list(string)<br>    secret_name = string<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_load_balancer_hostname"></a> [load\_balancer\_hostname](#output\_load\_balancer\_hostname) | Load Balancer hostname |
| <a name="output_load_balancer_ip"></a> [load\_balancer\_ip](#output\_load\_balancer\_ip) | Load Balancer IP (if applicable) |
