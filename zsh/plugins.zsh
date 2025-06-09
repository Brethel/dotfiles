# "plugins" from https://github.com/zsh-users/
# has to be at the very end
PLUGINS=(
 "$XDG_DATA_HOME/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
#"$XDG_DATA_HOME/zsh/zsh-completions/zsh-completions.plugin.zsh"
#"$XDG_DATA_HOME/zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
 "$XDG_DATA_HOME/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
#"$XDG_DATA_HOME/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh"
 "$XDG_DATA_HOME/zsh/fzf-zsh-plugin/fzf-zsh-plugin.plugin.zsh" 
)

for p in $PLUGINS; do
	[ -f $p ] && source "$p" || echo "Plugin not found: $p" ]
done

upd-zsh() {
	pwd=$PWD
	for p in $PLUGINS; do
		echo $p
		d=${p%/*}
		cd $d
		[ -d ".git" ] && git pull
	done
	cd $pwd
	source $XDG_CONFIG_HOME/zsh/.zshrc
}

