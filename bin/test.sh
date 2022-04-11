REMOTE_FILE=https://github.com/gtmn/dotfiles/raw/test/bin/confirm.sh
# LOCAL_FILE=~/.tmp_bootstrap/confirm.sh

# curl --insecure -L $REMOTE_FILE -o $LOCAL_FILE --create-dirs
# source $LOCAL_FILE

# source <(curl -Ls https://github.com/gtmn/dotfiles/raw/test/bin/confirm.sh)

# source /dev/stdin <<< "$(curl --insecure -Ls $REMOTE_FILE)"
cat <(curl -Ls https://github.com/gtmn/dotfiles/raw/test/bin/confirm.sh)

confirm_yes && echo Hello
