autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

git_branch() {
  echo $(xcrun git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  st=$(xcrun git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
    echo ""
  else
    if [[ $st == "nothing to commit (working directory clean)" ]]
    then
      echo "(%{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%})"
    else
      echo "(%{$fg_bold[red]%}$(git_prompt_info)%{$fg[green]%} ಠ_ಠ %{$reset_color%})"
    fi
  fi
}

git_prompt_info () {
 ref=$(xcrun git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

unpushed () {
  xcrun git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " %{$fg_bold[magenta]%}✈%{$reset_color%} "
  fi
}


directory_name(){
  echo "%{$fg_bold[cyan]%}${PWD/#$HOME/~}%{$reset_color%}"
}

export PROMPT=$'$(directory_name) $(git_dirty)$(need_push)\n %{$fg_bold[blue]%}⚗%{$reset_color%} '
set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}%{$reset_color%}"
}

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}
