#!/bin/sh
echo "Installing zerotier..."
curl -s https://install.zerotier.com | sudo bash

# join network
DEFAULT_ZT_NETWORK_ID=b15644912e5ab646

read -p "Zerotier network id(default ${DEFAULT_ZT_NETWORK_ID}):" input
ZT_NETWORK_ID=${input:-$DEFAULT_ZT_NETWORK_ID}

echo "Joining..."
sudo zerotier-cli join $ZT_NETWORK_ID
