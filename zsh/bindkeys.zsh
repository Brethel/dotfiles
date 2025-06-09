# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

zmodload zsh/terminfo

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[ShiftTab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
#[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-beginning-search
#[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-beginning-search
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[ShiftTab]}"  ]] && bindkey -- "${key[ShiftTab]}"  reverse-menu-complete
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        history-substring-search-up
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      history-substring-search-down
#[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        history-beginning-search-backward-end
#[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      history-beginning-search-forward-end

bindkey "^[[1;3C" forward-word  # ALT+LEFT
bindkey "^[[1;3D" backward-word # ALT+RIGHT
#
bindkey '^[[1;9D' beginning-of-line
bindkey '^[[1;9C' end-of-line
bindkey '^[[1;3A' beginning-of-line # ALT+UP
bindkey '^[[1;3B' end-of-line       # ALT+DOWN
#bindkey -M menuselect '^[' undo
#bindkey -M menuselect '^i' .expand-or-complete-prefix

#bindkey '^[[A' history-substring-search-up
#bindkey '^[[B' history-substring-search-down
