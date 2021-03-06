#!/usr/bin/env bash

. ~/.setuptools/lib/storage.sh

YOUR_NAME="SHOTA"


for OPT in "$@"
do
    case $OPT in
        init )
            if [ ! -e `upstorage_dirpath somemo` ]; then
                read -p "Memo Repository: " repo
                git clone $repo `upstorage_dirpath somemo`
            fi
            exit 0
            ;;
        new )
            FNAME=MEMO-`date "+%Y%m%d_%H%M%S"`.md
            touch $FNAME
            echo "# Title" >> $FNAME
            install_file somemo $FNAME
            rm -f $FNAME
            open -a Typora `upstorage_path somemo $FNAME`
            exit 0
            ;;
        mkf )
            read -p "Folder Name: " fname
            mkdir -p `upstorage_dirpath somemo`"M_${fname}"
            touch `upstorage_dirpath somemo`"M_${fname}"/.gitkeep
            exit 0
            ;;
        up | commit )
            CRT=$(pwd)
            cd ~/.setuptools/storage/somemo/
            ./memo.sh up
            cd $CRT
            exit 0
            ;;
        ls | list )
            CRT=$(pwd)
            cd ~/.setuptools/storage/somemo/
            ./memo.sh ls
            cd $CRT
            exit 0
            ;;
        sync )
            CRT=$(pwd)
            cd ~/.setuptools/storage/somemo/
            ./memo.sh sync
            cd $CRT
            exit 0
            ;;
        open | o )
            CRT=$(pwd)
            cd ~/.setuptools/storage/somemo/
            ./memo.sh o $2
            cd $CRT
            exit 0
            ;;
        --generate-index )
            CRT=$(pwd)
            cd ~/.setuptools/storage/somemo/
            ./memo.sh genindex
            cd $CRT
            exit 0
            ;;
        v | version )
            CRT=$(pwd)
            cd ~/.setuptools/storage/somemo/
            ./memo.sh v
            cd $CRT
            exit 0
            ;;
        h | help )
            CRT=$(pwd)
            cd ~/.setuptools/storage/somemo/
            ./memo.sh h
            cd $CRT
            exit 0
            ;;
    esac
done

CRT=$(pwd)
cd ~/.setuptools/storage/somemo/
./memo.sh
cd $CRT
