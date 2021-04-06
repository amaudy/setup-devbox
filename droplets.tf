resource "digitalocean_droplet" "web" {
  image  = "ubuntu-20-04-x64"
  name   = "devbox"
  region = "sgp1"
  size   = "s-2vcpu-4gb"
  tags   = [ "devbox" ]

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


resource "digitalocean_firewall" "web" {
  name = "devbox-firewall"

  droplet_ids = [digitalocean_droplet.web.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["159.192.0.0/16"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

output "droplet_ip_addresses" {
  value = {
    "Your Development machine IP is:" = digitalocean_droplet.web.ipv4_address
  }
}