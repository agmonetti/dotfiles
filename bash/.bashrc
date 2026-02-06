# ~/.bashrc -

# Si no es interactivo, no hacer nada
[[ $- != *i* ]] && return

# --- 1. CONFIGURACIÓN DEL SISTEMA (PATH y PROMPT) ---

# Añadir .local/bin al PATH
export PATH="$HOME/.local/bin:$PATH"

# Prompt con colores (Usuario verde, Ruta azul) 
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Configuración del Historial (Vital para no perder comandos)
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups # No guarda duplicados ni espacios en blanco

# Editor por defecto (útil para git, visudo, etc)
export EDITOR="code"

# --- 2. ALIAS DE NAVEGACIÓN Y UTILIDAD ---

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -alF'      # Listar todo con detalles
alias la='ls -A'        # Listar todo menos . y ..
alias ..='cd ..'        # Subir un nivel
alias ...='cd ../..'    # Subir dos niveles
alias update='sudo pacman -Syu' # Actualizar Arch fácil

# Limpiar pantalla rápido
alias c='clear'

# --- 3. CARGA DE HERRAMIENTAS ---

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 

# Homebrew 
if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
fi

# --- 4. CARGA DE SECRETOS ---
if [ -f ~/.bash_secrets ]; then
    source ~/.bash_secrets
fi
