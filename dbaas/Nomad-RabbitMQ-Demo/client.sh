#! /bin/bash

(
cat <<-EOF
	[Unit]
	Description=consul agent
	Requires=network-online.target
	After=network-online.target

	[Service]
	Restart=on-failure
	ExecStart=/usr/bin/consul agent -client 0.0.0.0 -bind $(ip route get 1 | awk '{print $NF;exit}') -data-dir /tmp/consul-data -join $(cat /vagrant/server_ip)
	ExecReload=/bin/kill -HUP $MAINPID

	[Install]
	WantedBy=multi-user.target
EOF
) | sudo tee /etc/systemd/system/consul.service

sudo systemctl enable consul.service
sudo systemctl start consul

sleep 5

(
cat <<-EOF
	client {
		enabled = true
	}

	consul {
		address = "127.0.0.1:8500"
	}

	vault {
		enabled = true
		address = "http://nomad1.mshome.net:8200"
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
	ExecStart=/usr/bin/nomad agent -join nomad.service.consul:4646 -config /etc/nomad.d
	ExecReload=/bin/kill -HUP $MAINPID
	User=root
	Group=root

	[Install]
	WantedBy=multi-user.target
EOF
) | sudo tee /etc/systemd/system/nomad.service

sudo systemctl enable nomad.service
sudo systemctl start nomad