# My Neovim Configuration

A highly customized and personalized [Newovim](https://neovim.io) configuration focused on Java, Ruby and Lua development. 
I added my personal keymaps that I use in everyday development.

## Required Software

1. I use [Packer](https://github.com/wbthomason/packer.nvim) for plugin management.
You can install Packer using the following command:

```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```
2. Telescope grep function requires [ripgrep](https://github.com/BurntSushi/ripgrep#installation).

You can install it using the following command:
```sh
brew install ripgrep
```

## Installation

To install this configuration on your computer, follow these steps: 

### Step 1: Backup Existing Configuration

It's recommended to back up your current Neovim configuration:

```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

### Step 2: Clone This Repository

```bash
git clone https://github.com/yourusername/your-neovim-config.git ~/.config/nvim
```

### Step 3: Install Plugins

Open Neovim and install plugins:

```vim
:PackerInstall
```
