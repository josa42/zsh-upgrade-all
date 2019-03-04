#!/bin/sh

upgrade-all() {

  local tasks=()
  local configDisable=("${UPGRADE_ALL_DISABLE[@]}")
  local configEnable=("${UPGRADE_ALL_ENABLE[@]}")
  local configNonParallel=$UPGRADE_ALL_NON_PARALLEL
  local dryRun=$UPGRADE_ALL_DRY_RUN

  installed() {
    if ! type "$1" > /dev/null; then
      return 1
    fi
    return 0
  }

  enabled() {
    local key="$1"
    local e

    if [[ "$configEnable" != "" ]]; then
      for e in "${configEnable[@]}"; do
        if [[ "$e" == "$key" ]]; then
          return 0
        fi
      done

      return 1
    fi

    for e in "${configDisable[@]}"; do
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
    configNonParallel=true
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

  # Dry Run: Print Commands, but do not run them
  if [[ "$dryRun" = "true" ]]; then
    for task in "${tasks[@]}"; do
      echo $task
    done

  # Non Paralell: Run commands sequancially without tmux
  elif [[ "$configNonParallel" = "true" ]]; then
    for task in "${tasks[@]}"; do
      echo $task
      /bin/sh -c $task
    done

  # Defaul: Run commnds in parallel via tmux
  else
    local session=""
    for task in "${tasks[@]}"; do
      if [[ "$session" = "" ]]; then
        session="upgrades"
        # echo run
        tmux new-session -d -s $session "echo '$task'; $task"
        tmux select-window -t upgrades:0
        # tmux setw remain-on-exit on
      else
        tmux new-window "echo '$task'; $task"
        # tmux setw remain-on-exit on
      fi
      tmux select-layout
    done

    tmux attach-session -t $session
  fi
}
