#!/bin/sh
# initialize clash

check_deps() {
    if ! command -v curl > /dev/null; then
        echo "install curl first"
        return 1
    fi

    if ! command -v sudo > /dev/null; then
        echo "install sudo first"
        return 1
    fi
}

if ! check_deps; then
    echo "check your dependencies first"
    exit 1
fi

if ! command -v clash > /dev/null; then
    echo "installing clash..."
    # download latest clash from github
    curl -L https://github.com/Dreamacro/clash/releases/download/v1.10.0/clash-linux-amd64-v3-v1.10.0.gz | gunzip > clash.bin
    chmod 755 clash.bin
    sudo mv clash.bin /usr/local/bin/clash
fi

if [ ! -d /etc/clash ]; then
    sudo mkdir /etc/clash
fi

# check if configuration file exists
if [ ! -e /etc/clash/config.yaml ]; then
    # download new one from url
    read -p "Url for clash subscription: " clash_url
    while ! curl -L -O config.yaml ${clash_url}; do
        echo "Download failed, enter url: " clash_url
    done
    sudo cp config.yaml /etc/clash/config.yaml
fi

# configure systemd service
cat <<EOF | sudo tee /etc/systemd/system/clash.service
[Unit]
Description=Clash daemon, A rule-based proxy in Go.
After=network.target

[Service]
Type=simple
Restart=always
ExecStart=/usr/local/bin/clash -d /etc/clash

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl restart clash

echo "Done, clash should be up and running"
