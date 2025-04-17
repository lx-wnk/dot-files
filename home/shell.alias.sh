#python version
alias python="python3"
alias pip="pip3"

#updates
alias updateAllBrew="~/.scripts/brew-upgrade.sh"
alias updateAllPip="sudo pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"
alias updateAllNpm="npm update -g"
alias updateAllComposer="composer global update"
alias updateAllGem="sudo gem update"
alias updateAll="updateAllBrew; updateAllPip; updateAllGem; updateAllComposer; updateAllNpm"

# cleanup
## docker
alias dockerCleanupContainer="docker container ls -a | grep 'months ago' | awk '{print $1}' | xargs docker container rm"
alias dockerCleanupImages="docker images | grep 'months ago' | awk '{print $3}' | xargs docker rmi"
alias dockerKillContainers="docker kill $(docker ps -aq)"

# git @see: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
alias gpd="git push dasistweb"
alias gpo="git push origin"
## delete all merged branches
alias gbdm='git branch --merged | egrep -v "(^\*|master|staging|develop|main|trunk)" | xargs git branch -d'
## visual representation of a git repository
alias gourceNicer="gource --time-scale 2.0 --file-idle-time 0 --seconds-per-day 2 --auto-skip-seconds 1 --camera-mode overview --bloom-multiplier 2.0 --bloom-intensity 0.1 --multi-sampling --max-user-speed 100 --file-extensions --highlight-users --dir-colour cccccc"

# environment fixes
alias gem=/usr/local/opt/ruby/bin/gem
alias ruby=/usr/local/opt/ruby/bin/ruby
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

# composer
alias composer="php /usr/local/bin/composer"
export COMPOSER_HOME=$HOME/.composer

#etc
alias brave="open -na /Applications/Brave\ Browser.app/Contents/MacOS/Brave\ Browser"
alias portListen="netstat -ap tcp | grep -i 'listen'"
# EXA is currently not maintained
#alias ls="exa -alFB --git"
#alias lexa="exa -labF --color auto --git"
# ask for priv-key password every 6h
alias rememberMe='ssh-add -t 6h'
alias currentDockerForceRestart='docker kill $(docker ps -aq) && docker-compose up -d'

alias generateUuid="uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '-'"