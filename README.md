# Upgrade All

A simple function to upgrade various packages.

![](docs/upgrade-all-the-things.jpg)

## Installation

**antibody** (`.zshrc`)

```
antibody bundle josa42/zsh-upgrade-all
```

## Supported Package Managers

| Name              | Command                                                                                          |
|:------------------|:-------------------------------------------------------------------------------------------------|
| Homebrew          | `brew upgrade && brew cleanup`                                                                   |
| Homebrew Cask     | `for app in $(brew cask outdated); do brew cask reinstall $app; done`                            |
| Docker            | `docker system prune --force --all`                                                              |
| npm               | `npm list -g --parseable --json 2>/dev/null \| jq -r ".dependencies \| keys \| .[]" \| xargs npm install -g && npm cache verify` |
| yarn              | `yarn global upgrade`                                                                            |
| anibody           | `antibody update`                                                                                |
| neovim / vim-plug | `nvim +PlugUpgrade +PlugInstall +PlugClean! +qa!`                                                |
 
## Dependencies

- tmux
- jq (for npm)

## License

[MIT © Josa Gesell](LICENSE)

