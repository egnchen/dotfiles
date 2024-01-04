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
sed -i 's/^ZSH_THEME=.*$/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc

# copy & enable configuration file
# get directory of this script file
filedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cp $filedir/p10k.zsh ~/.p10k.zsh
cat << EOF >> ~/.zshrc
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

# enable instant prompt
tempfile=$(mktemp)
cat - ~/.zshrc <<"EOF" > ${tempfile}
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
EOF
mv ${tempfile} ~/.zshrc

echo "Successfully configured zsh"
