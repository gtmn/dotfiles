# My dotfiles

## Bootstrap new machine
---

Start bootstrapping a Mac along the following selectable steps:

1. Set up new SSH key pair and config
    1. Generate new SSH key pair
    1. Add to SSH config
    1. Copy public key to clipboard => manually add key to respective provider
    1. Test connection
1. Clone this repository to the machine
1. Setup the machine's preferences along the settings and dotfiles in this repository

```
bash <(curl -Ls https://github.com/gtmn/dotfiles/raw/master/bin/bootstrap.sh)
```
