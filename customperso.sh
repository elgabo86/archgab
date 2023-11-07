 # Pyenv control
if grep -q 'ID=arch' /etc/os-release; then
    export PYENV_ROOT="$HOME/.pyenv"
	command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init -)"
fi

# fr_CH fix
export LANG=fr_CH.UTF-8

#alias list

alias golist="cat /etc/profile.d/customperso.sh | grep alias"

alias goyou="ytfzf"
alias goyou-th="ytfzf -t -T chafa"
alias goody="ytfzf -cO"
alias goody-th="ytfzf -t -T chafa -cO"
alias goody-nsfw="ytfzf --nsfw -cO"
alias goody-nsfw-th="ytfzf -t -T chafa --nsfw -cO"
alias gopee="ytfzf -cP"
alias gopee-th="ytfzf -t -T chafa -cP"

alias gomovie="mov-cli"
alias gomovie2="lobster"
alias goanime="ani-cli"

alias goyew="yt"
alias goyew-video-off="yt set show_video false"
alias goyew-video-on="yt set show_video true"

alias goradio="pyradio --no-themes"

alias gospeedtest="speedtest++"

alias gosend="ffsend upload"

alias gogeek="edex-ui"
alias goholly="hollywood"

alias goconv="ffmpeg -i"
