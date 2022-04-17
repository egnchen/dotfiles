#!/bin/sh

# dotfiles entrypoint

# welcome
cat <<"EOF"
      _       _      __ _ _
     | |     | |    / _(_) |
   __| | ___ | |_  | |_ _| | ___  ___
  / _` |/ _ \| __| |  _| | |/ _ \/ __|
 | (_| | (_) | |_  | | | | |  __/\__ \
  \__,_|\___/ \__| |_| |_|_|\___||___/
dotfiles by eyekill
EOF

if command -v git > /dev/null; then
    echo "revision " $(git log -n1 --pretty=format:"%H")
fi

# get distro and run corresponding init script
distro="undetermined"
if uname -a | grep -i "ubuntu" > /dev/null; then
    distro="ubuntu"
elif uname -a | grep -i "manjaro" > /dev/null; then
    distro="manjaro"
fi

if [ $distro == "undetermined" ]; then
    read -p "Cannot determine distro. Enter your distro(ubuntu/manjaro):" distro
fi

case $distro in
    "ubuntu")
        sh distros/ubuntu.sh
        ;;
    "manjaro")
        sh distros/manjaro.sh
        ;;
    *)
        echo "Unsupported distro ${distro}"
        exit 1
esac
