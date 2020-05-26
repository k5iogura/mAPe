#!/bin/bash

options="i:r:d:"
usage () {
    echo Usage: $0 $options
    echo \-i : image paths list for Dataset
    echo \-r : result files in the directory
    echo \-d : DB directory for GroundTruth
    exit
}
while getopts $options OPT;do
    case $OPT in
    i)
        if [ ! -f $OPTARG ];then
            echo "\-i image_path_list";usage
        fi
        dbname=$(basename $OPTARG)
        dbname=${dbname%.txt}
        if [ -f $OPTARG ];then      # OPTARG Images list file
            if [ ! -d $dbname ] || [ $OPTARG -nt $dbname ]; then # -nt newer_than
                ./convert_gt_yolo.sh $OPTARG
            else
                echo --- DB Directory newer than $OPTARG
            fi
        fi
        ;;
    d)
        dbname=$OPTARG
        if [ ! -d $dbname ];then
            echo not found $dbname directory;usage
        fi
        ;;
    r)
        if [ ! -d $OPTARG ];then    # OPTARG Result directory of inference
            echo not found $OPTARG file;usage
        fi
        result=$OPTARG
        ;;
    ?)  echo unknown args;usage
        ;;
    esac
done
if [ -z ${dbname+x} ] || [ -z ${result+x} ];then
    usage
fi
echo --- DB=$dbname RESULT=$result

echo --- Import $result into $dbname
./convert_comp4_det.py -db $dbname -r $result

echo --- Estimate mAP for $result
python main.py -db $dbname -i $(cat scripts/extra/voc-coco.ignore)
