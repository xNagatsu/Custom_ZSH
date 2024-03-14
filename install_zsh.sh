#!/bin/bash
# Ce script installe les outils et les thèmes suivants :
# - git
# - zsh          https://github.com/zsh-users/zsh
# - power10k     https://github.com/romkatv/powerlevel10k
# - ohmyzsh      https://ohmyz.sh
# - exa          https://github.com/ogham/exa
# - zsh-autosuggestions
# - zsh-syntax-highlighting



# Couleurs pour les messages
cyan="\033[1;36m"
red="\033[1;31m"
reset="\033[0m"

# Fonction pour afficher un message de succès ou d'échec
function check_result {
  if [ $? -eq 0 ]; then
    echo -e "${cyan}$1 réussie !${reset}"
  else
    echo -e "${red}$1 échouée !${reset}"
  fi
}

# Precison pour meilleur rendu du terminal
  echo -e "${cyan}$1 Il faut installer les 4 polices d'ecriture MesloLGS NF et les utiliser dans notre terminal (Tabby) pour avoir les logos & cie${reset}"
sleep 3

# Liste des paquets à installer
packages=("git" "zsh" "exa" "zsh-autosuggestions" "zsh-syntax-highlighting")

# Installation des paquets
for package in "${packages[@]}"; do
  echo -e "${cyan}Installation de $package...${reset}"
  sudo apt-get -y install "$package" >/dev/null
  check_result "Installation de $package"
  echo -e "\n\n"
  sleep 1
done

# Installation de Oh My ZSH
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
#Installation du theme Power10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Plugins Oh My ZSH
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete

# Remplacer ligne plugins=(git) par plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete) et application du temp powerlevel10k
sed -i 's/plugins=\(git\)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' ~/.zshrc
sed -i 's/ZSH_THEME="[^"]*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

cat << EOF > ~/.zshrc

# Alias personnalisés 
alias ls="exa -a --icons \$argv"
alias ll="exa -la --icons \$argv"
alias la="exa -lagh --icons \$argv"
alias lt="exa -a --tree --icons --level=2 \$argv"
alias ltf="exa -a --tree --icons \$argv"
alias lat="exa -lagh -tree --icons \$argv"
alias update="sudo apt update && sudo apt upgrade -y"
alias ipa="ip -c a"

EOF

# Application des modifications de ~/.zshrc
source ~/.zshrc
