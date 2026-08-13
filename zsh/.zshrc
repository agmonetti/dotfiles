# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==========================================
# OH MY ZSH CORE
# ==========================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins básicos
plugins=(git)
source $ZSH/oh-my-zsh.sh

# ==========================================
# CONFIGURACIÓN BASE (portable)
# ==========================================

# --- RUTAS Y ENTORNO ---
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export EDITOR="micro"

# --- COLORES Y RENDERIZADO ---
export COLORTERM=truecolor
export MICRO_TRUECOLOR=1

# --- DOTFILES DIR (usado por scripts de wallpaper, waybar, hyprland) ---
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

# --- HISTORIAL ---
HISTSIZE=10000
SAVEHIST=20000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

# --- ALIAS GENERALES ---
alias update='sudo pacman -Syu'
alias c='clear'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias pip='python3 -m pip'
alias pp='poweroff'
alias sp='systemctl suspend'

# pnpm como gestor por defecto
npm() { command pnpm "$@"; }

# --- NVM (Node Version Manager) ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- BUN ---
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# --- GO ---
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# --- FZF (Ctrl+R para historial en kitty) ---
export FZF_DEFAULT_OPTS="--height 12 --layout=reverse --border=rounded --margin=1,2"
export FZF_CTRL_R_OPTS="--exact"
source /usr/share/fzf/key-bindings.zsh

# --- POWERLEVEL10K THEME ---
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- PERSONAL / ESPECÍFICO DE LA MÁQUINA ---
# Alias, funciones o secretos propios van en ~/.zshrc.local (no versionado).
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
