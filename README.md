# dotfiles

My personal dotfiles using stow.

# Import my dotfiles

# How to use Stow ?

Stow is a symlink farm manager. This .dotfiles directory has the same structure as ~/ ($HOME directory)

Examples :

```bash
# For ~/.zshrc
cd ~/.dotfiles
cp ~/.zshrc .
ls -lah
# rm ~/.zshrc or mv ~/.zshrc ~/.zshrc.bak

# For fastfetch
cp -r ~/.config/fastfetch ~/.dotfiles/.config/fastfetch
stow --adopt .

```

For a more in depth tutorial [click here](https://www.youtube.com/watch?v=y6XCebnB9gs)

# Structure
