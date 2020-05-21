#!/bin/bash

if [ $# -lt 1 ]; then
    echo need image files list such as 2007_test.txt, bye
    exit
fi
export test_list=$1
echo "reading" $test_list

gt_dir="input/ground-truth"
im_dir="input/images-optional"
gtN=$(ls ${gt_dir}/*.txt|wc -l)
imN=$(ls ${im_dir}/*.jpg|wc -l)
echo $gtN files in $gt_dir
echo $imN files in $im_dir

if [ $gtN -gt 0 ] || [ $imN -gt 0 ]; then
    echo please clear $gt_dir and $im_dir directries, bye
    exit
fi

exit
if [ -d $gt_dir ] && [ -d $im_dir ]; then
    pushd $im_dir
    for i in $(cat ../../${test_list});do ln $i;done
    popd && pushd $gt_dir
    for i in $(cat ../../${test_list}|sed -e 's/JPEGImages/labels/' -e 's/.jpg/.txt/');do cp $i . ;done
    popd
else
    echo use setup_new.sh to make directories, bye
    exit
fi

