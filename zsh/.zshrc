# main zsh settings. env in ~/.zprofile
# read second

# source global shell alias & variables files
[ -f "$XDG_CONFIG_HOME/zsh/aliases.sh" ] && source "$XDG_CONFIG_HOME/zsh/aliases.sh"
[ -f "$XDG_CONFIG_HOME/zsh/vars" ] && source "$XDG_CONFIG_HOME/zsh/vars"

# load modules
zmodload zsh/complist
autoload -U compinit && compinit
autoload -U colors && colors
# autoload -U tetris # main attraction of zsh, obviously

# cmp opts
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select # tab opens cmp menu
zstyle ':completion:*' special-dirs true # force . and .. to show in cmp menu
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33 # colorize cmp menu
# zstyle ':completion:*' file-list true # more detailed list
zstyle ':completion:*' squeeze-slashes false # explicit disable to allow /*/ expansion

_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  # If the completion list is empty, just continue with filename selection
  if [ -z "$completions" ]
  then
    _arguments '*::arguments: _normal'
    return
  fi

  # This is not a variable assignment, don't remove spaces!
  _values = "${(ps:\n:)completions}"
}
compdef _dotnet_zsh_complete dotnet

# main opts
setopt HIST_IGNORE_SPACE   # Ignore commands starting with space
setopt HIST_IGNORE_DUPS     # Ignore duplicates
setopt append_history inc_append_history share_history # better history
# on exit, history appends rather than overwrites; history is appended as soon as cmds executed; history shared across sessions
setopt auto_menu menu_complete # autocmp first menu match
setopt autocd # type a dir to cd
setopt auto_param_slash # when a dir is completed, add a / instead of a trailing space
setopt no_case_glob no_case_match # make cmp case insensitive
setopt globdots # include dotfiles
setopt extended_glob # match ~ # ^
setopt interactive_comments # allow comments in shell
unsetopt prompt_sp # don't autoclean blanklines
stty stop undef # disable accidental ctrl s

# history opts
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$XDG_CACHE_HOME/zsh_history" # move histfile to cache
#HISTCONTROL=ignoreboth # consecutive duplicates & commands starting with space are not saved

# fzf setup
source <(fzf --zsh) # allow for fzf history widget
#alias pj="cd $(find $HOME/workspace/ -type d | fzf --height=30% --preview 'eza -T --level=2 {}')" # Project Finder

function fzf-history-search-with-preview() {
  local selected=$(fc -rl 1 | fzf --height=40% --preview 'echo {} | sed "s/ *[0-9]* *//" | bat --color=always --style=numbers --language=sh')
  if [ -n "$selected" ]; then
    LBUFFER="$selected"
    zle redisplay
  fi
}
zle -N fzf-history-search-with-preview

# binds
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^j" backward-word
bindkey "^k" forward-word
#:bindkey "^k" kill-line
bindkey "^H" backward-kill-word
# ctrl J & K for going up and down in prev commands
bindkey "^J" history-search-forward
bindkey "^K" history-search-backward
#bindkey '^R' fzf-history-widget
bindkey '^R' fzf-history-search-with-preview

# vi mode
bindkey -v
export KEYTIMEOUT=1
export EDITOR="nvim"
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
export VI_MODE_SET_CURSOR=true

function zle-keymap-selection() {
    if [[ ${{KEYMAP}} == vicmd ]]; then
        echo -ne '\e[2 q' # block
    else
        echo -ne '\e[6 q' # beam
    fi
}
zle -N zle-keymap-selection

function zle-line-init() {
    zle -K viins
    echo -ne '\e[6 q' # beam
}
zle -N zle-line-init

function vi-yank-clipboard {
    zle vi-yank
    echo "$CUTBUFFER" | pbcopy -i # MacOS tool, Linux xclip
}
zle -N vi-yank-clipboard
bindkey -M vicmd 'y' vi-yank-clipboard

# open fff file manager with ctrl f
# openfff() {
#  fff <$TTY
#  zle redisplay
#}
#zle -N openfff
#bindkey '^f' openfff

source "$XDG_CONFIG_HOME/zsh/plugins.zsh"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && source "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[[ ! -r '/Users/brethel/.opam/opam-init/init.zsh' ]] || source '/Users/brethel/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# terminal title
precmd() { print -Pn "\e]0;%~\a" }  # Show current dir in terminal title
REPORTTIME=10  # Print execution time for commands taking >10s
chpwd() { eza -laF -snew --color=always | tail -10 } # auto LS after CD

# set up prompt
#NEWLINE=$'\n'
#PROMPT="${NEWLINE}%K{#2E3440}%F{#E5E9F0}$(date +%_I:%M%P) %K{#3b4252}%F{#ECEFF4} %n %K{#4c566a} %~ %f%k ❯ "
# PROMPT="${NEWLINE}%K{$COL0}%F{$COL1}$(date +%_I:%M%P) %K{$COL0}%F{$COL2} %n %K{$COL3} %~ %f%k ❯ " # pywal colors, from postrun script
#echo -e "${NEWLINE}\033[48;2;46;52;64;38;2;216;222;233m $0 \033[0m\033[48;2;59;66;82;38;2;216;222;233m $(uptime -p | cut -c 4-) \033[0m\033[48;2;76;86;106;38;2;216;222;233m $(uname -r) \033[0m"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# better prompt
#starship_precmd_user_func() {
#  starship module directory
#}
#export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/transient.toml"
eval "$(starship init zsh)"

export PATH="/opt/homebrew/sbin:$PATH"
export PATH="$PATH:$HOME/.dotnet/tools/"
