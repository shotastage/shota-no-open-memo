#!/usr/bin/env bash

YOUR_NAME="SHOTA"


mcode() {
    echo "Opening MCODE: ${1}..."

    D_NAME=0
    F_NAME=0
    for f in `find . -maxdepth 1 -type f -name "*.md"` ; do
        if [ ! ${f} = "./README.md" ]; then
            F_NAME=$(($F_NAME+1))            
            if [ "F${F_NAME}" = $1 ]; then
                open -a Typora.app $f
            fi
        fi
    done

    for d in `find . -maxdepth 1 -type d -name "M_*"` ; do
        F_NAME=0
        D_NAME=$(($D_NAME+1))
        for f in `find $d -maxdepth 1 -type f -name "*.md"` ; do
            F_NAME=$(($F_NAME+1))
            if [ "D${D_NAME}F${F_NAME}" = $1 ]; then
                open -a Typora.app $f
            fi
        done
    done
}

listmemo() {
    D_NAME=0
    F_NAME=0
    for f in `find . -maxdepth 1 -type f -name "*.md"` ; do
        if [ ! ${f} = "./README.md" ]; then
            F_NAME=$(($F_NAME+1))
            echo "・ 📝  [F${F_NAME}] `sed -n 1P $f | tr -d \#`"
            echo ""
        fi
    done

    for d in `find . -maxdepth 1 -type d -name "M_*"` ; do
        F_NAME=0
        D_NAME=$(($D_NAME+1))
        echo "・ 📂  `basename $d | tr -d "M_"`"
        echo ""
        for f in `find $d -maxdepth 1 -type f -name "*.md"` ; do
            F_NAME=$(($F_NAME+1))
            echo "    ・ 📝   [D${D_NAME}F${F_NAME}] `sed -n 1P $f | tr -d \#`"
            echo ""
        done
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

    for f in `find . -maxdepth 1 -type f -name "*.md"` ; do 
        if [ ! ${f} = "./README.md" ]; then
            echo "- [📝  `sed -n 1P $f | tr -d \#`](${f})" >> README.md
            echo "" >> README.md
        fi
    done

    for d in `find . -maxdepth 1 -type d -name "M_*"` ; do 
        echo "- [📂  `basename $d | tr -d "M_"`](${d})" >> README.md
        for f in `find $d -maxdepth 1 -type f -name "*.md"` ; do 
            echo "  - [📝  `sed -n 1P $f | tr -d \#`](${f})" >> README.md
            echo "" >> README.md
        done
    done
}


preprosessor() {
    # COMMANDS=`'${0}' | tr ',' '\n'`
    echo ""
}

for OPT in "$@"
do
    case $OPT in
        new )
            FNAME=MEMO-`date "+%Y%m%d_%H%M%S"`.md
            touch $FNAME
            echo "# Title" >> $FNAME
            open -a Typora $FNAME
            exit 0
            ;;
        mkf )
            read -p "Folder Name: " fname
            mkdir "M_${fname}"
            touch ./M_${fname}/.gitkeep
            exit 0
            ;;
        up | commit )
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
        o | open )
            mcode $2
            exit 0
            ;;
        sync )
            git pull origin master
            git push -u origin master
            exit 0
            ;;
        --generate-index )
            genindex
            exit 0
            ;;
    esac
done
