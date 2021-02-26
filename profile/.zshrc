# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/var/lib/flatpak/exports/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="/home/myuser/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="bureau"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(sudo git compleat alias-finder fzf)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=pt_BR.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#

# ARCHIVE EXTRACTOR {{{
    function extract {
         if [ -z "$1" ]; then
            # display usage if no parameters given
            echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
            echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
         else
            for n in "$@"
            do
              if [ -f "$n" ] ; then
                  case "${n%,}" in
                    *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) 
                                 tar xvf "$n"       ;;
                    *.lzma)      unlzma ./"$n"      ;;
                    *.bz2)       bunzip2 ./"$n"     ;;
                    *.cbr|*.rar)       unrar x -ad ./"$n" ;;
                    *.gz)        gunzip ./"$n"      ;;
                    *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
                    *.z)         uncompress ./"$n"  ;;
                    *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                                 7z x ./"$n"        ;;
                    *.xz)        unxz ./"$n"        ;;
                    *.exe)       cabextract ./"$n"  ;;
                    *.cpio)      cpio -id < ./"$n"  ;;
                    *.cba|*.ace)      unace x ./"$n"      ;;
                    *)
                    echo "extract: '$n' - unknown archive method"
                    return 1
                    ;;
                  esac
              else
                  echo "'$n' - file does not exist"
                  return 1
              fi
            done
        fi
    }
  #}}}
  # ARCHIVE COMPRESS {{{
    compress() {
      if [[ -n "$1" ]]; then
        FILE=$1
        case $FILE in
        *.tar ) shift && tar cf $FILE $* ;;
    *.tar.bz2 ) shift && tar cjf $FILE $* ;;
     *.tar.gz ) shift && tar czf $FILE $* ;;
        *.tgz ) shift && tar czf $FILE $* ;;
        *.zip ) shift && zip $FILE $* ;;
        *.rar ) shift && rar $FILE $* ;;
        esac
      else
        echo "usage: compress <foo.tar.gz> ./foo ./bar"
      fi
    }
  #}}}
  # CONVERT TO ISO {{{
    to_iso () {
      if [[ $# == 0 || $1 == "--help" || $1 == "-h" ]]; then
        echo -e "Converts raw, bin, cue, ccd, img, mdf, nrg cd/dvd image files to ISO image file.\nUsage: to_iso file1 file2..."
      fi
      for i in $*; do
        if [[ ! -f "$i" ]]; then
          echo "'$i' is not a valid file; jumping it"
        else
          echo -n "converting $i..."
          OUT=`echo $i | cut -d '.' -f 1`
          case $i in
                *.raw ) bchunk -v $i $OUT.iso;; #raw=bin #*.cue #*.bin
          *.bin|*.cue ) bin2iso $i $OUT.iso;;
          *.ccd|*.img ) ccd2iso $i $OUT.iso;; #Clone CD images
                *.mdf ) mdf2iso $i $OUT.iso;; #Alcohol images
                *.nrg ) nrg2iso $i $OUT.iso;; #nero images
                    * ) echo "to_iso don't know de extension of '$i'";;
          esac
          if [[ $? != 0 ]]; then
            echo -e "${R}ERROR!${W}"
          else
            echo -e "${G}done!${W}"
          fi
        fi
      done
    }
  #}}}
  # REMIND ME, ITS IMPORTANT! {{{
    # usage: remindme <time> <text>
    # e.g.: remindme 10m "omg, the pizza"
    notificar-me() { sleep $1 && zenity --info --text "$2" & }
  #}}}
  #
  ## Open software
  function open () {
    xdg-open "$@">/dev/null 2>&1
  }


## Reapeat comand
  function cmdInterval() {
	while : ; do
		echo "Ctrl+c para sair!"
		sleep $2
		eval $1
	done

  }

  # SIMPLE CALCULATOR #{{{
    # usage: calc <equation>
    calc() {
      if which bc &>/dev/null; then
        echo "scale=3; $*" | bc -l
      else
        awk "BEGIN { print $* }"
      fi
    }
  #}}}
  # FILE & STRINGS RELATED FUNCTIONS {{{
    ## FIND A FILE WITH A PATTERN IN NAME {{{
      ff() { find . -type f -iname '*'$*'*' -ls ; }
      fd() { find . -type d -iname '*'$*'*' -ls ; }
    #}}}
    ## FIND A FILE WITH PATTERN $1 IN NAME AND EXECUTE $2 ON IT {{{
      fe() { find . -type f -iname '*'$1'*' -exec "${2:-file}" {} \;  ; }
    #}}}
    ## MOVE FILENAMES TO LOWERCASE {{{
      lowercase() {
        for file ; do
          filename=${file##*/}
          case "$filename" in
          */* ) dirname==${file%/*} ;;
            * ) dirname=.;;
          esac
          nf=$(echo $filename | tr A-Z a-z)
          newname="${dirname}/${nf}"
          if [[ "$nf" != "$filename" ]]; then
            mv "$file" "$newname"
            echo "lowercase: $file --> $newname"
          else
            echo "lowercase: $file not changed."
          fi
        done
      }
  #}}}
    ## SWAP 2 FILENAMES AROUND, IF THEY EXIST {{{
      #(from Uzi's bashrc).
      swap() {
        local TMPFILE=tmp.$$

        [[ $# -ne 2 ]] && echo "swap: 2 arguments needed" && return 1
        [[ ! -e $1 ]] && echo "swap: $1 does not exist" && return 1
        [[ ! -e $2 ]] && echo "swap: $2 does not exist" && return 1

        mv "$1" $TMPFILE
        mv "$2" "$1"
        mv $TMPFILE "$2"
      }
    #}}}
    ## FINDS DIRECTORY SIZES AND LISTS THEM FOR THE CURRENT DIRECTORY {{{
      dirsize () {
        du -shx * .[a-zA-Z0-9_]* 2> /dev/null | egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
        egrep '^ *[0-9.]*M' /tmp/list
        egrep '^ *[0-9.]*G' /tmp/list
        rm -rf /tmp/list
      }
    #}}}
    ## FIND AND REMOVED EMPTY DIRECTORIES {{{
      fared() {
        read -p "Delete all empty folders recursively [y/N]: " OPT
        [[ $OPT == y ]] && find . -type d -empty -exec rm -fr {} \; &> /dev/null
      }
    #}}}
    ## FIND AND REMOVED ALL DOTFILES {{{
      farad () {
        read -p "Delete all dotfiles recursively [y/N]: " OPT
        [[ $OPT == y ]] && find . -name '.*' -type f -exec rm -rf {} \;
      }
    #}}}
    ## Fie type {{{
    if which xdg-mime &>/dev/null; then
        default_app() {
            if [ $# -eq 1 ]; then
                type_file=$(xdg-mime query filetype $1);
                echo "Tipo: ${type_file}";
                default_open=$(xdg-mime query default $type_file);
                echo "Programa padrão: ${default_open}";
            elif [ $# -eq 2 ]; then
                type_file=$(xdg-mime query filetype $1) &&
                xdg-mime default $2 $type_file;
                echo "xdg-mime default $2 $type_file";
            else
                echo -e "Utilizar pelo menos um argumento! \n$ defaudefault_ap arquivo.txt gvim.desktop";
            fi
        }
    fi

    ##}}}
  #}}}
  # ENTER AND LIST DIRECTORY{{{
    function cd() { builtin cd -- "$@" && { [ "$PS1" = "" ] || ls -hrt --color; }; }
  #}}}
  #
  # SYSTEMD SUPPORT {{{
    if which systemctl &>/dev/null; then
      start() {
        sudo systemctl start $1.service
      }
      restart() {
        sudo systemctl restart $1.service
      }
      stop() {
        sudo systemctl stop $1.service
      }
      enable() {
        sudo systemctl enable $1.service
      }
      status() {
        sudo systemctl status $1.service
      }
      disable() {
        sudo systemctl disable $1.service
      }
    fi
  #}}}
#}}}
    if which anbox &>/dev/null ; then
        service_anbox() {
            sudo modprobe ashmem_linux
            sudo modprobe binder_linux

            anbox-bridge

            sudo systemctl $1 anbox-container-manager.service
            systemctl --user $1 anbox-session-manager.service 
         
        }

    fi


#}}}
  # SYSTEMD SUPPORT {{{
    if which ip &>/dev/null; then

      ipif() {
        if grep -P "(([1-9]\d{0,2})\.){3}(?2)" <<< "$1"; then
          curl ipinfo.io/"$1"
        else
          ipawk=($(host "$1" | awk '/address/ { print $NF }'))
          curl ipinfo.io/${ipawk[1]}
        fi
        echo
      }
      vlandelete() {
        sudo ip link delete _vlan
        ip a s;
      }
      vlanadd() {
        if [ $# -lt 2 ]; then
            ip a s | grep UP
            echo -e "Utilizar pelo menos dois argumento! \n$ addvlan <interface> <id> \n 10 - WAN \n 12 - WAN2 \n 1 - SRVs \n 2 - CEPH \n 200 - ADM \n 310 - LABTECA \n 320 - LAB601 \n 440 - WIFI-ADM \n 450 - ALUNOS \n 460 - VISITANTES \n 400 - WIFG \n 470 - EDUROAM \n 100 - DMZ \n 101 - GCIA \n 430 - SERVIDORES \n";
        else
          # sudo ip addr flush dev _vlan
          sudo modprobe 8021q
          sudo ip link delete _vlan
          sudo ip link add link $1 name _vlan type vlan id $2;
          sudo ip link set dev _vlan up;
          case $2 in
            10)
              sudo ip addr add 200.0.40.253/29 dev _vlan &&
              sudo ip route add default via 200.0.40.249 &&
              echo "Link brdigital configurado!";
              ;;
            12)
              sudo ip addr add 168.227.76.74/30 dev _vlan &&
              sudo ip route add default via 168.227.76.73 &&
              echo "Link Nemissis configurado!";
              ;;
            *)
              echo "dhcpcd...";
              sleep 2;
              sudo dhclient _vlan
              sudo dhcpcd _vlan
          esac
          sudo sh -c 'echo "nameserver 208.67.222.222" > /etc/resolv.conf';
          ip a s _vlan && ip r s
        fi
      }
    fi
  #}}}
#}}}

#}}}
  # SYSTEMD SUPPORT {{{
    if which mount &>/dev/null; then
        ifg_mount() {
            gio mount smb://10.11.0.12/Arquivos
            #sudo mount -t cifs -o username=1934155,noperm //10.11.0.12/Arquivos/ $1
            # sudo mount -t cifs //10.11.0.12/Arquivos /mnt/IFG -o user=1934155,comment=systemd.automount,nofail,rw,noperm
            # sudo sshfs suporte@10.11.0.3:/ /run/media/myuser/web -o follow_symlinks -odebug,sshfs_debug,loglevel=debug -p 22003
            # gio mount sftp://suporte@10.11.0.3:22003
        }
    fi
  #}}}
#}}}

#}}}
  # ANBOX {{{
    start_anbox() {
        systemctl start anbox-container-manager.service
        sudo modprobe ashmem_linux
        sudo modprobe binder_linux
    }
  #}}}
#}}}


guake_backup() {
    dconf dump /apps/guake/ > ${HOME}/.config/myconfig/backup_of_my_guake_settings
}

guake_restore() {
    dconf reset -f /apps/guake/
    dconf load /apps/guake/ < ${HOME}/.config/myconfig/backup_of_my_guake_settings
}

flatpak_theme() {
        for package in $(ls "$HOME/.var/app/"); do
                #[ -d "$HOME/.var/app/$package/config/gtk-3.0" ] 
                /usr/bin/ln -sf "$HOME/.config/gtk-2.0" "$HOME/.var/app/$package/config/" 
                /usr/bin/ln -sf "$HOME/.config/gtk-3.0" "$HOME/.var/app/$package/config/" 
                /usr/bin/ln -sf "$HOME/.config/gtk-4.0" "$HOME/.var/app/$package/config/"
        done
}

ranger() {
    if [ -z "$RANGER_LEVEL" ]; then
        /usr/bin/ranger "$@"
    else
        exit
    fi
}

alias gitlog="git log --oneline --decorate --all --graph"
alias ipa="nmcli device status && ip a s |  egrep --colour -v DOWN | egrep --colour -e '^[0-9]|[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/'"
alias iotop="iotop -o"
alias g1="ping g1.com.br"
alias x="startx"

# Comands

alias dd='dd status=progress'

if (( $EUID != 0 )); then
    alias apt='sudo apt'
    alias dd='sudo dd status=progress'
fi

# Docker
alias dc='docker'
alias dcps='docker ps -a --format="{{json .}}" | jq '
alias dcclean='docker image prune -a ; docker volume prune; '
alias dccleanall='docker system prune'

alias vpn53="cd /etc/openvpn/client/GOI-SRV-UTM1-UDP4-53-config/GOI-SRV-UTM1-UDP4-53/ && sudo openvpn GOI-SRV-UTM1-UDP4-53.ovpn"
alias vpn8080="cd /etc/openvpn/client/GOI-SRV-UTM1-UDP4-8080/ ; sudo openvpn GOI-SRV-UTM1-UDP4-8080.ovpn"
alias vpnifg="cd /etc/openvpn/client/ifg-srv-pfs-UDP4-1209/ ; sudo openvpn ifg-srv-pfs-UDP4-1201-android.ovpn"

alias cf-i3="vim ~/.config/i3/config"
alias cf-vim="vim ~/.vimrc.local"
alias cf-zsh="vim ~/.zshrc"
alias peerflix="peerflix --on-downloaded -v -f ./ -l"
#convert -density 300 2º\ TA\ -\ IFG\ -\ 02\ 2017.pdf -depth 8 -strip -background white -alpha off file.tiff
# setxkbmap -model abnt2 -layout br -variant abnt2 
# pacman -S awesome-terminal-fonts # echo "\nSmall :\uf1eb"  # https://fontawesome.com/icons
# sudo nmap -sU -p 161 --script default,snmp-sysdescr 10.11.254.0/24
#snmpwalk -v1 -c public 10.11.254.67 
#Convert pdf: pdftoppm -png Arquivo.pdf output
#docker run --rm  -i --user "$(id -u):$(id -g)" --workdir /data -v "$PWD:/data" jbarlow83/ocrmypdf -l por /data/Homem.pdf /data/Homem-OCR.pdf
#iw dev wlan0 interface add wlan1 type station
#sudo modprobe v4l2loopback
# sudo mdk3 wlan1mon d -c 1 -w ~/.mac.txt # Araque sobre canal 1 e ignora .mac.txt
#docker system prune --all --force --volumes
#sudo iw dev wlan0 interface add wlan2 type station
#sudo iftop -i wlo1
#sudo nethogs
# qemu-img convert -c -f qcow2 win7-orig.qcow2 -O qcow2 win7.qcow2
#sudo qemu-system-x86_64 --enable-kvm -cpu host -smp 8 -m 4048  -drive file=/dev/sdb,if=virtio
#sudo qemu-system-x86_64 --enable-kvm -cpu host -smp 8 -m 4048  -cdrom /home/smb/APPs/ISOs/Win10_20H2_BrazilianPortuguese_x64.iso -boot d -hdb /dev/sdb
