variable "name" {
  description = "Name of the ingress, must be unique. Cannot be updated."
  type        = string
}

variable "namespace" {
  description = "Namespace defines the space within which name of the ingress must be unique."
  type        = string
  default     = "default"
}

variable "annotations" {
  description = "An unstructured key value map stored with the ingress that may be used to store arbitrary metadata"
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "Map of string keys and values that can be used to organize and categorize (scope and select) the ingress. May match selectors of replication controllers and services."
  type        = map(string)
  default     = {}
}

variable "ingress_class_name" {
  description = "ingressClassName is the name of an IngressClass cluster resource. Ingress controller implementations use this field to know whether they should be serving this Ingress resource, by a transitive connection (controller -> IngressClass -> Ingress resource). Although the kubernetes.io/ingress.class annotation (simple constant name) was never formally defined, it was widely supported by Ingress controllers to create a direct binding between Ingress controller and Ingress resources. Newly created Ingress resources should prefer using the field. However, even though the annotation is officially deprecated, for backwards compatibility reasons, ingress controllers should still honor that annotation if present."
  type        = string
  default     = null
}

variable "default_backend" {
  description = "A default backend capable of servicing requests that don't match any rule. At least one of 'backend' or 'rules' must be specified. This field is optional to allow the loadbalancer controller or defaulting logic to specify a global default."
  type = object({
    service_name = string
    service_port = number
  })
  default = null
}

variable "tls" {
  description = "tls represents the TLS configuration. Currently the Ingress only supports a single TLS port, 443. If multiple members of this list specify different hosts, they will be multiplexed on the same port according to the hostname specified through the SNI TLS extension, if the ingress controller fulfilling the ingress supports SNI."
  type = list(object({
    hosts       = list(string)
    secret_name = string
  }))
  default = []
}

variable "rules" {
  description = "Forwarding rules for backend services"
  type = list(object({
    host = optional(string)
    http = object({
      paths = list(object({
        path      = string
        path_type = string
        backend = object({
          service = object({
            name = string
            port = object({
              number = optional(number)
              name   = optional(string)
            })
          })
        })
      }))
    })
  }))
  default = []
}