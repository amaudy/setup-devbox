resource "digitalocean_droplet" "web_devbox" {
  image  = "ubuntu-20-04-x64"
  name   = "webdevbox"
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

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "digitalocean_firewall" "web_devbox" {
  name = "webdevbox-firewall"

  droplet_ids = [digitalocean_droplet.web_devbox.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "1-65535"
    source_addresses = ["${chomp(data.http.myip.body)}/32"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol         = "tcp"
    port_range       = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol         = "udp"
    port_range       = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

}

output "droplet_ip_addresses" {
  value = {
    "Your Development machine IP is:" = digitalocean_droplet.web_devbox.ipv4_address
  }
}