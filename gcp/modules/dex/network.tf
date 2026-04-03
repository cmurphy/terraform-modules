/**
 * Copyright 2026 The Sigstore Authors
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

module "global" {
  count = var.single_region ? 1 : 0

  providers = { // DELETE BEFORE COMMIT
    google.googleorg = google.googleorg
  }

  source = "./global"

  project_id = var.project_id

  single_region = var.single_region

  dns_zone_name   = var.dns_zone_name
  dns_domain_name = var.dns_domain_name

  cluster_name = var.cluster_name

  enable_cloud_armor         = var.enable_cloud_armor
  cloud_armor_rules          = var.cloud_armor_rules
  enable_adaptive_protection = var.enable_adaptive_protection
  enable_ssl_policy          = var.enable_ssl_policy

  network_endpoint_group_zones = var.network_endpoint_group_zones
  network_endpoint_group_name  = var.network_endpoint_group_name
  backend_service_max_rps      = var.backend_service_max_rps

  enable_healthcheck_logging     = var.enable_healthcheck_logging
  enable_backend_service_logging = var.enable_backend_service_logging
}
moved {
  from = google_dns_record_set.A_dex
  to   = module.global[0].google_dns_record_set.A_dex
}
moved {
  from = google_compute_global_address.gce_lb_ipv4[0]
  to   = module.global[0].google_compute_global_address.gce_lb_ipv4
}
moved {
  from = google_compute_security_policy.http_security_policy
  to   = module.global[0].google_compute_security_policy.http_security_policy
}
moved {
  from = google_compute_ssl_policy.ssl_policy
  to   = module.global[0].google_compute_ssl_policy.ssl_policy
}

locals {
  cluster_network_tag = var.cluster_network_tag != "" ? var.cluster_network_tag : "gke-${var.cluster_name}"
}

resource "google_compute_firewall" "backend_service_healthcheck" {
  count = var.single_region ? 0 : 1

  name    = "dex-allow-gke-healthchecks-${var.region}"
  project = var.project_id

  network       = var.network
  direction     = "INGRESS"
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = [local.cluster_network_tag]
  allow {
    protocol = "tcp"
    ports    = [var.http_service_port]
  }
}
