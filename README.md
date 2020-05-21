# mAP (mean Average Precision)

Original README [here](https://github.com/Cartucho/mAP/blob/master/README.md)  


### Input Formats  

**Absolute Coordinate Values!** against image.  

- GroundTruth  

`<class_name> <left> <top> <right> <bottom> [<difficult>]`  

"difficult" keyword lines are ignored on estimation.  

- Results of Inference  

`<class_name> <confidence> <left> <top> <right> <bottom>`  

- names for inference  

### How to run via example input directry  

` $ python main.py`  
    or  
` $ python main.py -an  # with annimation`  

see input/ and output/ directories.  

### How to import darknet format into input directry  

**To convert GoundTruth files** put test images list such as "2007_test.txt" on top directory and,  

` $ convert_gt_yolo.sh 2007_test.txt`  
see input/ground-truth and input/images directories.  

**To convert Results of inferences for each images put json file such as "coco_results.json" on top directory and,  

` $ convert_dr_yolo.sh coco_results.json`  
see input/results-detection-results  

