 # Pyenv control
if grep -q 'ID=arch' /etc/os-release; then
    export PYENV_ROOT="$HOME/.pyenv"
	command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init -)"
fi

# fr_CH fix
export LANG=fr_CH.UTF-8
