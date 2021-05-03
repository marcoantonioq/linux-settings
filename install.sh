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

    # VsCode
    cat ./profile/.config/vscode.extensions | xargs -L 1 echo code --install-extension

    # Outhers
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    chsh -s $(which zsh)

    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
}

backup(){
    dconf dump /apps/guake/ > ./profile/.config/backup_of_my_guake_settings
    code --list-extensions > ./profile/.config/vscode.extensions
}

case $1 in
    "backup")
        backup 
        ;;

    "restory") 
        restory
        ;;
    *)
        echo "Informe ./install (backup|restory) "
        ;;
esac