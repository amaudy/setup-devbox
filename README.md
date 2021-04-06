# Setup Development box on Ubuntu 20.04

Automate create Linux users, copy private key and install Docker/Docker compose at remote server.

Purpose for quick setup development box.

## How to use this repository?

After clone to your machine

- Make sure you can ssh to target server
- Copy `hosts.example` to `hosts` and put IP address
- Copy `vars/default.yml.ecample` to `vars/default.yml`


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