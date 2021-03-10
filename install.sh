#!/bin/bash


restory(){
    # config permissions
    find . -type d -exec chmod 0755 {} \; &>/dev/null
    find . -type f -exec chmod 0644 {} \; &>/dev/null
    find . -type f -exec grep -IHle '^#!.*bin' {} \; -exec chmod 0777 {} \; &>/dev/null


    rsync -r -p -v --progress -b -i -s ./profile/ ${HOME}/
    rsync -r -p -v --progress -b -i -s ./root/ /

    # After install
    fc-cache -f -v

    # Guake
    dconf reset -f /apps/guake/
    dconf load /apps/guake/ < ./profile/.config/backup_of_my_guake_settings

    # Outhers
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    chsh -s $(which zsh)
}

backup(){
    dconf dump /apps/guake/ > ./profile/.config/backup_of_my_guake_settings

}

case $1 in
    "backup")
        backup 
        ;;

    *) restory
        ;;
esac