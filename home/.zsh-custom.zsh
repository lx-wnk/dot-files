source ~/shell.alias.sh
source ~/remote-server-list.sh

# brew stuff
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Theme + plugins

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
   git
   macos
   colored-man-pages
   safe-paste
   zsh-autosuggestions
   zsh-syntax-highlighting
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

# nix shell
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
   . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

#hooks
## evals
eval "$(direnv hook zsh)"
eval "$(thefuck --alias)"
## source
source <(fzf --zsh)
