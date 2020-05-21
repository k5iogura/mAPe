# mAP (mean Average Precision)

Original README [here](https://github.com/Cartucho/mAP/blob/master/README.md)  
This repo. to estimate mAP of any darknet models.  
Can estimate models with nessesary categories only.
E.g. estimating COCO model with VOC categories.  

### Input Formats  

**Absolute Coordinate Values!** against image.  
**categories must be represented as Strings** not but integer numbers.  

- GroundTruth  

`<class_name> <left> <top> <right> <bottom> [<difficult>]`  

"difficult" keyword lines are ignored on estimation.  

- Results of Inference  

`<class_name> <confidence> <left> <top> <right> <bottom>`  

- name list for categories  
```
dog
cat
cow
...
```

### How to run via example input directry  

` $ python main.py`  
    or  
` $ python main.py -an  # with annimation`  

see input/ and output/ directories.  

### To estimate darknet COCO models create new input/ directory  
Rough flow of mAP estimation is,  
i.  creating input directory for COCO  
ii. run main.py.  

**Nessesary files to mAP estimation of COCO**
Put some files on the top of mAPe directory.  
1. path list of test images such as "test.txt".  
  `absolute paths of jpeg`  

2. results of inference as json such as "coco_results.json".  
  can get it by darknet detector valid command line with eval=coco keyword in coco.data file.  
  see result/ directory of darknet.  

3. name list for all categories (id is by strings not but number) of inference such as "coco.names".  
  `category_name`

4. name list for ignored categories such as "coco.ignores"  
  `category_name`

**To import GoundTruth files** put test images list such as "test.txt" like VOC on top directory and,  

` $ ./convert_gt_yolo.sh test.txt`  
see input/ground-truth and input/images directories.  

**To import Results of inferences as json** for each images put json file such as "coco_results.json" on top directory and,  

` $ ./convert_dr_yolo.sh coco_results.json`  
see input/results-detection-results directory.  

