#!/bin/bash

# setup a ssh-tunnel through remote forwarding
# add it as a service using systemd

check_deps() {
    for dep in $1; do
        if ! command -v ${dep} > /dev/null; then
            echo "require command \"${dep}\", but not found"
            return 1
        fi
    done
}

if ! check_deps "sudo ssh-copy-id sshd systemctl"; then
    echo "Check your dependencies!"
    exit 1
fi

remote_host=dorm.eyek1.com
remote_port=22
remote_user=ssh_tunnel
tunnel_port=0

while getopts 'hput' opt; do
    case "$opt" in
        h)
            remote_host="$OPTARG"
            ;;
        p)
            remote_port="$OPTARG"
            if [ ! -n $remote_port ]; then
                echo "Remote port should be a number"
                exit 1
            fi
            ;;
        u)
            remote_user="$OPTARG"
            ;;
        t)
            tunnel_port="$OPTARG"
            if [ ! -n $tunnel_port ]; then
                echo "Tunnel port should be a number"
                exit 1
            fi
	    ;;
        ?)
            echo "Usage: init.sh -h <host> -p <port> -u <user> -t <tunnel_port>"
            ;;
    esac
done

if [ $tunnel_port -eq 0 ]; then
    echo "Tunnel port not specified, random port will be generated"
    tunnel_port=$((15000 + $RANDOM % 5000))
fi

# generate ssh key first
if [ ! -e ~/.ssh/id_rsa ]; then
    echo "Generating ssh key"
    if [ ! -d ~/.ssh ]; then
        mkdir ~/.ssh
    fi
    ssh-keygen -q -t rsa -N "" -f ~/.ssh/id_rsa
fi 

echo "copying ssh id. you might need to enter the password for remote host."
if ! ssh-copy-id ${remote_user}@${remote_host}; then
    echo "failed to copy ssh id."
    exit 1
fi

echo "Setting up ssh tunnel with ${remote_user}:${remote_host} port ${remote_port}"
echo "Remote tunnel port is ${tunnel_port}"

# try to establish the tunnel
# this would try to setup the remote port forwarding and open a terminal at the same time
ssh -R ${tunnel_port}:localhost:22 -o "ExitOnForwardFailure yes" ${remote_user}@${remote_host} "exit"

if [ ! $? ]; then
    echo "Remote host forwarding failed."
    exit 1
fi

srvname="ssh_tunnel_${remote_host}"
filename="/etc/systemd/system/${srvname}.service"
if [ -e $filename ]; then
    read -p "${filename} exists. Overwrite?(y/n) " do_overwrite
    if [ $do_overwrite != 'y' ]; then
        exit 1
    fi 
fi


sudo tee $filename <<EOF
[Unit]
Description=SSH tunnel service
After=network.target

[Service]
ExecStart=/usr/bin/ssh -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -o "ExitOnForwardFailure yes" -NR ${tunnel_port}:localhost:22 ${remote_user}@${remote_host} Restart=always
RestartSec=15s

[Install]
WantedBy=multi-user.target
EOF

if [ ! $? ]; then
    echo "Failed to write systemd service file."
    exit 1
fi

# reload, enable, start, the routine
sudo systemctl daemon-reload
sudo systemctl enable $srvname
sudo systemctl start $srvname

if sudo systemctl status $srvname; then
    echo "Successfully setup ssh tunnel to ${remote_host}."
    echo "Add this to your ssh config:"
    cat <<EOF
Host        "your hostname config here"
HostName    localhost
Port        ${tunnel_port}
ProxyCommand    ssh -p${remote_port} ${remote_user}@${remote_host}
EOF
else
    echo "Systemd service failed. Please check the detail with:"
    echo "$ sudo systemctl status $srvname"
    echo "Or edit the systemd service file:"
    echo "$ sudo vim $filename"
fi
