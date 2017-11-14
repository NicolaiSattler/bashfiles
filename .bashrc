source ~/git-completion.bash

dqbranch='develop'

setbranch(){ dqbranch="$1";}

alias dircheckout='find . -maxdepth 1 -mindepth 1 -type d -exec sh -c "(echo {} && cd {} && git checkout $dqbranch && echo)" \;'
alias dirstatus='find . -maxdepth 1 -mindepth 1 -type d -exec sh -c "(echo {} && cd {} && git status -s && echo)" \;'
alias dirfetch='find . -maxdepth 1 -mindepth 1 -type d -exec sh -c "(echo {} && cd {} && git fetch && echo)" \;'
alias dirpull='find . -maxdepth 1 -mindepth 1 -type d -exec sh -c "(echo {} && cd {} && git pull && echo)" \;'