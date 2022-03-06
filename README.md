# Setup Development box on Ubuntu 20.04 at DigitalOcean

## Why?

Due of my MacbookAir 2012 can not use Docker. I have to off load my development environment to other machine.


## How to use this repository?

* [Create DigitalOcean Personal Token](https://cloud.digitalocean.com/account/api/tokens)
* Prepare configuration (developer key, ssh public key for Terraform)


## Run Terraform

*The public key must password free, private key with keyphase will not work with Terraform*

```bash
terraform init
```

```bash
terraform apply -var "do_token=${DO_PAT}" -var "pvt_key=$HOME/user/.ssh/id_ed25519" -var "pub_key=$HOME/user/.ssh/id_ed25519.pub"
```


### Run Ansible Playbook

```
ansible-playbook -i hosts setup-devbox.yml
```

If `sudo` need password

```
ansible-playbook -i hosts setup-devbox.yml --extra-vars "ansible_sudo_pass=your_sudo_password"
```


## Terraform

- Slug for instance type https://slugs.do-api.dev
