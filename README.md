# mAP (mean Average Precision)

Original README [here](https://github.com/Cartucho/mAP/blob/master/README.md)  
This repo. to estimate mAP of any darknet models.  
Can estimate models with nessesary categories only.
E.g. estimating COCO model with VOC categories.  

### Input Formats  

**Absolute Coordinate Values!** against image.  
**categories must be represented as Strings** not but integer numbers.  

- GroundTruth `FmtGT`  

`<class_name> <left> <top> <right> <bottom> [<difficult>]`  

"difficult" keyword lines are ignored on estimation.  

- Results of Inference `FmtDR`  

`<class_name> <confidence> <left> <top> <right> <bottom>`  

- name list for categories `FmtNM`  
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
i.   prepare some list files for Images, GroundTruth, Inference results and category names  
ii.  import them into mAPe/input/ directory  
iii. run main.py  

**Nessesary files to mAP estimation of COCO**  
Put some files on the top of mAPe directory.  
1. absolute path list of images used to infer.  
   `absolute path list of jpeg files` such as '5k.txt'  

2. absolute path list of GroundTruth files written as `FmtGT`  
   `absolute path list of text files` such as 'gt.txt'  

3. absolute path list of inference result files for each images written as `FmtDR`  
   `absolute path list of text files` sudch as 'dr.txt'  

4. name list for all categories (id is by strings not but number) of inference as `FmtNM`  
    such as 'coco.names'  

5. name list for ignored categories as `FmtNM` optionally  
    such as 'coco.ignores'  

2. results of inference as json such as "coco_results.json".  
  can get it by darknet detector valid command line with eval=coco keyword in coco.data file.  
  see result/ directory of darknet.  

**To import required files**  

` $ ./convert_gt_yolo.sh 5k.txt`  
  see input/ground-truth and input/images directories.  

**To import Results of inferences as json** for each images put json file such as "coco_results.json" on top directory and,  

` $ ./convert_dr_yolo.sh coco_results.json`  
  see input/results-detection-results directory.  

