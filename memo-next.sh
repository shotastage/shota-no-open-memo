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
            ./~setuptools/storage/memo.sh up
            exit 0
            ;;
        ls | list )
            ./~setuptools/storage/memo.sh list
            exit 0
            ;;
        --generate-index )
            ./~setuptools/storage/memo.sh genindex
            exit 0
            ;;
    esac
done
