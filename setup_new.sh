#!/bin/bash
if [ -e input ] && [ ! -e input_back ]; then
    mv input input_back
fi

mkdir -p input/detection-results
mkdir -p input/ground-truth
mkdir -p input/images-optional
if [ ! -e input/images ]; then
    ln -s input/images-optional input/images
fi

ls -la input
