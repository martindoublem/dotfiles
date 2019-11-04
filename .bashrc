#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias dmesg='dmesg --color=always'

man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
export WB_FORCE_SYSTEM_COLORS=1	       # workbench color force
# and so on



# Get Virtual Env
#if [[ $VIRTUAL_ENV != "" ]]
#    then
#      # Strip out the path and just leave the env name
#      venv=" ${RED}(${VIRTUAL_ENV##*/})"
#else
#     # In case you don't have one activated
#      venv=''
#fi

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

#PS1="(`basename \"$VIRTUAL_ENV\"`) $PS1
set_prompt()
{
   local last_cmd=$?
   local txtreset='$(tput sgr0)'
   local txtbold='$(tput bold)'
   local txtblack='$(tput setaf 0)'
   local txtred='$(tput setaf 1)'
   local txtgreen='$(tput setaf 2)'
   local txtyellow='$(tput setaf 3)'
   local txtblue='$(tput setaf 4)'
   local txtpurple='$(tput setaf 5)'
   local txtcyan='$(tput setaf 6)'
   local txtwhite='$(tput setaf 7)'
   # unicode "✗"
   local fancyx='\342\234\227'
   # unicode "✓"
   local checkmark='\342\234\223'
   
   
   # Line 1: a red "✗" or a green "✓" and the error number
   if [[ $last_cmd == 0 ]]; then
      PS1="\[$txtgreen\]$checkmark \[$txtreset\]\[$txtbold\](0) \n"
   else
      PS1="\[$txtred\]$fancyx \[$txtreset\]\[$txtbold\]($last_cmd) \n"
   fi
   # Line 2: shell name @ hostname and  Directory
   PS1+="\[$txtbold\] $venv \s @ \[$txtblue\]\h\[$txtreset\]\[$txtbold\]: \[$txtgreen\]\w   \[$txtred\] `basename \"$VIRTUAL_ENV\"` \n"
   # Line 3: date time
   PS1+="\[$txtreset\]\[$txtbold\] --->>>\[$txtred\] \$(parse_git_branch) \[$txtyellow\] \d \[$txtreset\]\[$txtbold\]\t "
   # User color: red for root, yellow for others
   if [[ $EUID == 0 ]]; then
       PS1+="\[$txtred\]"
   else
       PS1+="\[$txtcyan\]"   
   fi
   # Line 3 continued: user and command symbol
   PS1+="\u \\$ \[$txtreset\]"
}
PROMPT_COMMAND='set_prompt'
export EDITOR=nano
export PATH=$PATH:$HOME/dev/weboob/scripts
export PYTHONPATH=$PYTHONPATH:$HOME/dev/weboob
