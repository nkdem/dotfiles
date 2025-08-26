autoload -U colors && colors	# Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "


ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

export SSH_AUTH_SOCK=/Users/nkdem/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock

eval "$(zoxide init zsh)"
export PATH="/opt/homebrew/opt/rustup/bin:$PATH"

alias vim=nvim
alias preview="wezterm imgcat"

# zsh-fzf-history-search
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search
zinit snippet 'https://github.com/zsh-users/zsh-autosuggestions/raw/master/zsh-autosuggestions.zsh'
zinit snippet 'https://github.com/MichaelAquilina/zsh-you-should-use/raw/master/you-should-use.plugin.zsh'
zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit snippet OMZ::plugins/brew/brew.plugin.zsh
zinit snippet OMZ::plugins/golang/golang.plugin.zsh
zinit light zsh-users/zsh-syntax-highlighting
