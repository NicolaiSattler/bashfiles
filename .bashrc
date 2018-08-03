source ~/.git-completion.bash
source ~/.bash-powerline.sh
#source ~/.git-open.sh

declare HIGHLIGHT="\e[01;34m"
declare NORMAL='\e[00m'
declare rootdir='<ENTER_ROOT_DIR>'
declare branch='develop'
declare red=`tput setaf 1`
declare green=`tput setaf 2`
declare reset=`tput sgr0`
declare -a releaseVersions=("release/v1.0.0")

loopdir()
{
    currentFolder=$(pwd)

    #go to directory
    cd $rootdir

    #loop over all subdirectories and execute git command
    find . -maxdepth 1 -mindepth 1 -type d -exec sh -c "(echo {}; cd {}; $1; echo -n)" \;

    #return to previous folder
    cd $currentFolder
}

setbranch()
{
     branch="$1";
}

getbranch()
{
    branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
}
setrelease(){
    currentFolder=$(pwd)

    #go to directory
    cd $rootdir

    find . -name .git -type d -prune | while read d; do
        cd $d/..
        echo "$d"

        for i in "${releaseVersions[@]}"
        do
            if [ "`git branch --list $i`" ]; then
                git checkout "$i"
                break
            fi
        done

        cd $OLDPWD
    done

    #return to previous folder
    cd $currentFolder
}

git_commit(){
    getbranch
    git commit -a -m "$branch - $1"
}


pullrequest() {
  defaultBranch='origin/develop'
  url=$(git config --get remote.origin.url);
  git request-pull $defaultBranch $url $get_branch
}

cdroot(){
    while ! [  -d .git ]; do
    cd ..
    done
}

prev () {
    # default to current directory if no previous
    local prevdir="./"
    local cwd=${PWD##*/}
    if [[ -z $cwd ]]; then
        # $PWD must be /
        echo 'No previous directory.' >&2
        return 1
    fi
    for x in ../*/; do
        if [[ ${x#../} == ${cwd}/ ]]; then
            # found cwd
            if [[ $prevdir == ./ ]]; then
                echo 'No previous directory.' >&2
                return 1
            fi
            cd "$prevdir"
            return
        fi
        if [[ -d $x ]]; then
            prevdir=$x
        fi
    done
    # Should never get here.
    echo 'Directory not changed.' >&2
    return 1
}

next () {
    local foundcwd=
    local cwd=${PWD##*/}
    if [[ -z $cwd ]]; then
        # $PWD must be /
        echo 'No next directory.' >&2
        return 1
    fi
    for x in ../*/; do
        if [[ -n $foundcwd ]]; then
            if [[ -d $x ]]; then
                cd "$x"
                return
            fi
        elif [[ ${x#../} == ${cwd}/ ]]; then
            foundcwd=1
        fi
    done
    echo 'No next directory.' >&2
    return 1
}

#cmd
alias c='clear'
alias ..='cd ..'
alias ll='ls -la' #display files in list + hidden files

#git
alias ga='git add -i'
alias gb='git branch -a'
alias gd='git diff'
alias gs='git status -s -b --show-stash --untracked-files'
alias gf='git fetch'
alias gp='getbranch; git pull origin $branch'
alias gco='git checkout $1'
alias gcn='git checkout -b $1'
alias gm='git merge $1'
alias gc='git_commit'
alias gpr='getbranch; git push origin $branch'
alias cleanup='git branch --merged | grep  -v "\\*\\|master\\|develop" | xargs -n 1 git branch -d'
alias graphfull='git log --graph --all --decorate --oneline --stat'
#alias graph='git log --graph --decorate --oneline --pretty=format:"%Cred%h%Creset %s %Cgreen(%cr)%Creset" --abbrev-commit --date=relative'
alias graph='git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n""          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)" --all'
alias dircheckout='loopdir "git checkout $branch"'
alias dirstatus='loopdir "git status -s"'
alias dirbranch='loopdir "git rev-parse --abbrev-ref HEAD"'
alias dirfetch='loopdir "git fetch"'
alias dirpull='loopdir "git pull"'
alias dirgc='loopdir "git gc"'
