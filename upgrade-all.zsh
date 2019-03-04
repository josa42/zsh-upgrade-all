#!/bin/sh

upgrade-all() {

  local tasks=()

  installed() {
    if ! type "$1" > /dev/null; then
      return 1
    fi
    return 0
  }

  enabled() {
    local key="$1"
    local e

    for e in "${UPGRADE_ALL_DISABLE[@]}"; do
      if [[ "$e" == "$key" ]]; then
        return 1
      fi
    done

    return 0
  }

  shouldRun() {
    local key="${1}"
    local bin="${2:-$key}"

    if installed $bin && enabled $key; then
      return 0
    fi

    return 1
  }

  if ! installed 'tmux'; then
    echo "tmux is required!"
    exit 1
  fi

  if shouldRun 'brew'; then
    tasks+=(
      'brew upgrade && brew cleanup'
    )
  fi

 if shouldRun 'brew' 'cask'; then
    tasks+=(
      'for app in $(brew cask outdated); do brew cask reinstall $app; done'
    )
  fi

  if shouldRun 'docker'; then
    tasks+=(
      'docker system prune --force --all'
    )
  fi

  if shouldRun 'softwareupdate'; then
    tasks+=(
      'softwareupdate -i -a'
    )
  fi

  if shouldRun 'npm' && installed 'jq'; then
    tasks+=(
      'npm list -g --parseable --json 2>/dev/null | jq -r ".dependencies | keys | .[]" | xargs npm install -g && npm cache verify'
    )
  fi

  if shouldRun 'yarn'; then
    tasks+=(
      'yarn global upgrade'
    )
  fi

  if shouldRun 'antibody'; then
    tasks+=(
      'antibody update'
    )
  fi

  if shouldRun 'nvim'; then
    tasks+=(
      'nvim +PlugUpgrade +PlugInstall +PlugClean! +qa!'
    )
  fi

  local session=""
  for task in "${tasks[@]}"; do
    if [[ "$session" = "" ]]; then
      session="upgrades"
      # echo run
      tmux new-session -d -s $session "echo '$task'; time $task"
      tmux select-window -t upgrades:0
      # tmux setw remain-on-exit on
    else
      tmux new-window "echo '$task'; $task"
      # tmux setw remain-on-exit on
    fi
    tmux select-layout
  done

  tmux attach-session -t $session
}
