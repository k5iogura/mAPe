#!/bin/bash

options="VCi:g:r:d:"
usage () {
    echo Usage: $0 $options
    echo \-i "file      :" image paths list for Dataset
    echo \-r "directory :" result files in the directory
    echo optionally
    echo \-C : COCO Category\(optionally\)
    echo \-V : VOC Category\(as default\)
    echo \-g : ground truth paths list for Dataset\(optionally\)
    echo \-d : DB directory for GroundTruth\(optionally\)
    exit
}
category="VOC"
image_list=""
dbname=""
result=""
gt_list=""
while getopts $options OPT;do
    case $OPT in
    V)
        ;;
    C)
        category="COCO"
        ;;
    i)
        image_list=$OPTARG
        if [ ! -f $image_list ];then
            echo "\-i image_path_list";usage
        fi
        dbname=$(basename $image_list)
        dbname=${dbname%.txt}
        ;;
    g)
        gt_list=$OPTARG
        if [ ! -f $gt_list ];then
            echo "\-i groundtruth_path_list";usage
        fi
        ;;
    d)
        dbname=$OPTARG
        if [ ! -d $dbname ];then
            echo not found $dbname directory;usage
        fi
        ;;
    r)
        result=$OPTARG
        if [ ! -d $result ];then    # OPTARG Result directory of inference
            echo not found $result file;usage
        fi
        ;;
    ?)  echo unknown args;usage
        ;;
    esac
done
if [ -z "${dbname}" ] || [ -z "${result}" ];then
    echo need $dbname $result
    usage
fi

if [ -f $image_list ];then      # OPTARG Images list file
    if [ ! -d $dbname ] || ([ ! -z "$image_list" ] && [ $image_list -nt $dbname ]) || ([ ! -z "$gt_list" ] && [ $gt_list -nt $dbname ]) ; then # -nt newer_than
        echo --- Creating DB ${dbname} ..
        ./convert_gt_yolo.sh $image_list $gt_list
    fi
fi

echo --- DB=$dbname RESULT=$result

echo --- Import $result into $dbname with $category category
./convert_comp4_det.py -db $dbname -r $result

echo --- Estimate mAP for $result with $category category
if [ $category -eq "COCO" ];then
    python main.py -db $dbname
else
    python main.py -db $dbname -i $(cat scripts/extra/voc-coco.ignore)
fi

echo --- Done mAP Estimation DB:$dbname Result:$result with $category category

