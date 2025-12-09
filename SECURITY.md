# LF10-Projekt - Sichere Terraform Proxmox Konfiguration

## 🔒 Sicherheitshinweise

Dieses Projekt wurde mit Best Practices für Sicherheit konfiguriert. Bitte beachten Sie folgende wichtige Punkte:

### Sensible Daten

**WICHTIG:** Sensible Daten wie Passwörter, API-Tokens und private SSH-Schlüssel sind NICHT im Repository enthalten!

Die folgenden Dateien sind in `.gitignore` und dürfen **NIEMALS** ins Git-Repository committed werden:
- `*.tfvars` (außer Beispieldateien)
- `*.tfstate*` (Terraform State Dateien)
- `*.pem`, `*.ppk`, `*.key` (Private Keys)
- `privkey*`, `pubkey*`

### Ersteinrichtung

1. **Kopieren Sie die Beispiel-Konfiguration:**
   ```bash
   cp secrets.tfvars.example secrets.tfvars
   ```

2. **Bearbeiten Sie `secrets.tfvars` mit Ihren echten Werten:**
   ```bash
   nano secrets.tfvars
   ```

3. **Erforderliche Werte in `secrets.tfvars`:**
   - `proxmox_api_token_id`: Ihre Proxmox API Token ID
   - `proxmox_api_token_secret`: Ihr Proxmox API Token Secret
   - `root_password`: Ein **starkes** Root-Passwort (min. 16 Zeichen, Groß-/Kleinbuchstaben, Zahlen, Sonderzeichen)
   - `ssh_public_key`: Ihr öffentlicher SSH-Schlüssel
   - `private_key_path`: Pfad zu Ihrem privaten SSH-Schlüssel

4. **Generieren Sie SSH-Keys (falls noch nicht vorhanden):**
   ```bash
   ssh-keygen -t ed25519 -C "terraform@proxmox"
   ```

### Terraform Ausführung

```bash
terraform init
terraform plan -var-file="secrets.tfvars"
terraform apply -var-file="secrets.tfvars"
```

## 🛡️ Implementierte Sicherheitsmaßnahmen

### 1. Secrets Management
- ✅ Alle sensiblen Daten in separater `secrets.tfvars` (nicht im Git)
- ✅ Variablen als `sensitive` markiert
- ✅ Keine hardcodierten Credentials im Code

### 2. SSH Sicherheit
- ✅ SSH-Key basierte Authentifizierung
- ✅ Passwort-Authentifizierung deaktiviert (`ssh_pwauth: false`)
- ✅ Root-Login nur mit SSH-Key (`PermitRootLogin prohibit-password`)
- ✅ Private Keys werden über `file()` geladen, nicht hardcodiert

### 3. System Sicherheit
- ✅ Automatische Sicherheitsupdates aktiviert (`unattended-upgrades`)
- ✅ Passwort-Login gesperrt (`lock_passwd: true`)
- ✅ Sudo ohne Passwort für Automation (`NOPASSWD:ALL`)

### 4. TLS/SSL
- ⚠️ `pm_tls_insecure = false` (Standard)
- 💡 Für Produktion: Verwenden Sie gültige SSL-Zertifikate für Proxmox

## ⚠️ Wichtige Warnungen

### Passwort-Sicherheit
- ❌ **NIEMALS** schwache Passwörter wie "Kennwort1!" verwenden
- ✅ Verwenden Sie einen Passwort-Manager
- ✅ Mindestens 16 Zeichen mit Groß-/Kleinbuchstaben, Zahlen und Sonderzeichen

### API Token Sicherheit
- 🔐 Proxmox API Tokens haben volle Zugriffsrechte
- 🔐 Schützen Sie `secrets.tfvars` mit Dateiberechtigungen:
  ```bash
  chmod 600 secrets.tfvars
  ```

### Git Repository
- ❌ **NIEMALS** `secrets.tfvars` committen
- ❌ **NIEMALS** `.tfstate` Dateien committen
- ❌ **NIEMALS** private SSH-Keys committen

Überprüfen Sie vor jedem Commit:
```bash
git status
git diff
```

## 🔍 Sicherheitsüberprüfung

Führen Sie regelmäßig folgende Checks durch:

```bash
grep -r "password\|secret\|token" *.tf
git log --all --full-history -- secrets.tfvars
```

## 📝 Weitere Empfehlungen

1. **Terraform State Backend:** Verwenden Sie ein Remote Backend (S3, Terraform Cloud) mit Verschlüsselung
2. **Netzwerk-Segmentierung:** Isolieren Sie Container in separaten VLANs
3. **Firewall:** Konfigurieren Sie Proxmox Firewall-Regeln
4. **Monitoring:** Implementieren Sie Log-Monitoring und Alerting
5. **Backups:** Regelmäßige Backups der Container und Konfiguration

## 📚 Ressourcen

- [Terraform Security Best Practices](https://developer.hashicorp.com/terraform/tutorials/configuration-language/sensitive-variables)
- [Proxmox Security](https://pve.proxmox.com/wiki/Security)
- [SSH Hardening](https://www.ssh.com/academy/ssh/security)

## 🆘 Support

Bei Sicherheitsfragen oder -problemen wenden Sie sich an Ihren Systemadministrator.
