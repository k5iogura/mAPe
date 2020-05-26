#!/bin/bash
if [ $# -eq 0 ];then
    target="input"
else
    target=$1
fi
if [ -e ${target} ] && [ ! -e ${target}_back ]; then
    mv ${target} ${target}_back
fi

rm -fr ${target}
mkdir -p ${target}/detection-results
mkdir -p ${target}/ground-truth
mkdir -p ${target}/images-optional

echo cleaned ${target}/ up!
ls ${target}
echo $target renewed!
