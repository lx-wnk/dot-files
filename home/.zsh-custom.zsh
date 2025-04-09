source ~/shell.alias.sh
source ~/remote-server-list.sh

# brew specific paths
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# autosuggest settings
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#663399,standout"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1


# Theme + plugins
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
   aliases
   brew
   direnv
   git
   macos
   colored-man-pages # self explanatory
   safe-paste # self explanatory
   wd # directory jumper
)

#  history search adjustments
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
setopt rmstarsilent

# PATH changes
export PATH="/usr/local/opt/libpq/bin:$PATH"
export PATH="$HOME/.symfony/bin:$PATH"
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
export PATH=/usr/local/bin/php:$PATH
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="$HOME/Library/Python/3.9/bin/:$PATH"
export PATH="$PATH:$HOME/scripts"
export PATH="$PATH:/$HOME/.docker/cli-plugins"

# nix shell fi
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
   . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

#hooks
## evals
eval "$(direnv hook zsh)"
eval "$(thefuck --alias)"

## source
source <(fzf --zsh)
