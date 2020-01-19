#!/usr/bin/env bash

YOUR_NAME="SHOTA"


listmemo() {
    for f in `find . -type f -name "*.md"` ; do 
        if [ ! ${f} = "./README.md" ]; then
            sed -n 1P $f
        fi
    done
}

genindex() {
    rm -f README.md
    echo "# ${YOUR_NAME}のOpenメモ" >> README.md
    echo "" >> README.md
    echo "${YOUR_NAME}の公開メモ帳です" >> README.md
    echo "" >> README.md
    echo "# INDEX" >> README.md
    echo "" >> README.md

    for f in `find . -type f -name "*.md"` ; do 
        if [ ! ${f} = "./README.md" ]; then
            echo "- [`sed -n 1P $f | tr -d \#`](${f})" >> README.md
            echo "" >> README.md
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
            genindex
            git add .
            git commit -m "Update on `date "+%Y%m%d_%H%M%S"`"
            git push -u origin master
            exit 0
            ;;
        ls | list )
            listmemo
            exit 0
            ;;
        genindex )
            genindex
            exit 0
            ;;
    esac
done
