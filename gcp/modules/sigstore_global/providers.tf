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

provider "google" {
  project = var.project_id
}

provider "google" {
  alias        = "googleorg"
  access_token = var.personal_access_token
  project      = "colleenmurphy-testing-410318"
  region       = "us-central1"
}

variable "personal_access_token" {
  type        = string
  description = "Short-lived access token for the personal GCP organization"
  sensitive   = true
}
