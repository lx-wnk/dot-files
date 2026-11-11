brew update -q && brew upgrade -q
brew upgrade -q --casks $(brew list --casks)

# cleanup with cache deps
brew cleanup -s