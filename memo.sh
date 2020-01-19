#!/usr/bin/env bash

YOUR_NAME="SHOTA"


listmemo() {
    for f in `find . -maxdepth 1 -type f -name "*.md"` ; do 
        if [ ! ${f} = "./README.md" ]; then
            echo "・ 📝  `sed -n 1P $f | tr -d \#`"
            echo ""
        fi
    done

    for d in `find . -maxdepth 1 -type d -name "M_*"` ; do 
        echo "・ 📂  `basename $d | tr -d "M_"`"
        echo ""
        for f in `find $d -maxdepth 1 -type f -name "*.md"` ; do 
            echo "    ・ 📝  `sed -n 1P $f | tr -d \#`"
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
        --generate-index )
            genindex
            exit 0
            ;;
    esac
done
