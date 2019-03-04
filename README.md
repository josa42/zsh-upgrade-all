# Upgrade All

A simple function to upgrade various packages.

![](docs/upgrade-all-the-things.jpg)

## Installation

**antibody** (`.zshrc`)

```
antibody bundle josa42/zsh-upgrade-all
```

## Supported Package Managers

| Name              | Key              | Command                                                                       |
|:------------------|:-----------------|:------------------------------------------------------------------------------|
| Homebrew          | `brew`           | `brew upgrade && brew cleanup`                                                |
| Homebrew Cask     | `cask`           | `for app in $(brew cask outdated); do brew cask reinstall $app; done`         |
| Docker            | `docker`         | `docker system prune --force --all`                                           |
| macOS Updates     | `softwareupdate` | `softwareupdate -i -a`                                                        |
| npm               | `npm`            | `npm list -g --parseable --json 2>/dev/null \| jq -r ".dependencies \| keys \| .[]" \| xargs npm install -g && npm cache verify` |
| yarn              | `yarn`           | `yarn global upgrade`                                                         |
| antibody          | `antibody`       | `antibody update`                                                             |
| neovim / vim-plug | `nvim`           | `nvim +PlugUpgrade +PlugInstall +PlugClean! +qa!`                             |

## Configuration



**`UPGRADE_ALL_DISABLE` Disable specific package managers**

```
export UPGRADE_ALL_DISABLE=('softwareupdate' 'nvim')
```

**`UPGRADE_ALL_ENABLE` Enable only specific package managers**

```
export UPGRADE_ALL_ENABLE=('brew' 'cask')
```

**`UPGRADE_ALL_NON_PARALLEL` Run commands sequancially without tmux**

```
export UPGRADE_ALL_NON_PARALLEL=true
```

**`UPGRADE_ALL_DRY_RUN` Print Commands, but do not run them**

```
export UPGRADE_ALL_DRY_RUN=true
```

## Dependencies

- tmux
- jq (for npm)

## License

[MIT © Josa Gesell](LICENSE)

