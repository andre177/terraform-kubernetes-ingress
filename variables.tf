variable "name" {
  description = "Name of the Ingress resource"
  type        = string
}

variable "namespace" {
  description = "Namespace for the Ingress resource"
  type        = string
  default     = "default"
}

variable "annotations" {
  description = "Annotations to add to the Ingress resource"
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "Labels to add to the Ingress resource"
  type        = map(string)
  default     = {}
}

variable "ingress_class_name" {
  description = "Name of the IngressClass to use"
  type        = string
  default     = null
}

variable "default_backend" {
  description = "Default backend for the Ingress"
  type = object({
    service_name = string
    service_port = number
  })
  default = null
}

variable "tls" {
  description = "TLS configuration for the Ingress"
  type = list(object({
    hosts       = list(string)
    secret_name = string
  }))
  default = []
}

variable "rules" {
  description = "List of rules for the Ingress"
  type = list(object({
    host = string
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