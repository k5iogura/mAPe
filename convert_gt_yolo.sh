#!/bin/bash
pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}
# image files path list
if [ $# -lt 1 ] || [ ! -e $1 ]; then
    echo Error!: need image files list such as 5k.txt, bye;exit
elif [ $# -le 2 ]; then
    im_list=$(realpath $1)
fi

# select GT directory
DSTYPE=0
grep -i VOC $im_list > /dev/null
if [ $? -eq 0 ];then
    echo VOC Dataset may be.
    sub1='s/JPEGImages/labels/'
    cp scripts/extra/voc.names  scripts/extra/class_list.txt
    DSTYPE=$(($DSTYPE+1))
fi
grep -i COCO $im_list > /dev/null
if [ $? -eq 0 ];then
    echo COCO Dataset may be.
    sub1='s/images/labels/'
    cp scripts/extra/coco.names scripts/extra/class_list.txt
    DSTYPE=$(($DSTYPE+1))
fi

#cleanup
target="${im_list%.*}"
./setup_new.sh ${target}

# ground-truth files path list
sub2='s/.jpg/.txt/'
if [ $# -le 1 ]; then
    # mapping default pattern and checking
    gt_list=$(realpath $(echo $(dirname ${im_list})/gt_$(basename ${im_list})))
    echo checking $im_list ...
    echo > $gt_list
    for i in $(cat ${im_list}|sed -e ${sub1} -e ${sub2});do
        if [ ! -e $i ];then
            echo Error!: not found GT file path $i
            continue
        fi
        echo $i >> $gt_list
    done
    echo generating $gt_list ...
    echo done.
elif [ ! -e $2 ]; then
    echo Error!: not found $2;exit
else
    gt_list=$(realpath $2)
fi
echo checking ground-truths ...
for i in $(cat ${gt_list});do
    if [ ! -e $i ];then
        echo Error!: not found GT file path $i; exit
    fi
done

# make input/ directory
gt_dir="${target}/ground-truth"
im_dir="${target}/images-optional"
gtN=$(ls ${gt_dir}/|wc -l)
imN=$(ls ${im_dir}/|wc -l)
echo $gtN files in $gt_dir
echo $imN files in $im_dir
if [ $gtN -gt 0 ] || [ $imN -gt 0 ]; then
    echo Error!: please clean up to empty $gt_dir and $im_dir directries, bye; exit
fi

# import files into input/some directory
if [ -d $gt_dir ] && [ -d $im_dir ]; then
    # Check existance and hard link images
    pushd $im_dir
    echo ln images ...
    for i in $(cat ${im_list});do ln -s $i;done
    echo Completion ${im_dir} by ${im_list}
    popd && pushd $gt_dir
    # copy groundtruth
    echo copying ground-truths ...
    for i in $(cat ${gt_list});do cp $i . ;done
    echo Completion ${gt_dir} by ${gt_list}
    popd
else
    echo Error!: use setup_new.sh to make directories, bye
    exit
fi

echo check categories in GroundTruth and names list ...
class_list='scripts/extra/class_list.txt'
egrep '(. .)' $class_list
if [ $? -eq 0 ];then
    echo Error!: class name must consists of 1 word, please check $class_list, bye ; exit
fi
gt_classesN=$(awk '{print $1;}' ${gt_dir}/*.txt | sort -u | wc -l)
nm_classesN=$(cat ${class_list} | wc -l)
echo "${gt_classesN} classes in GroundTruth files and ${nm_classesN} classes in name list in ${class_list}"
if [ $gt_classesN -gt $nm_classesN ]; then
    echo "Error!: must be classes in GroundTruth files <= classes in name list, please check, bye";exit
fi

echo convertion category number to name strings
python scripts/extra/convert_gt_yolo.py -id ${target}

echo Searching Ground-Truth category names in ${gt_dir} ...
classes=$(cat ${gt_dir}/*.txt | awk '{print $1;}' | sort -u)
for i in ${classes};do echo $i ;done | column -c 80
classN=$(for i in ${classes};do echo $i ;done | wc -l)
echo ${classN} classes in GroundTruth files...

if [ -e ${class_list} ];then
    import_classN=$(cat ${class_list}|wc -l)
    echo ${import_classN} classes in ${class_list}
    if [ $classN -ne $import_classN ];then
        echo Waring: mismatch classes gt and name list... please check!
    fi
fi

