#!/usr/bin/env bash

# DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# SOURCE=${BASH_SOURCE[0]}
# while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
#   TARGET=$(readlink "$SOURCE")
#   if [[ $TARGET == /* ]]; then
#     echo "SOURCE '$SOURCE' is an absolute symlink to '$TARGET'"
#     SOURCE=$TARGET
#   else
#     DIR=$( dirname "$SOURCE" )
#     echo "SOURCE '$SOURCE' is a relative symlink to '$TARGET' (relative to '$DIR')"
#     SOURCE=$DIR/$TARGET # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
#   fi
# done
# echo "SOURCE is '$SOURCE'"
# RDIR=$( dirname "$SOURCE" )
# DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
# if [ "$DIR" != "$RDIR" ]; then
#   echo "DIR '$RDIR' resolves to '$DIR'"
# fi
#
# echo $DIR

PATH=$1
B_SOURCE=$2

[[ $PATH != $B_SOURCE ]] && SCRDR=$PATH || SCRDR=${B_SOURCE[0]}
SCRIPT_DIR=$( cd -- "$( dirname -- "$SCRDR" )" &> /dev/null && pwd )

echo $SCRIPT_DIR
