# LF10-Projekt: Automatisierte & Sichere VM-Bereitstellung (Terraform & Proxmox)

![Terraform](https://img.shields.io/badge/Terraform-v1.0+-purple?style=flat-square&logo=terraform)
![Proxmox](https://img.shields.io/badge/Proxmox-VE-orange?style=flat-square)
![Security](https://img.shields.io/badge/Security-Hardened-green?style=flat-square)

## 📖 Über das Projekt

Dieses Projekt wurde im Rahmen des Lernfeldes 10 ("Entwickeln und Bereitstellen von Anwendungssystemen") entwickelt. Ziel ist die vollautomatisierte und sicherheitsgehärtete Bereitstellung von virtuellen Maschinen auf einer Proxmox-Umgebung mittels **Infrastructure as Code (IaC)**.

Anstatt VMs manuell zu installieren, nutzt dieses Projekt **Terraform** und **Cloud-Init**, um Server reproduzierbar, konsistent und sicher aufzusetzen.

### ✨ Features

*   **Infrastructure as Code:** Vollständige Definition der Infrastruktur in Code (`main.tf`).
*   **Automatisierte Konfiguration:** Nutzung von `cloud-init` zur Einrichtung des Betriebssystems beim ersten Start.
*   **Security by Design:**
    *   Deaktivierter Root-Login per Passwort.
    *   Ausschließliche Verwendung von SSH-Keys.
    *   Automatische Sicherheitsupdates (`unattended-upgrades`).
    *   Strikte Trennung von Code und Geheimnissen (Secrets).

---

## 🚀 Voraussetzungen

Bevor du startest, stelle sicher, dass folgende Anforderungen erfüllt sind:

*   **Terraform** installiert (v1.0 oder neuer).
*   Zugriff auf einen **Proxmox VE** Server.
*   Ein **Proxmox API Token** (mit entsprechenden Berechtigungen).
*   Ein lokales **SSH-Schlüsselpaar** (`id_ed25519` oder ähnlich).

---

## 🛠 Installation & Einrichtung

### 1. Repository klonen
```bash
git clone https://github.com/riv3ty/LF10-Projekt.git
cd LF10-Projekt
