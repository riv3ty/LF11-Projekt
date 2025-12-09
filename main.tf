terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.50"
    }
  }
}
provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
  insecure  = var.proxmox_tls_insecure
}

resource "local_file" "cloud_init_config" {
  filename = "${path.module}/user-data"
  content = templatefile("${path.module}/cloud-init.tpl", {
    ssh_public_key = var.ssh_public_key
  })
}

resource "proxmox_virtual_environment_container" "webserver" {
  count       = var.container_count
  node_name   = var.proxmox_host
  vm_id       = 200 + count.index
  description = "Webserver Container ${count.index + 1}"

  initialization {
    hostname = "webserver-0${count.index + 1}"

    ip_config {
      ipv4 {
        address = "${var.ip_network_prefix}.${85 + count.index}/${var.ip_cidr}"
        gateway = var.gateway_ip
      }
    }

    dns {
      server = "1.1.1.1"
      domain = "local"
    }

    user_account {
      keys     = [var.ssh_public_key]
      password = var.root_password
    }
  }

  operating_system {
    template_file_id = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
    type             = "ubuntu"
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 1024
  }

  disk {
    datastore_id = "nvme"
    size         = 8
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  started       = true
  start_on_boot = true
  unprivileged  = true

  provisioner "remote-exec" {
    inline = [
      "sleep 10",
      "apt-get update",
      "apt-get install -y neofetch htop git nginx",
      "systemctl enable --now nginx",
      "echo '<h1>Deployed with Terraform & SSH-Key Auth!</h1>' > /var/www/html/index.nginx-debian.html"
    ]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.private_key_path)
      host        = "${var.ip_network_prefix}.${85 + count.index}"
    }
  }
}

output "instance_ips" {
  description = "Die IP-Adressen der erstellten LXC-Container."
  value = {
    for instance in proxmox_virtual_environment_container.webserver :
    instance.initialization[0].hostname => "${var.ip_network_prefix}.${85 + index(proxmox_virtual_environment_container.webserver, instance)}"
  }
}
