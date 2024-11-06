#!/bin/bash

# Script pour installer des outils et configurer zsh sur Arch Linux
# - Outils : git, exa, fastfetch
# - Thème : powerlevel10k
# - Plugins Oh My ZSH : zsh-autosuggestions, zsh-syntax-highlighting, fast-syntax-highlighting, zsh-autocomplete
# - Installation et configuration de la police MesloLGS NF pour Konsole

# Couleurs pour les messages
cyan="\033[1;36m"
red="\033[1;31m"
reset="\033[0m"

# Fonction pour afficher un message de succès ou d'échec
function check_result() {
  if [ $? -eq 0 ];then
    echo -e "${cyan}$1 réussi !${reset}"
  else
    echo -e "${red}$1 échoué !${reset}"
  fi
}

# Installation de yay 
echo -e "${cyan}Installation de yay...${reset}"
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd ..
check_result "Installation de yay"

# Téléchargement et installation de la police MesloLGS NF
echo -e "${cyan}Téléchargement de MesloLGS NF...${reset}"
yay -S ttf-meslo-nerd
check_result "Installation de la police MesloLGS NF"
sleep 1

# Modification de la configuration de Konsole pour utiliser MesloLGS NF
echo -e "${cyan}Configuration de Konsole pour utiliser MesloLGS NF...${reset}"

# Création du fichier de configuration si inexistant
konsole_config_path="$HOME/.local/share/konsole"
mkdir -p "$konsole_config_path"
profile_file="$konsole_config_path/MyProfile.profile"

if [ ! -f "$profile_file" ];then
  cat <<EOF > "$profile_file"
[Appearance]
ColorScheme=WhiteOnBlack

[Font]
Font=MesloLGS NF,12,-1,5,50,0,0,0,0,0
EOF
else
  # Modifier la police si le fichier de configuration existe
  sed -i '/^Font=/d' "$profile_file"
  echo "Font=MesloLGS NF,12,-1,5,50,0,0,0,0,0" >> "$profile_file"
fi

check_result "Configuration de la police MesloLGS NF dans Konsole"

# Demande à l'utilisateur de sélectionner le profil dans Konsole
echo -e "${cyan}Veuillez sélectionner 'MyProfile' dans les paramètres de Konsole pour appliquer la nouvelle police.${reset}"
sleep 3

# Modification de /etc/pacman.conf
echo -e "${cyan}Modification de /etc/pacman.conf pour activer la couleur et les téléchargements parallèles...${reset}"

# Décommenter les lignes désirées dans /etc/pacman.conf
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf

# Décommenter les sections [core], [extra], et [multilib] ainsi que leurs lignes Include
sudo sed -i '/^#\[core\]$/ { s/^#//; n; s/^#Include/Include/ }' /etc/pacman.conf
sudo sed -i '/^#\[extra\]$/ { s/^#//; n; s/^#Include/Include/ }' /etc/pacman.conf
sudo sed -i '/^#\[multilib\]$/ { s/^#//; n; s/^#Include/Include/ }' /etc/pacman.conf

# Ajouter ou modifier ParallelDownloads à 5
sudo sed -i '/^#ParallelDownloads/s/^#//' /etc/pacman.conf
sudo sed -i '/^ParallelDownloads/!s/^ParallelDownloads = 5/ParallelDownloads = 5/' /etc/pacman.conf

check_result "Modification de pacman.conf"
sleep 1

# Mise à jour du système
echo -e "${cyan}Mise à jour du système...${reset}"
sudo pacman -Syu --noconfirm
check_result "Mise à jour du système"
sleep 1


# Liste des paquets à installer
packages=("git" "zsh" "curl" "exa" "fastfetch" "reflector")

# Installation des paquets
for package in "${packages[@]}"; do
  echo -e "${cyan}Installation de $package...${reset}"
  sudo pacman -S --noconfirm "$package" >/dev/null
  check_result "Installation de $package"
  echo -e "\n\n"
  sleep 1
done

# Modification du Mirrorlist
sudo reflector --country 'France' --latest 5 --age 2 --fastest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
sleep 5

# Installation de Oh My ZSH
sudo rm -rf ~/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sleep 5

# Installation du thème powerlevel10k
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Clonage des plugins Oh My ZSH
sudo git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sleep 2
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sleep 2
sudo git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
sleep 2
sudo git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete
sleep 2

# Configuration de ~/.zshrc
echo -e "Configuration ZSH"
# Remplacer la ligne 'plugins=(git)' par la liste des plugins désirés
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
alias clear="clear && fastfetch"
EOF

echo -e "Création des Alias terminée"

sleep 1
# Application des modifications de ~/.zshrc
echo -e "Changement de répertoire"
cd ..
echo -e "Application des modifications"
zsh ~/.zshrc
echo -e "Configuration terminée, lancement du module de configuration" 
# Mise en place de fastfetch
sudo sed -i '1i # Lancement de Fastfetch\nfastfetch\n' ~/.zshrc

# Mise en place de zsh au lieu de bash
sudo sed -i '1i exec zsh' ~/.bashrc

sleep 5 
# Définir zsh comme shell par défaut (facultatif)
# Si vous souhaitez que zsh soit votre shell par défaut, décommentez la ligne suivante
chsh -s $(which zsh)

exit 0
