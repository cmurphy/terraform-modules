/**
 * Copyright 2022 The Sigstore Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  type    = string
  default = ""
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Must specify project_id variable."
  }
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "single_region" {
  description = "Whether this module instance is only deployed in one region, and therefore in charge of managing its own IP address and DNS record but not other load balancer resources."
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "The name to give the new Kubernetes cluster."
  type        = string
}

// Certificate authority
variable "ca_pool_name" {
  description = "Certificate authority pool name"
  type        = string
}

variable "ca_name" {
  description = "Certificate authority name"
  type        = string
  default     = "sigstore-authority"
}

variable "enable_ca" {
  description = "Enable a certificate authority via GCP CA Service"
  type        = bool
  default     = true
}

// KMS
variable "fulcio_keyring_name" {
  type        = string
  description = "Name of KMS keyring for Fulcio"
  default     = "fulcio-keyring"
}

variable "fulcio_key_name" {
  type        = string
  description = "Name of KMS key for Fulcio"
  default     = "fulcio-intermediate-key"
}

variable "kms_location" {
  type        = string
  description = "Location of KMS keyring"
  default     = "global"
}

variable "dns_zone_name" {
  description = "Name of DNS Zone object in Google Cloud DNS"
  type        = string
}

variable "dns_domain_name" {
  description = "Name of DNS domain name in Google Cloud DNS"
  type        = string
}

// Network
variable "enable_cloud_armor" {
  description = "Whether to create a Cloud Armor security policy."
  type        = bool
  default     = false
}

variable "cloud_armor_rules" {
  description = "Cloud Armor security policy rules."
  type = list(object({
    action      = string
    priority    = number
    description = optional(string)

    match = object({
      versioned_expr = optional(string)

      config = optional(object({
        src_ip_ranges = list(string)
      }))

      expr = optional(object({
        expression = string
      }))
    })

    rate_limit_options = optional(object({
      enforce_on_key = string
      conform_action = string
      exceed_action  = string
      qpm_rate_limit = number
      interval_sec   = number
    }))

    redirect_options = optional(object({
      type   = string
      target = string
    }))
  }))
  default = []
}

variable "enable_adaptive_protection" {
  description = "Whether to enable layer 7 DDoS adaptive protection in Cloud Armor."
  type        = bool
  default     = true
}

variable "enable_ssl_policy" {
  description = "Whether to create a SSL policy."
  type        = bool
  default     = false
}

variable "network" {
  description = "VPC network in which the GKE cluster lives"
  type        = string
  default     = "default"
}

variable "cluster_network_tag" {
  description = "GKE cluster network tag for firewall"
  type        = string
  default     = ""
}

variable "http_service_port" {
  description = "The internal HTTP port for the service pod"
  type        = string
  default     = "5555"
}

variable "grpc_service_port" {
  description = "The internal HTTP port for the service pod"
  type        = string
  default     = "5554"
}

variable "enable_healthcheck_logging" {
  description = "Whether to enable logging for the HTTP health check"
  type        = bool
  default     = true
}

variable "network_endpoint_group_zones" {
  type        = list(string)
  description = "zones where the NEGs live. NEGs will not exist until the Kubernetes service they belong to exists and creates them. This value must be set to empty if NEGs are not expected to exist yet, and then can later be updated."
  default     = []
}

variable "network_endpoint_group_name" {
  description = "Name of the NEG that will be created for the HTTP service by the Fulcio Kubernetes service."
  type        = string
  default     = ""
}

variable "network_endpoint_group_name_grpc" {
  description = "Name of the NEG that will be created for the gRPC service by the Fulcio Kubernetes service."
  type        = string
  default     = ""
}

variable "backend_service_max_rps" {
  description = "Max requests per second that a single backend instance can handle."
  type        = number
  default     = 100
}

variable "enable_backend_service_logging" {
  description = "Whether to enable logging for the HTTP backend service."
  type        = bool
  default     = true
}
