# Procédure : Installation de zsh + Zinit

Zinit est le meilleur choix, pour plusieurs raisons :

- Chargement **lazy** des plugins — zsh démarre plus vite
- Mise à jour de tous les plugins en une commande (`zinit update`)
- Pas besoin de gérer les `source` manuellement pour chaque plugin
- Très actif et maintenu

---

## Fichiers de configuration

Créer les fichiers de config en copiant le contenu depuis le projet :

```bash
nano ~/.zshrc
# ou
micro ~/.zshrc
```

Choisir le bon contenu selon la machine :
- **Serveur / WSL** → copier le contenu de `.zshrc`
- **Poste client (Ghostty, terminal graphique)** → copier le contenu de `.zshrc-client`

Faire de même pour les aliases :

```bash
nano ~/.aliases
# ou
micro ~/.aliases
```

Copier le contenu de `.aliases`.

---

## Étapes

### 1. Installer les dépendances

#### exa / eza (requis pour les alias `ls`, `ll`, `la`, `lt`…)

`eza` est le fork maintenu de `exa` — préférer `eza` quand disponible.

**Arch Linux**
```bash
sudo pacman -S eza
```

**Debian / Ubuntu**
```bash
sudo apt install eza
# Si indisponible sur ta version :
sudo apt install exa
```

**AlmaLinux / RHEL**
```bash
# Activer EPEL si pas déjà fait
sudo dnf install epel-release
sudo dnf install eza
# Si indisponible :
sudo dnf install exa
```

> Après installation, aucune modification des aliases n'est nécessaire si tu as installé `eza` : remplacer `exa` par `eza` dans `~/.aliases`.

---

### 2. Installer zsh

**Arch Linux**
```bash
sudo pacman -S zsh
```

**Debian / Ubuntu**
```bash
sudo apt install zsh
```

**AlmaLinux / RHEL**
```bash
sudo dnf install zsh
```

### 3. Définir zsh comme shell par défaut

```bash
chsh -s $(which zsh)
```

Déconnecte/reconnecte ta session SSH pour que ça prenne effet.

### 4. Lancer zsh

```bash
zsh
```

Zinit s'installe automatiquement au premier lancement grâce au bloc d'auto-install dans le `.zshrc`.

### 5. Recharger

```bash
source ~/.zshrc
```

Zinit téléchargera les plugins au premier chargement.

---

## Extension à root

Répéter les étapes 3 à 5 en session root (`sudo -i`), en copiant les mêmes fichiers de config.
