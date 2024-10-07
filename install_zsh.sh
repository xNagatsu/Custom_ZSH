#!/bin/bash

# Script pour installer des outils et configurer zsh
# - Outils : git, exa
# - Thème : powerlevel10k
# - Plugins Oh My ZSH : zsh-autosuggestions, zsh-syntax-highlighting, fast-syntax-highlighting, zsh-autocomplete

# Couleurs pour les messages
cyan="\033[1;36m"
red="\033[1;31m"
reset="\033[0m"

# Fonction pour afficher un message de succès ou d'échec
function check_result() {
  if [ $? -eq 0 ]; then
    echo -e "${cyan}$1 réussi !${reset}"
  else
    echo -e "${red}$1 échouée !${reset}"
  fi
}

# Informations sur les polices de caractères MesloLGS NF
echo -e "${cyan}Pour un meilleur rendu du terminal, installez et utilisez les polices d'écriture MesloLGS NF dans votre terminal (Tabby) afin d'afficher correctement les logos et autres éléments.${reset}"
sleep 3

# Liste des paquets à installer
packages=("git" "zsh" "curl" "exa")

# Installation des paquets
for package in "${packages[@]}"; do
  echo -e "${cyan}Installation de $package...${reset}"
  sudo apt-get -y install "$package" >/dev/null
  check_result "Installation de $package"
  echo -e "\n\n"
  sleep 1
done

# Installation de Oh My ZSH
sudo rm -rf ~/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sleep 5

# Installation du thème powerlevel10k
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Clonage des plugins Oh My ZSH
sudo rm -rf ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sleep 1
sudo git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sleep 2
sudo rm -rf ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sleep 1
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sleep 2
sudo rm -rf ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
sleep 1
sudo git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
sleep 2
sudo rm -rf ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}plugins/zsh-autocomplete
sleep 1
sudo git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete
sleep 2

# Configuration de ~/.zshrc
echo -e "Configuration ZSH"
# Remplacer la ligne 'plugins=(git)' par la liste des plugins désirés
echo -e "Activation Plugins"
sudo sed -i 's/^\(plugins=\)\(.*\)$/\1(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' ~/.zshrc
sleep 1
# Définir le thème powerlevel10k
echo -e "Changement du thème"
sudo sed -i 's/ZSH_THEME="[^"]*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
sleep 1
# Ajouter des alias personnalisés (facultatif)
echo -e "Création des Alias"
sleep 1
sudo cat << EOF >> ~/.zshrc
# Alias personnalisés pour des commandes courantes
alias ls="exa -a --icons"
alias ll="exa -la --icons"
alias la="exa -lagh --icons"
alias lt="exa -a --tree --icons --level=2"
alias ltf="exa -a --tree --icons"
alias lat="exa -lagh --tree --icons"
alias ipa="ip -c a"
EOF
echo -e "Création des Alias terminée"

sleep 1
# Application des modifications de ~/.zshrc
echo -e "Changement de répertoire"
cd ..
echo -e "Application des modifications"
zsh ~/.zshrc
echo -e "Configuration terminer lancement du module de configuration" 

sleep 5 
# Définir zsh comme shell par défaut (facultatif)
# Si vous souhaitez que zsh soit votre shell par défaut, décommentez la ligne suivante
chsh -s $(which zsh)

exit 0
