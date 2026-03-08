# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# PATH configuration
typeset -U path
path=(
    "$HOME/.local/bin"
    "$HOME/.symfony/bin"
    "$HOME/.composer/vendor/bin"
    "$HOME/scripts"
    "/usr/local/opt/libpq/bin"
    "/usr/local/opt/mysql-client/bin"
    "/usr/local/bin/php"
    "$HOME/.docker/cli-plugins"
    $path
)

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# brew specific paths
BREW_PREFIX="$(brew --prefix)"
source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# autosuggest settings
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#663399,standout"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

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

source $ZSH/oh-my-zsh.sh

# history search adjustments
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
setopt rmstarsilent

# nix shell fi
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
   . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

#hooks
## evals
eval "$(atuin init zsh)"
eval "$(direnv hook zsh)"
eval "$(thefuck --alias)"

## source
source <(fzf --zsh)


# additional source files
source ~/shell.alias.sh
[[ -f ~/remote-server-list.sh ]] && source ~/remote-server-list.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
