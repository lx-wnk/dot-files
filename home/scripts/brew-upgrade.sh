brew update -q && brew upgrade -q
#brew upgrade -q --casks $(brew list --casks)
brew upgrade -q --casks $(brew list --casks -1 | grep --invert-match phpstorm) # exclude phpstorm from update due to latest changes