# fr_CH fix
export LANG=fr_CH.UTF-8

# Pyenv control
if grep -q 'ID=arch' /etc/os-release; then
    export PYENV_ROOT="$HOME/.pyenv"
	command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init -)"
fi

alias yay="paru"

alias torzu-install="paru -Syu torzu-qt6-git  --noconfirm && distrobox-export --app torzu"
alias ryu-install="paru -Syu ryujinx  --noconfirm && distrobox-export --app ryujinx"
alias citron-install="paru -Syu citron-git  --noconfirm && distrobox-export --app citron"
alias qwen-install="paru -Syu npm --noconfirm && sudo npm install -g @qwen-code/qwen-code@latest && distrobox-export --bin /usr/bin/qwen"
