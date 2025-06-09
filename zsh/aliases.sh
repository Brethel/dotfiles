#

alias ll='eza -lhaF --color=always'
alias l='eza -lhF --color=always'

#alias la='exa --group-directories-first --icons --header --color=always -snew -lahF'
alias la='eza -alF --long --group-directories-first --icons --header --color=always -snew'

alias v=nvim
alias vi=nvim
alias vim=nvim
alias more=most
alias g=git
alias grep='rg --color=always'
alias top=glances

if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
	# replace BSD utils for GNU counterparts
	alias du=gdu
	alias df=gdf
	alias cp=gcp
  alias cat=gcat
	alias brewup='brew update && brew upgrade --greedy-auto-updates && brew upgrade --cask --greedy-auto-updates && brew cleanup && brew doctor'
fi

