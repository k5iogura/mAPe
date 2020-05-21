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

**prepaire**  
Put some file on top of mAP.
1. test images list such as "2007_test.txt".  
`absolute paths of jpeg`  
2. results of inference as json such as "coco_results.json"  
3. name list for categories (id is not number but strings) such as "coco.names"  
`  
aeroplane  
dog  
cat  
...  
`  
4. name list for ignored categories such as "coco.ignores"  
`  
big_home  
small_home  
child  
...  
`  

**To import GoundTruth files** put test images list such as "2007_test.txt" like VOC on top directory and,  

` $ ./convert_gt_yolo.sh 2007_test.txt`  
see input/ground-truth and input/images directories.  

**To import Results of inferences as json** for each images put json file such as "coco_results.json" on top directory and,  

` $ ./convert_dr_yolo.sh coco_results.json`  
see input/results-detection-results directory.  

