variable "proxmox_api_url" {
  description = "Die URL der Proxmox API."
  type        = string
  default     = "https://192.168.178.23:8006/api2/json"
}

variable "proxmox_api_token_id" {
  description = "Die Proxmox API Token ID."
  type        = string
  sensitive   = true
}

variable "proxmox_api_token_secret" {
  description = "Das Proxmox API Token Secret."
  type        = string
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  description = "TLS-Zertifikatsprüfung deaktivieren (nur für Entwicklung/Test)."
  type        = bool
  default     = false
}

variable "proxmox_host" {
  description = "Der Proxmox-Node, auf dem die Container erstellt werden."
  default     = "pve"
}

variable "template_name" {
  description = "Vollständiger Pfad zum Cloud-Init-fähigen LXC-Template."
  default = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
}

variable "container_count" {
  description = "Anzahl der zu erstellenden Container."
  default     = 3
}

variable "root_password" {
  description = "Root Passwort der Maschine."
  type        = string
  sensitive   = true
}

variable "private_key_path" {
  description = "Pfad zum privaten SSH-Schlüssel."
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "Der öffentliche SSH-Schlüssel."
  type        = string
}

variable "ip_network_prefix" {
  description = "Das Netzwerk-Präfix für die statischen IPs (z.B., '192.168.1')."
  type        = string
}

variable "ip_cidr" {
  description = "Die CIDR-Maske für das Netzwerk (z.B., '24')."
  type        = string
}

variable "gateway_ip" {
  description = "Die IP-Adresse des Netzwerk-Gateways."
  type        = string
}

