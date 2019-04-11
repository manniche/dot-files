#!/bin/bash

if [ $# -ne 1 ]; then
        echo "Usage: $0 <submodule full name>"
        exit 1
fi

MODULE_NAME=$1
MODULE_NAME_FOR_SED=$(echo $MODULE_NAME | sed -e 's/\//\\\//g')

cat .gitmodules | sed -ne "/^\[submodule \"$MODULE_NAME_FOR_SED\"/,/^\[submodule/!p" > .gitmodules.tmp
mv .gitmodules.tmp .gitmodules
git add .gitmodules
cat .git/config | sed -ne "/^\[submodule \"$MODULE_NAME_FOR_SED\"/,/^\[submodule/!p" > .git/config.tmp
mv .git/config.tmp .git/config
git rm --cached $MODULE_NAME
rm -rf .git/modules/$MODULE_NAME
rm -rf $MODULE_NAME
