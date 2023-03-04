#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -f ~/.welcome_screen ]] && . ~/.welcome_screen

#_set_liveuser_PS1() {
#    PS1='[\u@\h \W]\$ '
#    if [ "$(whoami)" = "liveuser" ] ; then
#        local iso_version="$(grep ^VERSION= /usr/lib/endeavouros-release 2>/dev/null | cut -d '=' -f 2)"
#        if [ -n "$iso_version" ] ; then
#            local prefix="eos-"
#            local iso_info="$prefix$iso_version"
#            PS1="[\u@$iso_info \W]\$ "
#        fi
#    fi
#}
#_set_liveuser_PS1
#unset -f _set_liveuser_PS1

#ShowInstallerIsoInfo() {
#    local file=/usr/lib/endeavouros-release
#    if [ -r $file ] ; then
#        cat $file
#    else
#        echo "Sorry, installer ISO info is not available." >&2
#    fi
#}


alias ls='ls --color=auto'
alias ll='ls -lav --ignore=..'   # show long listing of all except ".."
alias l='ls -lav --ignore=.?*'   # show long listing but no hidden dotfiles except "."
alias ls='ls --color=auto'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias dmesg='dmesg --color=always'

[[ "$(whoami)" = "root" ]] && return

[[ -z "$FUNCNEST" ]] && export FUNCNEST=100          # limits recursive functions, see 'man bash'

## Use the up and down arrow keys for finding a command in history
## (you can write some initial letters of the command first).
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

################################################################################
## Some generally useful functions.
## Consider uncommenting aliases below to start using these functions.
##
## October 2021: removed many obsolete functions. If you still need them, please look at
## https://github.com/EndeavourOS-archive/EndeavourOS-archiso/raw/master/airootfs/etc/skel/.bashrc

_open_files_for_editing() {
    # Open any given document file(s) for editing (or just viewing).
    # Note1:
    #    - Do not use for executable files!
    # Note2:
    #    - Uses 'mime' bindings, so you may need to use
    #      e.g. a file manager to make proper file bindings.

    if [ -x /usr/bin/exo-open ] ; then
        echo "exo-open $@" >&2
        setsid exo-open "$@" >& /dev/null
        return
    fi
    if [ -x /usr/bin/xdg-open ] ; then
        for file in "$@" ; do
            echo "xdg-open $file" >&2
            setsid xdg-open "$file" >& /dev/null
        done
        return
    fi

    echo "$FUNCNAME: package 'xdg-utils' or 'exo' is required." >&2
}

#------------------------------------------------------------

## Aliases for the functions above.
## Uncomment an alias if you want to use it.
##

# alias ef='_open_files_for_editing'     # 'ef' opens given file(s) for editing
# alias pacdiff=eos-pacdiff
################################################################################

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
   PS1+="\[$txtbold\] $venv \s @ \[$txtblue\]\h\[$txtreset\]\[$txtbold\]: \[$txtgreen\]\w   \[$txtred\] `basename \"$VIRTUAL_ENV\"`$CONDA_DEFAULT_ENV \n"
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
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/etc/profile.d/conda.sh" ]; then
        . "/usr/etc/profile.d/conda.sh"
    else
        export PATH="/usr/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

