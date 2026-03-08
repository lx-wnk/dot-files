#python version
alias python="python3"
alias pip="pip3"

# cleanup
## docker
alias dockerCleanupContainer="docker container ls -a | grep 'months ago' | awk '{print $1}' | xargs docker container rm"
alias dockerCleanupImages="docker images | grep 'months ago' | awk '{print $3}' | xargs docker rmi"
dockerKillContainers() { docker kill $(docker ps -aq); }
alias dockerStopAll="docker-stop-all.sh"

# git @see: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
alias gpd="git push dasistweb"
alias gpo="git push origin"
alias gcm="git checkout main"
## delete all merged branches
alias gbdm='git branch --merged | egrep -v "(^\*|master|staging|develop|main|trunk)" | xargs git branch -d'
## visual representation of a git repository
alias gourceNicer="gource --time-scale 2.0 --file-idle-time 0 --seconds-per-day 2 --auto-skip-seconds 1 --camera-mode overview --bloom-multiplier 2.0 --bloom-intensity 0.1 --multi-sampling --max-user-speed 100 --file-extensions --highlight-users --dir-colour cccccc"

# environment fixes
#alias gem=/usr/local/opt/ruby/bin/gem
#alias ruby=/usr/local/opt/ruby/bin/ruby
#export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

# composer
alias composer="php /usr/local/bin/composer"
export COMPOSER_HOME=$HOME/.composer

#etc
alias brave="open -na /Applications/Brave\ Browser.app/Contents/MacOS/Brave\ Browser"
alias portListen="netstat -ap tcp | grep -i 'listen'"
# eza (maintained fork of exa)
#alias ls="eza -alFB --git"
#alias leza="eza -labF --color auto --git"
# ask for priv-key password every 6h
alias rememberMe='ssh-add -t 6h'
currentDockerForceRestart() { docker kill $(docker ps -aq) && docker-compose up -d; }

# little helper
alias generateUuid="uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '-'"
alias unixTimeStamp="date +%s"
toLower() {
    echo "$@" | tr '[:upper:]' '[:lower:]'
}
toUpper() {
    echo "$@" | tr '[:lower:]' '[:upper:]'
}
