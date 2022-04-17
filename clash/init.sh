#!/bin/sh
# initialize clash

check_deps() {
    for dep in $1; do
        if ! command -v ${dep} > /dev/null; then
            echo "require command \"${dep}\", but not found"
            return 1
        fi
    done
}

if ! check_deps "sudo file wget"; then
    echo "Check your dependencies!"
    exit 1
fi

if ! command -v clash > /dev/null; then
    if uname -a | grep -i "manjaro" > /dev/null; then
        # for manjaro, install directly from pacman
        echo "Installing clash from pacman..."
        sudo pacman -S clash
    elif [ -z $1 ]; then
        echo "Downloading clash from github..."
        echo "If you have trouble downloading, please the file manually & feed directory to the script."
        wget -O clash.bin https://github.com/Dreamacro/clash/releases/download/v1.10.0/clash-linux-amd64-v3-v1.10.0.gz | gunzip > clash.bin
        chmod 755 clash.bin
        sudo mv clash.bin /usr/local/bin/clash
    else
        if ! file $1 | grep "ELF" > /dev/null; then
            read -p "Warning: input file $1 is not an ELF. Sure to continue(y/n)?" user_ok
            if [ $user_ok != 'y' ]; then
                exit 1
            fi
        fi
        sudo cp $1 /usr/local/bin/clash
        sudo chmod 755 /usr/local/bin/clash
    fi
    echo "Installed clash."
fi

if [ ! -d /etc/clash ]; then
    sudo mkdir /etc/clash
fi

# check if configuration file exists
if [ ! -e /etc/clash/config.yaml ]; then
    # download new one from url
    read -p "Url for clash subscription: " clash_url
    echo ${clash_url}
    while ! wget -O config.yaml ${clash_url}; do
        read -p "Download failed, enter url: " clash_url
    done
    sudo cp config.yaml /etc/clash/config.yaml
fi

if ! command -v systemctl > /dev/null; then
    echo "Could not find systemctl."
    echo "Fire up clash manually if you want to start clash."
    exit 1
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
sudo systemctl enable clash
sudo systemctl restart clash

echo "Done, clash service should be up and running"
