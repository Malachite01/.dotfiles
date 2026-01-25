# Fastfetch
if command -v fastfetch &> /dev/null; then
    fastfetch
fi

# Historique
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# Autocomplétion
autoload -Uz compinit && compinit

# Plugins (dnf)
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# Starship prompt
eval "$(starship init zsh)"

# ----------
#   ALIAS
#-----------

# Pour redemarrer waybar
alias reload-waybar='~/.config/waybar/scripts/reboot.sh'

# Web apps
alias create-webapp='~/.config/hypr/scripts/create-webapp.sh'
alias remove-webapp='~/.config/hypr/scripts/remove-webapp.sh'
alias list-webapp='~/.config/hypr/scripts/list-webapp.sh'

# Lsd
alias ls='lsd'

alias i='sudo dnf install'

alias vi='nvim'

# ----------
#  SCRIPTS
#-----------

[[ -o interactive ]] && chpwd() { lsd }

# Pour creer le dossier si jamais il existe pas en mv
mvmk() {
  if [ $# -lt 2 ]; then
    command mv "$@"
    return $?
  fi

  dest="${@: -1}"

  if [ -d "$dest" ]; then
    command mv "$@"
  else
    dir=$(dirname "$dest")
    mkdir -p "$dir" && command mv "$@"
  fi
}


# Terminal iddle lavat
IDLE_DELAY=30 # secondes avant idle
TMOUT=$IDLE_DELAY
IDLE_RUNNING=0
TRAPALRM() {
  [[ -n $BUFFER ]] && { TMOUT=$IDLE_DELAY; return }
  (( IDLE_RUNNING )) && { TMOUT=$IDLE_DELAY; return }
  IDLE_RUNNING=1
  # lavat à été modifié et recompilé pour que chaque touche fasse quitter
  lavat -g -c FE5617 -k FB9438 -s 2 -C -b 7 -R 2
  zle reset-prompt 2>/dev/null
  IDLE_RUNNING=0
  TMOUT=$IDLE_DELAY
}
