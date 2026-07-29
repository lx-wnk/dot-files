#!/usr/bin/env bash

# install brew (needs password)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# update pip
/usr/local/opt/python@3.9/bin/python3.9 -m pip install --upgrade pip
curl -sS https://get.symfony.com/cli/installer | bash
mv $HOME/.symfony/bin/symfony /usr/local/bin/

# package installation
bash ./mac/init-brew.sh
bash ./mac/init-npm.sh
bash ./mac/init-pip.sh
bash ./mac/init-custom-stuff.sh

# create symlinks
ln -sfn $(pwd)/home/* $HOME/

## claude setup
CLAUDE_ACCOUNTS=(personal work)
for acct in "${CLAUDE_ACCOUNTS[@]}"; do
  dir="$HOME/.claude-$acct"
  mkdir -p "$dir"
  # tracked and symlinked, so a repo edit reaches the account without re-seeding.
  # Each account owns a full, standalone CLAUDE.md and settings.json — deliberately duplicated
  # rather than shared, so there is no import or merge mechanism to reason about.
  ln -sfn "$(pwd)/home/.claude-$acct/CLAUDE.md" "$dir/CLAUDE.md"
  ln -sfn "$(pwd)/home/.claude-$acct/settings.json" "$dir/settings.json"
  # skills are NOT managed here — they ship via the skills@lx_wnk-marketplace plugin (github.com/lx-wnk/skills)
  # settings.local.json stays untracked: the private per-machine escape hatch
done
### default: ~/.claude -> personal
ln -sfn "$HOME/.claude-personal" "$HOME/.claude"
### secrets never live in a tracked file: shared baseline plus one optional file per account
mkdir -p "$HOME/.config/claude"
for env_file in common personal work; do
  target="$HOME/.config/claude/$env_file.env"
  [ -f "$target" ] && continue
  case "$env_file" in
    common) cp "$(pwd)/dist/claude-common.env.dist" "$target" ;;
    *) cp "$(pwd)/dist/claude-account.env.dist" "$target" ;;
  esac
  chmod 600 "$target"
  echo ">> Created $target from template — fill in real values!"
done

## misc links
ln -sfn $(pwd)/home/.vimrc $HOME/.vimrc
ln -sfn $(pwd)/home/.p10k.zsh $HOME/.p10k.zsh
ln -sfn $(pwd)/home/.zshrc $HOME/.zshrc
ln -sfn $(pwd)/home/.git* $HOME/

mkdir -p $HOME/.config
ln -sfn $(pwd)/home/.config/* $HOME/.config/


# create symlinks for .config
mkdir -p $HOME/.config # make sure .config exists
for src in $(pwd)/home/.config/*/; do
  name=$(basename "$src")
  rm -rf $HOME/.config/"$name"
  ln -sfn "$src" $HOME/.config/"$name"
done

# init folders
mkdir -p $HOME/code/_privat
mkdir -p $HOME/code/_work