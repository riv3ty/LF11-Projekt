#cloud-config
users:
  - name: sysadmin
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
    shell: /bin/bash
    lock_passwd: true
    ssh_authorized_keys:
      - ${ssh_public_key}

ssh_pwauth: false

package_update: true
package_upgrade: true

packages:
  - htop
  - git
  - neofetch
  - unattended-upgrades
  - apt-listchanges

runcmd:
  - systemctl enable unattended-upgrades
  - systemctl start unattended-upgrades
  - echo 'Unattended-Upgrade::Automatic-Reboot "false";' >> /etc/apt/apt.conf.d/50unattended-upgrades
  - echo 'Unattended-Upgrade::Automatic-Reboot-Time "03:00";' >> /etc/apt/apt.conf.d/50unattended-upgrades
  - sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
  - sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
  - sed -i 's/#PermitRootLogin yes/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
  - sed -i 's/PermitRootLogin yes/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
  - systemctl restart sshd

final_message: "System setup complete. SSH password authentication disabled. Automatic security updates enabled."
