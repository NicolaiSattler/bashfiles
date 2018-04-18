source ~/git-completion.bash
source ~/.bash-powerline.sh

#cmd
alias c='clear'
alias ..='cd ..'
alias ll='ls -la' #display files in list + hidden files

#git
alias gb='git branch -a'
alias gd='git diff'
alias gs='git status'
alias gf='git fetch'
alias gp='git pull'
alias gco='git checkout $1'
alias gcn='git checkout -b $1'
alias gm='git merge $1'
alias gc='git_commit'
alias gpr='getbranch; git push origin $dqbranch'
alias graphfull='git log --graph --all --decorate --oneline --stat'
alias graph='git log --graph --decorate --oneline --pretty=format:"%Cred%h%Creset %s %Cgreen(%cr)%Creset" --abbrev-commit --date=relative'
alias dircheckout='loopdir "git checkout $dqbranch"'
alias dirstatus='loopdir "git status -s"'
alias dirbranch='loopdir "git git rev-parse --abbrev-ref HEAD"'
alias dirfetch='loopdir "git fetch"'
alias dirpull='loopdir "git pull"'

declare rootdir='C:\Users\NicolaiSättler\Documents\DataQuint\'
loopdir()
{
    currentFolder=$(pwd)

    #go to directory
    cd $rootdir
    
    #loop over all subdirectories and execute git command
    find . -maxdepth 1 -mindepth 1 -type d -exec sh -c "(echo {} && cd {} && $1 && echo)" \;

    #return to previous folder
    cd $currentFolder
}


nugetRestore()
{
    #requires Chocolatey
    #requires nuget for commandline
    nuget restore "geovisia-online\GeoVisia.Online.All.sln"
    nuget restore "geovisia-online\GeoVisia.Online.Application"
    nuget restore "geovisia-online-components"
    nuget restore "geovisia-online-components-openlayers"
    nuget restore "geovisia-framework"
    nuget restore "dataquint-system-security\DataQuint.System.Security"
    nuget restore "geovisia-addon-cyclomedia\GeoVisia.Online.Addons.StreetSmart"
    nuget restore "geovisia-addon-maatregeltoets" 
    nuget restore "geovisia-addon-schouwen\GeoVisia.Online.Addon.sln"
}

dqbranch='develop'
setbranch()
{
     dqbranch="$1";
}
getbranch()
{
    dqbranch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
}


declare -a releaseVersions=("release/v1.0.0" 
                            "release/v1.0.1" 
                            "release/v1.0.2" 
                            "release/v1.0.3" 
                            "release/v1.0.4")
setrelease(){
    for i in "${releaseVersions[@]}"
    do
        echo "$i"
        setbranch "$i"
        dircheckout
    done
}

cdroot(){
    while ! [  -d .git ]; do
    cd ..
    done
}

pullrequest() {
  url = 'git config --get remote.origin.url';
  git request-pull $url "$1"
}

git(){
    command git "$@"
    local exitCode=$?
    if [ $exitCode -ne 0 ]; then
        printf "\033[0;31mERROR: git exited with code $exitCode\033[0m\n"
        return $exitCode
    fi
}
git_commit(){
    getbranch
    git commit -a -m "$dqbranch: $1"
}