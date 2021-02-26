#!/bin/bash

# config permissions
find . -type d -exec chmod 0755 {} \; &>/dev/null
find . -type f -exec chmod 0644 {} \; &>/dev/null
find . -type f -exec grep -IHle '^#!.*bin' {} \; -exec chmod 0777 {} \; &>/dev/null


rsync -r -p -v --progress -b -i -s ./profile/ ${HOME}/
rsync -r -p -v --progress -b -i -s ./root/ /

# After install
fc-cache -f -v