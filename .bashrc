# ~/.bashrc: executed by bash(1) for non-login shells.

# 1. GARDE-FOU IMMÉDIAT : Si la session n'est pas interactive, on s'arrête net ici.
case $- in
    *i*) ;;
      *) return;;
esac

# 2. AFFICHAGE (Uniquement exécuté en interactif grâce au garde-fou ci-dessus)
if command -v fastfetch >/dev/null 2>&1; then
    fastfetch
fi

# 3. CONFIGURATION DE L'HISTORIQUE
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend   # Ajoute au fichier d'historique plutôt que de l'écraser
shopt -s cmdhist      # Aligne les commandes multi-lignes

# Synchronise l'historique entre plusieurs terminaux ouverts en temps réel
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# 4. COMPORTEMENT DU TERMINAL
shopt -s checkwinsize # Mise à jour de LINES et COLUMNS après chaque commande

# 5. CONFIGURATION DU PROMPT (COULEURS)
if [ -n "$TERM" ] && [ "$TERM" != "dumb" ] && tput setaf 1 >/dev/null 2>&1; then
    GREEN=$(tput setaf 2)
    BLUE=$(tput setaf 4)
    RESET=$(tput sgr0)
    PS1="\[${GREEN}\]\u@\h\[${RESET}\]:\[${BLUE}\]\w\[${RESET}\]\$ "
else
    PS1='\u@\h:\w\$ '
fi

# Titre de la fenêtre dynamique pour les terminaux graphiques/multiplexeurs
case "$TERM" in
    xterm*|rxvt*|tmux*|screen*)
        PS1="\[\e]0;\u@\h: \w\a\]$PS1"
        ;;
esac

# 6. ALIAS ET FONCTIONS EXTERNES
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# 7. COMPLÉTION PROGRAMMABLE
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
