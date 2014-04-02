# Prompt configuration
# {
function precmd {
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 1 ))

    # Truncate the path if it's too long.
    PR_FILLBAR=""
    PR_PWDLEN=""

    PR_ENV=$(virtualenv_prompt_info)
    PR_VCS="$(git_prompt_info)$(hg_prompt_info)$(svn_prompt_info)"

    local promptsize=${#${(%):- %n@%m:%l $PR_VCS -}}
    local pwdsize=${#${(%):-%~}}

    if [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; then
        ((PR_PWDLEN=$TERMWIDTH - $promptsize))
    else
    PR_BARCHAR=" "
    PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize)))..${PR_BARCHAR}.)}"
    fi
}

setprompt () {
    # Need this so the prompt will work.
    setopt prompt_subst

    # See if we can use colors.
    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -ge 8 ]]; then
    colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
    (( count = $count + 1 ))
    done
    PR_NO_COLOUR="%{$terminfo[sgr0]%}"

    PROMPT='$PR_GREEN┌ %(!.%SROOT%s.%n)$PR_GREEN@%m:%l $PR_YELLOW$PR_VCS $PR_CYAN\
${(e)PR_FILLBAR}$PR_CYAN%$PR_PWDLEN<...<%~%<<$PR_CYAN\

$PR_GREEN└ %D{%H:%M:%S}\
%(?.. $PR_LIGHT_RED%?)\
$PR_LIGHT_CYAN %(!.$PR_RED.$PR_WHITE)%# $PR_NO_COLOUR'

    RPROMPT=' $PR_MAGENTA$PR_ENV$PR_CYAN$PR_NO_COLOUR'

    PS2='($PR_LIGHT_GREEN%_$PR_CYAN)$PR_NO_COLOUR '
}

setprompt
# }


