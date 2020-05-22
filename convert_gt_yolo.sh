#!/bin/bash

if [ $# -lt 1 ] || [ ! -e $1 ]; then
    echo need image files list such as 5k.txt, bye
    exit
fi
export im_list=$(realpath $1)
if [ $# -ge 2 ]; then
    if [ ! -e $2 ];then
        echo not found ${gt_list};exit
    fi
    gt_list=$(realpath $2)
fi
echo "reading" $im_list

gt_dir="input/ground-truth"
im_dir="input/images-optional"
gtN=$(ls ${gt_dir}/|wc -l)
imN=$(ls ${im_dir}/|wc -l)
echo $gtN files in $gt_dir
echo $imN files in $im_dir

if [ $gtN -gt 0 ] || [ $imN -gt 0 ]; then
    echo please clean up to empty $gt_dir and $im_dir directries, bye
    exit
fi

if [ -d $gt_dir ] && [ -d $im_dir ]; then
    # Check existance and hard link images
    pushd $im_dir
    for i in $(cat ${im_list});do
        if [ ! -e $i ];then
            echo not found image file path $i; exit
        fi
    done
    for i in $(cat ${im_list});do ln $i;done
    echo Completion ${im_dir} by ${im_list}
    popd && pushd $gt_dir
    # Check existance and copy groundtruth
    if [ $# -le 1 ];then
        # mapping default pattern
        sub1='s/JPEGImages/labels/'
        sub2='s/.jpg/.txt/'
        for i in $(cat ${im_list}|sed -e ${sub1} -e ${sub2});do
            if [ ! -e $i ];then
                echo not found GT file path $i; exit
            fi
        done
        for i in $(cat ${im_list}|sed -e ${sub1} -e ${sub2});do cp $i .;done
        echo Completion ${gt_dir} by ${im_list}
    else
        for i in $(cat ${gt_list});do
            if [ ! -e $i ];then
                echo not found GT file path $i; exit
            fi
        done
        for i in $(cat ${gt_list});do cp $i . ;done
        echo Completion ${gt_dir} by ${gt_list}
    fi
    popd
else
    echo use setup_new.sh to make directories, bye
    exit
fi

echo convertion category number to name strings
python scripts/extra/convert_gt_yolo.py
