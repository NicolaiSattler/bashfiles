source ~/git-completion.bash

editbranch='develop'

setbranch(){ editbranch="$1";}

alias dircheckout='find . -maxdepth 1 -mindepth 1 -type d -exec sh -c "(echo {} && cd {} && git checkout $editbranch && echo)" \;'
alias dirstatus='find . -maxdepth 1 -mindepth 1 -type d -exec sh -c "(echo {} && cd {} && git status -s && echo)" \;'
alias dirfetch='find . -maxdepth 1 -mindepth 1 -type d -exec sh -c "(echo {} && cd {} && git fetch && echo)" \;'
alias dirpull='find . -maxdepth 1 -mindepth 1 -type d -exec sh -c "(echo {} && cd {} && git pull && echo)" \;'
