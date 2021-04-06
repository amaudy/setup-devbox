resource "digitalocean_droplet" "web" {
  count  = 1
  image  = "ubuntu-20-04-x64"
  name   = "devbox-${count.index}"
  region = "sgp1"
  size   = "s-2vcpu-4gb"

  ssh_keys = [
      data.digitalocean_ssh_key.terraform.id
  ]
  

  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install python3 -y", "echo Ready to continue"]

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
    //   private_key = file(var.pvt_key)
      agent       = "true"
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' --private-key ${var.pvt_key} -e 'pub_key=${var.pub_key}' setup-devbox.yml"
  }
}

output "droplet_ip_addresses" {
  value = {
    for droplet in digitalocean_droplet.web:
    droplet.name => droplet.ipv4_address
  }
}