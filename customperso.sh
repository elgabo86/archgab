 # Pyenv control
if grep -q 'ID=arch' /etc/os-release; then
    export PYENV_ROOT="$HOME/.pyenv"
	command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init -)"
fi

# fr_CH fix
export LANG=fr_CH.UTF-8

# alias

alias goyou="ytfzf"
alias goyou-th="ytfzf -t -T chafa"
alias goody="ytfzf -cO"
alias goody-th="ytfzf -t -T chafa -cO"
alias goody-nsfw="ytfzf --nsfw -cO"
alias goody-nsfw-th="ytfzf -t -T chafa --nsfw -cO"
alias gopee="ytfzf -cP"
alias gopee-th="ytfzf -t -T chafa -cP"
