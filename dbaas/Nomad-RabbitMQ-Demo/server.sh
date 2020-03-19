#! /bin/bash

(
cat <<-EOF
	[Unit]
	Description=consul agent
	Requires=network-online.target
	After=network-online.target

	[Service]
	Restart=on-failure
	ExecStart=/usr/bin/consul agent -dev -client 0.0.0.0 -bind $(ip route get 1 | awk '{print $NF;exit}')
	ExecReload=/bin/kill -HUP $MAINPID

	[Install]
	WantedBy=multi-user.target
EOF
) | sudo tee /etc/systemd/system/consul.service

sudo systemctl enable consul.service
sudo systemctl start consul


(
cat <<-EOF
	[Unit]
	Description=vault
	Requires=network-online.target
	After=network-online.target

	[Service]
	Restart=on-failure
	ExecStart=/usr/bin/vault server -dev -dev-listen-address="0.0.0.0:8200" -dev-root-token-id="vault"
	ExecReload=/bin/kill -HUP $MAINPID

	[Install]
	WantedBy=multi-user.target
EOF
) | sudo tee /etc/systemd/system/vault.service

sudo systemctl enable vault.service
sudo systemctl start vault

sleep 5

export VAULT_TOKEN=vault
export VAULT_ADDR="http://localhost:8200"

vault policy write rabbit /vagrant/vault/rabbit-policy.hcl
vault policy write nomad-server /vagrant/vault/nomad-server-policy.hcl
vault write auth/token/roles/nomad-cluster @/vagrant/vault/nomad-cluster-role.json

vault_token=$(vault token create -policy nomad-server -period 72h -orphan -field=token)


domain="mshome.net"
vault secrets enable pki
vault secrets tune -max-lease-ttl=87600h pki

vault write -field=certificate pki/root/generate/internal common_name="$domain" ttl=87600h \
    > /vagrant/vault/mshome.crt

vault write pki/config/urls \
    issuing_certificates="$VAULT_ADDR/v1/pki/ca" \
    crl_distribution_points="$VAULT_ADDR/v1/pki/crl"

vault write pki/roles/rabbit \
    allowed_domains="$domain" \
    allow_subdomains=true \
    generate_lease=true \
    max_ttl="720h"


(
cat <<-EOF
	data_dir = "/opt/nomad/data"
	bind_addr = "$(ip route get 1 | awk '{print $NF;exit}')"

	server {
		enabled = true
		bootstrap_expect = 1
	}

	client {
		enabled = true
	}

	consul {
		address = "127.0.0.1:8500"
	}

	vault {
		enabled = true
		address = "http://localhost:8200"
		task_token_ttl = "1h"
		create_from_role = "nomad-cluster"
		token = "$vault_token"
	}
EOF
) | sudo tee /etc/nomad.d/nomad.hcl

(
cat <<-EOF
	[Unit]
	Description=nomad server and client
	Requires=network-online.target
	After=network-online.target

	[Service]
	Restart=on-failure
	ExecStart=/usr/bin/nomad agent -config /etc/nomad.d
	ExecReload=/bin/kill -HUP $MAINPID
	User=root
	Group=root

	[Install]
	WantedBy=multi-user.target
EOF
) | sudo tee /etc/systemd/system/nomad.service

sudo systemctl enable nomad.service
sudo systemctl start nomad