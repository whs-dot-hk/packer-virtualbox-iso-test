source "virtualbox-iso" "test" {
  guest_os_type    = "Debian_64"
  iso_url          = "https://deb.debian.org/debian/dists/bullseye/main/installer-amd64/current/images/netboot/mini.iso"
  iso_checksum     = "c48b4ce1f5e4d62c2a42012aaae80db095163d8367b1c73a650499cf8521b4a7"
  ssh_username     = "whs"
  #ssh_password     = "magic"
  shutdown_command = "echo 'magic' | sudo -S shutdown -P now"
  http_content = {
    "/preseed.cfg" = file("preseed.cfg")
    "/custom.cfg" = file("custom.cfg")
    "/test.sh" = file("test.sh")
  }
  boot_command = [
    "<esc><wait>",
    "auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg PACKER_AUTHORIZED_KEY={{ .SSHPublicKey | urlquery }}<enter>"
  ]
  memory      = 2048
  ssh_timeout = "30m"
}

build {
  sources = ["sources.virtualbox-iso.test"]

  provisioner "ansible" {
    playbook_file = "ansible/playbook-nix.yaml"
    use_proxy     = false
    user          = "whs"
  }
}
