export CONDA_EXE=$(echo '/c/ProgramData/anaconda3/Scripts/conda.exe' | tr -d '\r')
export _CE_M=''
export _CE_CONDA=''
export CONDA_PYTHON_EXE='C:\ProgramData/anaconda3\python.exe'

# Copyright (C) 2012 Anaconda, Inc
# SPDX-License-Identifier: BSD-3-Clause

__add_sys_prefix_to_path() {
    # In dev-mode CONDA_EXE is python.exe and on Windows
    # it is in a different relative location to condabin.
    if [ -n "${_CE_CONDA}" ] && [ -n "${WINDIR+x}" ]; then
        SYSP=$(\dirname "${CONDA_EXE}")
        SYSP=$(echo ${SYSP} | tr -d '\r')
    else
        SYSP=$(\dirname "${CONDA_EXE}")
        SYSP=$(\dirname "${SYSP}")
        SYSP=$(echo ${SYSP} | tr -d '\r')
    fi

    if [ -n "${WINDIR+x}" ]; then
        PATH="${SYSP}/bin:${PATH}"
        PATH="${SYSP}/Scripts:${PATH}"
        PATH="${SYSP}/Library/bin:${PATH}"
        PATH="${SYSP}/Library/usr/bin:${PATH}"
        PATH="${SYSP}/Library/mingw-w64/bin:${PATH}"
        PATH="${SYSP}:${PATH}"
        PATH=$(echo ${PATH} | tr -d '\r')
    else
        PATH="${SYSP}/bin:${PATH}"
        PATH=$(echo ${PATH} | tr -d '\r')
    fi
    \export PATH
}

__conda_exe() (
    __add_sys_prefix_to_path
    $(echo "$CONDA_EXE" | tr -d '\r') $_CE_M $_CE_CONDA $(echo "$@" | tr -d '\r')
)

__conda_hashr() {
    if [ -n "${ZSH_VERSION:+x}" ]; then
        \rehash
    elif [ -n "${POSH_VERSION:+x}" ]; then
        :  # pass
    else
        \hash -r
    fi
}

__conda_activate() {
    if [ -n "${CONDA_PS1_BACKUP:+x}" ]; then
        # Handle transition from shell activated with conda <= 4.3 to a subsequent activation
        # after conda updated to >= 4.4. See issue #6173.
        PS1="$CONDA_PS1_BACKUP"
        PS1=$(echo ${PS1} | tr -d '\r')
        \unset CONDA_PS1_BACKUP
    fi
    \local ask_conda
    ask_conda="$(PS1="${PS1:-}" __conda_exe shell.posix "$@")" || \return
    ask_conda=$(echo ${ask_conda} | tr -d '\r')
    \eval "$ask_conda"
    __conda_hashr
}

__conda_reactivate() {
    \local ask_conda
    ask_conda="$(PS1="${PS1:-}" __conda_exe shell.posix reactivate)" || \return
    ask_conda=$(echo ${ask_conda} | tr -d '\r')
    \eval "$ask_conda"
    __conda_hashr
}

conda() {
    \local cmd="${1-__missing__}"
    case "$cmd" in
        activate|deactivate)
            __conda_activate $(echo "$@" | tr -d '\r')
            ;;
        install|update|upgrade|remove|uninstall)
            __conda_exe $(echo "$@" | tr -d '\r') || \return
            __conda_reactivate
            ;;
        *)
            __conda_exe $(echo "$@" | tr -d '\r')
            ;;
    esac
}

if [ -z "${CONDA_SHLVL+x}" ]; then
    \export CONDA_SHLVL=0
    # In dev-mode CONDA_EXE is python.exe and on Windows
    # it is in a different relative location to condabin.
    if [ -n "${_CE_CONDA:+x}" ] && [ -n "${WINDIR+x}" ]; then
        PATH="$(\dirname "$CONDA_EXE")/condabin${PATH:+":${PATH}"}"
    else
        PATH="$(\dirname "$(\dirname "$CONDA_EXE")")/condabin${PATH:+":${PATH}"}"
    fi
    \export PATH

    # We're not allowing PS1 to be unbound. It must at least be set.
    # However, we're not exporting it, which can cause problems when starting a second shell
    # via a first shell (i.e. starting zsh from bash).
    if [ -z "${PS1+x}" ]; then
        PS1=
    fi
fi





-------------------------------------
my zsh file 
-------------------------------------

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
alias dir='explorer.exe .'
alias code='/c/Users/Usuario/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code.cmd'

if [ -f "$HOME/conda-shell-zsh-hook.zsh" ]; then
    source "$HOME/conda-shell-zsh-hook.zsh"
fi




