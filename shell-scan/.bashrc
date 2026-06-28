case $- in
*i*) ;;
*) return ;;
esac

HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth
HISTTIMEFORMAT='%F %T '
shopt -s histappend

shopt -s autocd 2>/dev/null
shopt -s cdspell 2>/dev/null
shopt -s dirspell 2>/dev/null
shopt -s globstar 2>/dev/null
shopt -s checkwinsize
shopt -s nocaseglob 2>/dev/null

export EDITOR='nvim'
export REPO_HUB="$HOME/Neoware"
export PROJECT_DIR="$HOME/Neoware"

add_path() {
    case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
    esac
}

add_path "$HOME/.local/bin"
add_path "$HOME/go/bin"
[ -d "$HOME/.dotnet/tools" ] && add_path "$HOME/.dotnet/tools"
[ -d "$HOME/.local/share/omnisharp" ] && add_path "$HOME/.local/share/omnisharp"
export MANPATH="$HOME/.local/share/man:$MANPATH"
export PATH

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

command -v gh >/dev/null 2>&1 && eval "$(gh completion -s bash)" 2>/dev/null

alias ls='eza --icons always'
alias lt='eza --icons --tree'
alias top='btop'
alias c='clear'
alias e='exit'
alias f='fuck'
alias ff='fastfetch'
alias of='onefetch'
alias fucking='sudo'
alias cdhist='zoxide query -l -s | bat'

alias nv='nvim'
alias bc="nv ~/.bashrc"
alias bs="source ~/.bashrc"

alias g++='g++ -std=c++23'
alias clang++='clang++ -std=c++23'
alias mvnfx='mvn clean javafx:run'

alias nrd="npm run dev"
alias nrb="npm run build"
alias nrs="npm run start"
alias nrt="npm run test"
alias nru="npm run update"
alias nrdp="npm run deploy"

alias cmr='./run.sh'
alias ws='whisper-stream -m ~/.models/whisper/ggml-large-v3-turbo.bin --step 1000 --length 5000 -vth 0.7 -t 8'

alias lg='lazygit'
alias rp='cd ~/Neoware'
alias nlp='cd ~/Neoware/NLP_project'
alias apps='cd ~/Neoware/00-apps'
alias webs='cd ~/Neoware/01-websites'
alias games='cd ~/Neoware/02-games'
alias plugs='cd ~/Neoware/03-editor-plugins'
alias study='cd ~/Neoware/04-coursework'
alias research='cd ~/Neoware/05-research'
alias cfg='cd ~/Neoware/06-configs'
alias exp='cd ~/Neoware/07-experiments'

alias github='xdg-open "https://github.com/NoamFav" >/dev/null 2>&1'

alias llama3='llama-cli -hf unsloth/Llama-3.3-70B-Instruct-GGUF'
alias starwars='ssh starwarstel.net'
alias idle='pipes.sh -p 10 -t 9 -r 100000 -R'

y() {
    local tmp cwd
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        echo "Navigating to: $cwd"
        cd -- "$cwd" || return
    fi
    rm -f -- "$tmp"
}

replace_text() {
    if [ $# -ne 2 ]; then
        echo "Usage: replace_text <old_string> <new_string>"
        return 1
    fi
    local old_string="$1" new_string="$2"
    local -a files
    mapfile -t files < <(grep -rl --binary-files=without-match "$old_string" .)
    if [ ${#files[@]} -eq 0 ]; then
        echo "No files found containing '$old_string'"
        return 1
    fi
    echo "Found ${#files[@]} file(s). Replacing..."
    printf '%s\n' "${files[@]}" | xargs sed -i "s/$old_string/$new_string/g"
    echo "Done"
}

repo() {
    local base="$HOME/Neoware" target
    target=$(fd -t d . "$base"/{00-apps,01-websites,02-games,03-editor-plugins,04-coursework,05-research,06-configs,07-experiments} 2>/dev/null |
        grep -v "/.git" | fzf --prompt="repo> ") || return
    cd "$target" || return
}

ptree() { tree -L "${1:-2}" -d -I ".git"; }

batcopy() {
    local -a sel files
    local f x
    mapfile -t sel < <(fzf -m --preview '[ -d {} ] && tree -L 2 {} || bat --color=always -- {}')
    [ ${#sel[@]} -eq 0 ] && return
    files=()
    for f in "${sel[@]}"; do
        if [ -d "$f" ]; then
            for x in "$f"/*.*; do [ -e "$x" ] && files+=("$x"); done
        else
            files+=("$f")
        fi
    done
    [ ${#files[@]} -eq 0 ] && return
    if command -v xclip >/dev/null 2>&1; then
        bat --color=always -- "${files[@]}" 2>/dev/null | xclip -selection clipboard
    elif command -v wl-copy >/dev/null 2>&1; then
        bat --color=always -- "${files[@]}" 2>/dev/null | wl-copy
    else
        echo "no clipboard tool (install xclip or wl-clipboard)"
    fi
}

onelist() {
    echo "Select a language theme for onefetch"
    onefetch -l | fzf \
        --prompt="Language theme: " \
        --preview 'onefetch -a "$(echo {1} | tr "[:upper:]" "[:lower:]")"' \
        --preview-window=right:70% \
        --border=rounded
}

declare -A web_aliases=(
    ["Psycho"]="https://noamfav.github.io/Psycho"
    ["Resume"]="https://noamfav.github.io/Resume"
    ["bitvoyager"]="https://noamfav.github.io/bitvoyager"
    ["NF-Software"]="https://nf-software.com"
)

_update_web_alias() {
    local project_name="${PWD##*/}"
    if [ -n "${web_aliases[$project_name]}" ]; then
        alias web="echo 'Opening ${project_name}...' && xdg-open ${web_aliases[$project_name]} >/dev/null 2>&1"
    else
        unalias web 2>/dev/null
    fi
}

_last_pwd="$PWD"
_chpwd_hook() {
    if [ "$PWD" != "$_last_pwd" ]; then
        _last_pwd="$PWD"
        if [ -d .git ]; then
            command -v onefetch >/dev/null 2>&1 && onefetch
            ls
        fi
        _update_web_alias
    fi
}

command -v thefuck >/dev/null 2>&1 && eval "$(thefuck --alias)"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"
command -v atuin >/dev/null 2>&1 && eval "$(atuin init bash)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init --cmd cd bash)"

if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
    . "/opt/anaconda3/etc/profile.d/conda.sh"
elif command -v conda >/dev/null 2>&1; then
    __conda_setup="$(conda shell.bash hook 2>/dev/null)" && eval "$__conda_setup"
    unset __conda_setup
fi

command -v register-python-argcomplete >/dev/null 2>&1 && {
    eval "$(register-python-argcomplete auto_commit 2>/dev/null)"
    eval "$(register-python-argcomplete pull_repos 2>/dev/null)"
}

if command -v oh-my-posh >/dev/null 2>&1 && [ -f ~/.config/oh-my-posh/config-theme.toml ]; then
    eval "$(oh-my-posh init bash --config ~/.config/oh-my-posh/config-theme.toml)"
else
    _prompt_git() {
        local b
        b=$(git symbolic-ref --short HEAD 2>/dev/null) || return
        printf ' (%s)' "$b"
    }
    PS1='\[\033[36m\]\w\[\033[33m\]$(_prompt_git)\[\033[0m\]\n\[\033[32m\]❯\[\033[0m\] '
fi

PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}_chpwd_hook"

[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"
[ -f "$HOME/.secrets.env" ] && source "$HOME/.secrets.env"
