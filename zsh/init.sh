#!/bin/bash
# initialize zsh & configuration

check_deps() {
    for dep in $1; do
        if ! command -v ${dep} > /dev/null; then
            echo "require command \"${dep}\", but not found"
            return 1
        fi
    done
}

if ! check_deps "sudo wget zsh"; then
    echo "Check your dependencies!"
    exit 1
fi

# install oh-my-zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# install powerlevel10k
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/^ZSH_THEME=/ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc

# copy configuration file
cp p10k.zsh ~/.p10k.zsh

# we're done
echo "Successfully configured zsh"
