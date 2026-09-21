# claude / agent stuff
# Secrets: ~/.config/claude/common.env is loaded for every shell by .zshrc.
# These wrappers layer <account>.env on top in a subshell, so nothing leaks back into the shell.
# Add a variable to the account file only when personal and work need different values for it.
claude-personal() (
  set -a; [ -f $HOME/.config/claude/personal.env ] && . $HOME/.config/claude/personal.env; set +a
  exec $HOME/code/_privat/projects/agent-dashboard/bin/kontor live --permission-mode auto "$@"
)
claude-work() (
  set -a; [ -f $HOME/.config/claude/work.env ] && . $HOME/.config/claude/work.env; set +a
  CLAUDE_CONFIG_DIR=$HOME/.claude-work exec $HOME/code/_privat/projects/agent-dashboard/bin/kontor live --permission-mode auto "$@"
)


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
alias dockerStopAll="docker-stop-all.sh"

# git @see: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
alias gpd="git push dasistweb"
alias gpo="git push origin"
alias gcm="git checkout main"
## delete all merged branches
alias gbdm='git branch --merged | egrep -v "(^\*|master|staging|develop|main|trunk)" | xargs git branch -d'
## visual representation of a git repository
alias gourceNicer="gource --time-scale 2.0 --file-idle-time 0 --seconds-per-day 2 --auto-skip-seconds 1 --camera-mode overview --bloom-multiplier 2.0 --bloom-intensity 0.1 --multi-sampling --max-user-speed 100 --file-extensions --highlight-users --dir-colour cccccc"

#etc
alias brave="open -na /Applications/Brave\ Browser.app/Contents/MacOS/Brave\ Browser"
alias portListen="netstat -ap tcp | grep -i 'listen'"
# EXA is currently not maintained
#alias ls="exa -alFB --git"
#alias lexa="exa -labF --color auto --git"
# ask for priv-key password every 6h
alias rememberMe='ssh-add -t 6h'
alias currentDockerForceRestart='docker kill $(docker ps -aq) && docker-compose up -d'
alias ssh='TERM=xterm-256color ssh'


# little helper
alias generateUuidV4="uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '-'"
alias generateUuid="generateUuidV4"
alias unixTimeStamp="date +%s"

toLower() {
    echo "$@" | tr '[:upper:]' '[:lower:]'
}
toUpper() {
    echo "$@" | tr '[:lower:]' '[:upper:]'
}
