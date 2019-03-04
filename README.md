# Upgrade All

A simple function to upgrade various packages.

![](docs/upgrade-all-the-things.jpg)

## Installation

**antibody** (`.zshrc`)

```
antibody bundle josa42/zsh-upgrade-all
```

## Supported Package Managers

| Name              | Key        | Command                                                                             |
|:------------------|:-----------|:------------------------------------------------------------------------------------|
| Homebrew          | `brew`     | `brew upgrade && brew cleanup`                                                      |
| Homebrew Cask     | `cask`     | `for app in $(brew cask outdated); do brew cask reinstall $app; done`               |
| Docker            | `docker`   | `docker system prune --force --all`                                                 |
| npm               | `npm`      | `npm list -g --parseable --json 2>/dev/null \| jq -r ".dependencies \| keys \| .[]" \| xargs npm install -g && npm cache verify` |
| yarn              | `yarn`     | `yarn global upgrade`                                                               |
| antibody          | `antibody` | `antibody update`                                                                   |
| neovim / vim-plug | `nvim`     | `nvim +PlugUpgrade +PlugInstall +PlugClean! +qa!`                                   |

## Configuration

**Disable specific package manager**

```
export UPGRADE_ALL_DISABLE=('brew' 'docker')
```

## Dependencies

- tmux
- jq (for npm)

## License

[MIT © Josa Gesell](LICENSE)

