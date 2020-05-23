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

### How to estimate mAP of darknet COCO models  
Rough flow of mAP estimation is,  
* i.   prepare some list files for COCO or VOC below,  
    test images and GroundTruth paths list (Test image),  
    GroundTruth labels (Label to GT convert),  
    Inference labels (Label to DR convert) and results  
* ii.  import them into mAPe/input/ directory by some scripts  
* iii. run main.py to get mAP estimation  
* iV.  run main.py with ignored_list.txt optionally  

**Preparations for various estimation cases**.  

|Case |Model|Test Iamge|Label to GT convert|Label to DR convert|Target                                     |
|:-:  |:-   |:-        |:-                 |:-                 |:-                                         |
|#1   |COCO |COCO      |COCO               |COCO               |COCO Model with COCO Categories estimation |
|#2   |VOC  |VOC       |VOC                |VOC                |VOC  Model with VOC  Categories estimation |
|#3   |COCO |VOC       |COCO               |COCO               |COCO Model with VOC  Categories estimation |
|#4   |VOC  |COCO      |COCO               |VOC                |VOC  Model with COCO Categories estimation |

***Nessesary files to mAP estimation of COCO***  
Put some files on the top of mAPe directory.  
1. absolute path list of images used to infer.  
   `absolute path list of jpeg files` such as '5k.txt'  

2. absolute path list of GroundTruth files for each images written as `FmtGT`  
   `absolute path list of text files` such as 'gt.txt'  

**image file path and GroundTruth file path must have a same basename to map**  
E.g.  
/somewhere/images/val2014/COCO_val2014_000000000164.jpg  
/somewhere/GT/000000000164/COCO_val2014_000000000164.txt  
Its can be mapped.  

3. absolute path list of inference result files for each images written as `FmtDR`  
   `absolute path list of text files` sudch as 'dr.txt'  

4. name list for all categories (id is by strings not but number) of inference as `FmtNM`  
    such as 'coco.names'  

5. name list for ignored categories as `FmtNM` optionally  
    such as 'coco.ignores'  

***Setup nessesary files into mAPe/input/ directory***  

Copy coco name list file of inference to scripts/extra/class_list.txt  
E.g.  
` $ cp coco.names scripys/extra/class_list.txt`  

Import image and GroundTruth files into input/ directory.  
` $ ./convert_gt_yolo.sh 5k.txt gt.txt`  
  see input/ground-truth and input/images directories.  

Import inference result files into input/detection-results/ directory.  
` $ ./convert_dr_yolo.sh dr.txt`  
  see input/detection-results directory.  

**Convert json file to `FmtDR` if need**  
If result of inference is as json format convert it,  
results of inference as json such as "coco_results.json".  
can get it by darknet detector valid command line with eval=coco keyword in coco.data file.  
see result/ directory of darknet.  

` $ ./json2dr.py coco_results.json`  

***Get mAP estimation***  
**Overall**  
Copy name list for estimation to scripts/exatra/class_list.txt  
` $ python main.py`  
**Hint:**  
Category names used during estimation are collected infrom all GroundTruth files.  
Categories included in result of inference files only will be ignored.  

**Ignore unnessesary categories**  
Using file as voc-coco.ignore including ignored categories,  
` $ python main.py -i $(cat scripts/extra/voc-coco.ignore)`  
So that this shows _mAP of inference with COCO images and estimation with VOC categories_.  

