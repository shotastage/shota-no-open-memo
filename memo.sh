#!/usr/bin/env bash

#. ~/.setuptools/

listmemo() {
    for f in `find . -type f -name "*.md"` ; do 
        if [ ! ${f} = "./README.md" ]; then
            sed -n 1P $f
        fi
    done
}


for OPT in "$@"
do
    case $OPT in
        new )
            FNAME=MEMO-`date "+%Y%m%d_%H%M%S"`.md
            touch $FNAME
            open -a Typora $FNAME
            exit 0
            ;;
        commit )
            git add .
            git commit -m "Update on `date "+%Y%m%d_%H%M%S"`"
            git push -u origin master
            exit 0
            ;;
        ls | list )
            listmemo
            exit 0
            ;;
    esac
done
