#########################
## alias for php (mamp)
#########################
#for filename in /Applications/MAMP/bin/php/php*; do
#    PHP_VER=$(echo $(basename $filename) | sed 's/\.[^.]*$//' | sed 's/\.[a-z.]*//g')
#    PECL_VER=$(echo "${PHP_VER/php/pecl}")
#    ln -sfn "${filename}/bin/php" "/usr/local/bin/${PHP_VER}"
#    ln -sfn "${filename}/bin/pecl" "/usr/local/bin/${PECL_VER}"
#done

#########################
## alias for php (brew)
#########################
#for filename in /usr/local/Cellar/php*/*; do
#    PHP_VER=$(echo $(basename $filename) | sed 's/\.[^.]*$//' | sed 's/\.[a-z.]*//g')
#    PECL_VER=$(echo "${PHP_VER/php/pecl}")
#    ln -sfn "${filename}/bin/php" "/usr/local/bin/php${PHP_VER}"
#    ln -sfn "${filename}/bin/pecl" "/usr/local/bin/pecl${PECL_VER}"
#done

#########################
## alias for main php version
#########################
#if [[ ! -f /usr/local/bin/php ]]; then
#    ln -sfn /usr/local/bin/php81 /usr/local/bin/php
#fi

#symlink pecl
if [[ ! -f /usr/local/bin/pecl ]]; then
    ln -sfn /usr/local/bin/pecl81 /usr/local/bin/pecl
fi

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

#git
#git config --global alias.co checkout
#git config --global alias.br branch
#git config --global alias.ci commit
#git config --global alias.st status
alias gp="git push"
alias gpf="gp --force-with-lease"
alias gfa="git fetch --all"
alias ga="git add"
alias gc="git commit"
# delete all merged branches
alias gbdm='git branch --merged | egrep -v "(^\*|master|staging|develop|main|trunk)" | xargs git branch -d'
# visual representation of a git repository
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