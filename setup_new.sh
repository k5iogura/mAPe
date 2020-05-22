#!/bin/bash
if [ -e input ] && [ ! -e input_back ]; then
    mv input input_back
fi

rm -fr input
mkdir -p input/detection-results
mkdir -p input/ground-truth
mkdir -p input/images-optional

ls -la input
