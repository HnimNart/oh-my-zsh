# Updates editor information when the keymap changes.
function zle-keymap-select() {
  # update keymap variable for the prompt
  VI_KEYMAP=$KEYMAP
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then

    echo -ne '\e[2 q'

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[1 q'
  fi

  zle reset-prompt
  zle -R
}

zle-line-init() { zle -K viins; }

zle -N zle-keymap-select
zle -N edit-command-line
zle -N zle-line-init

export KEYTIMEOUT=1

bindkey -v

# allow v to edit the command line (standard behaviour)
autoload -Uz edit-command-line

bindkey -M vicmd 'V' edit-command-line

# allow ctrl-p, ctrl-n for navigate history (standard behaviour)
bindkey '^P' up-history
bindkey '^N' down-history

# allow ctrl-h, ctrl-w, ctrl-? for char and word deletion (standard behaviour)
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word

# allow ctrl-r and ctrl-s to search the history
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward

# allow ctrl-a and ctrl-e to move to beginning/end of line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# if mode indicator wasn't setup by theme, define default
if [[ "$MODE_INDICATOR" == "" ]]; then
  MODE_INDICATOR="%{$fg_bold[white]%}%{$fg[white]%}[Normal]%{$reset_color%}"
fi

function vi_mode_prompt_info() {
#  echo "${${VI_KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
  echo "${${KEYMAP/vicmd/[% NORMAL]%}/(main|viins)/[% INSERT]%}"
}

# define right prompt, if it wasn't defined by a theme
if [[ "$RPS1" == "" && "$RPROMPT" == "" ]]; then
  RPS1='$(vi_mode_prompt_info)'
  RPS2=$RPS1
fi

