# .dotfiles

Mes dotfiles personnels gérés avec GNU Stow.

## C'est quoi Stow ?

Stow crée des **liens symboliques** (symlinks) depuis `~/.dotfiles` vers le répertoire home `~/`.
Pour créer un **package** stow **nom_package/chemin_a_partir_de_home**.

**Exemple :**
```
            ↓ (stow crée un lien)
~/.config/kitty/ → ~/.dotfiles/kitty/.config/kitty/
```

Une fois le lien créé, éditer `~/.config/kitty/kitty.conf` modifie **directement** le fichier dans `.dotfiles`.

## Ma structure

```
~/.dotfiles/
├── fastfetch
├── gtk
├── hypr
├── kitty
├── nvim
├── qt6ct
├── quickshell
├── rofi
├── starship
├── wallpaper
│   └── Images
│       └── Wallpaper
├── waybar
├── zsh/
│   └── .config/zsh/        # Fichiers dans .config
│       └── plugins/
├── zsh-config/
└   └── .zshrc              # Fichiers à la racine de $HOME
...
```

> [!WARNING]  
> Chaque dossier de premier niveau (`kitty/`, `nvim/`, etc.) est un **package**. À l'intérieur, on recrée la structure à partir du `$HOME`.

## Exemples

### Ajouter une nouvelle config (exemple avec kitty)

```bash
# Créer la structure du package
cd ~/.dotfiles
mkdir -p kitty/.config/kitty

# Copier config existante
cp -r ~/.config/kitty/* kitty/.config/kitty/

# Supprimer l'original
rm -rf ~/.config/kitty
# ou mv ~/.config/kitty ~/.config/kitty.backup

# Créer le symlink
stow kitty

# Vérifier que c'est un lien
ls -lah ~/.config/kitty
# Doit montrer : kitty -> ../../.dotfiles/kitty/.config/kitty
```

**Maintenant, tout fichier édité dans `~/.config/kitty/` modifie directement `.dotfiles/`**

### Ajouter un fichier à la racine de $HOME (exemple .zshrc)

```bash
cd ~/.dotfiles

# Créer un package
mkdir -p zsh-config

# Copier le fichier
cp ~/.zshrc zsh-config/.zshrc

# Supprimer l'original
rm ~/.zshrc

# Créer le symlink
stow zsh-config

# Vérifier
ls -la ~/.zshrc
# Doit montrer : .zshrc -> .dotfiles/zsh-config/.zshrc
```

### Ajouter un sous-dossier spécifique (exemple ~/Images/Wallpaper)

Si on veut **uniquement** sauvegarder `~/Images/Wallpaper/` mais pas tout `~/Images/` :

```bash
cd ~/.dotfiles

# Créer la structure
mkdir -p wallpaper/Images/Wallpaper

# Copier les fichiers
cp -r ~/Images/Wallpaper/* wallpaper/Images/Wallpaper/

# Supprimer le dossier original
rm -rf ~/Images/Wallpaper

# Créer le symlink
stow wallpaper

# Vérifier
ls -la ~/Images/
```


## Cloner sur un nouvel ordinateur

```bash
# 1. Cloner le dépôt
git clone git@github.com:Malachite01/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 2. Installer tous les packages
stow .
# ou a la main stow kitty nvim etc..
```

## Commandes utiles

```bash
# Créer les symlinks
stow kitty

# Supprimer les symlinks
stow -D kitty

# Re-créer (utile après modifications)
stow -R kitty

# Voir ce que stow ferait (simulation)
stow -n kitty
```


## Aide

- [Tutoriel vidéo](https://www.youtube.com/watch?v=NoFiYOqnC4o)
- [Documentation Stow](https://www.gnu.org/software/stow/)
