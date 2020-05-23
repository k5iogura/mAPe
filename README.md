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

### About Rough Plan : How to estimate mAP of darknet models trained with Any Dataset  
Rough plan of mAP estimation is,  
* i.   prepare some list files for COCO or VOC below,  
    test images and GroundTruth paths list (Test image),  
    GroundTruth labels (Label to GT convert),  
    Inference labels (Label to DR convert) and results  
* ii.  import them into mAPe/input/ directory by some scripts  
* iii. run main.py to get mAP estimation  
* iV.  run main.py with ignored_list.txt optionally  

**Preparations for various estimation cases**.  

|Case |Model|Test Iamge|Label to GT convert|Label to DR convert|Target                                   |
|:-:  |:-   |:-        |:-                 |:-                 |:-                                       |
|#1   |COCO |COCO      |COCO               |COCO               |estimate COCO Model with COCO Categories |
|#2   |VOC  |VOC       |VOC                |VOC                |estimate VOC  Model with VOC  Categories |
|#3   |COCO |VOC       |COCO               |COCO               |estimate COCO Model with VOC  Categories |
|#4   |VOC  |COCO      |COCO               |VOC                |estimate VOC  Model with COCO Categories |

### (#1) Estimation COCO Model with COCO Categories  

***Nessesary files to mAP estimation of COCO***  

Put some files on the top of mAPe directory.  
1. absolute path list of images used to infer.  
   `absolute path list of jpeg files` such as '5k.txt'  

<details>
<summary>"5k.txt" file example</summary>
<p>

```
    /somewhere1/DATASET/coco/images/val2014/COCO_val2014_000000000164.jpg
    /somewhere2/DATASET/coco/images/val2014/COCO_val2014_000000000192.jpg
    /somewhere3/DATASET/coco/images/val2014/COCO_val2014_000000000283.jpg
...
```

</p>
</details>

2. absolute path list of GroundTruth files for each images written as `FmtGT`  
   `absolute path list of text files` such as 'gt.txt'  
<details>
<summary>"gt.txt" file example</summary>
<p>

```
    /anywhere2/labels/COCO_val2014_000000000164.txt
    /anywhere3/labels/COCO_val2014_000000000192.txt
    /anywhere4/labels/COCO_val2014_000000000283.txt
...
```

</p>
</details>

    image file path and GroundTruth file path must have a same basename to map  

3. name list for all categories (id is by strings not but number) of inference as `FmtNM`  
    such as 'coco.names'  
    Notice: reject or substitute space charactor in category name to underscore '_'.  

4. directory including inference result files for each classes written as `FmtDR`  

    **How to get result files of inference on darknet as results/comp4_det_test_ files**  
    By command below,  
    `$ ./darknet detector valid coco.data model.cfg model.weights`  
    option line with eval=default keyword in data file.  
    After command run see result/ directory of darknet.  

<details>
<summary>"coco.data" file example</summary>
<p>

```
    classes= 80
    train  = train.txt
    valid  = 5k.txt
    names  = data/coco.names
    backup = backup
    eval   = default
```

</p>
</details>

<details>
<summary>generated results/ directory example</summary>
<p>

```
    comp4_det_test_aeroplane.txt       comp4_det_test_bowl.txt         comp4_det_test_donut.txt
    comp4_det_test_apple.txt           comp4_det_test_broccoli.txt     comp4_det_test_elephant.txt
...
```

</p>
</details>

5. name list for ignored categories as `FmtNM` optionally  
    such as 'coco.ignores'  

***Setup nessesary files into mAPe/input/ directory***  

- Copy coco name list file of inference to scripts/extra/class_list.txt  
    E.g.  
    ` $ cp scripts/extra/coco.names scripts/extra/class_list.txt`  

- Import images and GroundTruth files into input/ directory.  
    ` $ ./convert_gt_yolo.sh 5k.txt gt.txt`  
      see input/ground-truth and input/images directories.  

- Import inference result files into input/detection-results/ directory.  
    ` $ ./convert_comp4_det.py -r darknet/results`
      see input/detection-results directory.  

***Get mAP estimation***  
- **Overall**  
    Copy name list for estimation to scripts/exatra/class_list.txt  
    ` $ python ./scripts/extra/intersect-gt-and-dr.py`  
    ` $ python main.py`  
- **Hint:**  
    Category names used during estimation are collected infrom all GroundTruth files.  
    Categories included in result of inference files only will be ignored.  

- **Ignore unnessesary categories**  
    Using file as voc-coco.ignore including ignored categories,  
    ` $ python main.py -i $(cat scripts/extra/voc-coco.ignore)`  
    So that this shows _mAP of inference with COCO images and estimation with VOC categories_.  

### (#2) Estimation VOC Model with VOC Categories  

- Inferences for VOC images with VOC model and get results/ directory  
    ` $ ./darknet detector valid voc.data model.cfg model.weights`  

<details>
<summary>"voc.data" file example</summary>
<p>

```
    classes= 20
    train  = train.txt
    valid  = 2007_test100.txt
    names  = data/voc.names
    backup = backup
    eval   = default
```

</p>
</details>

<details>
<summary>generated results/ directory example</summary>
<p>

```
    comp4_det_test_aeroplane.txt  comp4_det_test_boat.txt    comp4_det_test_car.txt
    comp4_det_test_cow.txt comp4_det_test_bicycle.txt    comp4_det_test_bottle.txt
...
```

</p>
</details>

- cleanup input/ directory  
    ` $ ./setup_new.sh`  

- Copy voc name list file of inference to scripts/extra/class_list.txt  
    ` $ cp scripts/extra/voc.names scripts/extra/class_list.txt`  

- Import images and GroundTruth files into input/ directory.  
    ` $ ./convert_gt_yolo.sh 5k.txt gt.txt`  
- setup result files into mAPe/input/ directory via convert_comp4_det.py  
- get mAP estimation via main.py  
    ` $ python ./scripts/extra/intersect-gt-and-dr.py`  
    ` $ python main.py`

### (#3) Estimation COCO Model with VOC Categories  

- Inferences VOC images with COCO model and get results/ directory  
    ` $ ./darknet detector valid voc-coco.data model.cfg model.weights`  

<details>
<summary>"voc-coco.data" file example</summary>
<p>

```
    classes= 80
    train  = train.txt
    valid  = 2007_test100.txt
    names  = data/coco.names
    backup = backup
    eval   = default
```

</p>
</details>

<details>
<summary>generated results/ directory example</summary>
<p>

```
    comp4_det_test_aeroplane.txt       comp4_det_test_bowl.txt         comp4_det_test_donut.txt
    comp4_det_test_apple.txt           comp4_det_test_broccoli.txt     comp4_det_test_elephant.txt
...
```

</p>
</details>

- Import images and GroundTruth files into input/ directory.  
    ` $ ./convert_gt_yolo.sh 5k.txt gt.txt`  
- setup result files into mAPe/input/ directory via convert_comp4_det.py  
- get mAP estimation via main.py  
    ` $ python ./scripts/extra/intersect-gt-and-dr.py`  
    ` $ python main.py`

### (#4) Estimation VOC Model with COCO Categories  

- Inferences COCO images with VOC model and get results/ directory  
    ` $ ./darknet detector valid coco-voc.data model.cfg model.weights`  

<details>
<summary>"coco-voc.data" file example</summary>
<p>

```
    classes= 20
    train  = train.txt
    valid  = 5k.txt
    names  = data/voc.names
    backup = backup
    eval   = default
```

</p>
</details>

<details>
<summary>generated results/ directory example</summary>
<p>

```
    comp4_det_test_aeroplane.txt  comp4_det_test_boat.txt    comp4_det_test_car.txt
    comp4_det_test_cow.txt comp4_det_test_bicycle.txt    comp4_det_test_bottle.txt
...
```

</p>
</details>

- cleanup input/ directory  
    ` $ ./setup_new.sh`  

- Copy coco name list file of inference to scripts/extra/class_list.txt  
    ` $ cp scripts/extra/coco.names scripts/extra/class_list.txt`  

- Import images and GroundTruth files into input/ directory.  
    ` $ ./convert_gt_yolo.sh 5k.txt gt.txt`  
- setup result files into mAPe/input/ directory via convert_comp4_det.py  
- get mAP estimation via main.py  
    `$ python main.py -i $(cat scripts/extra/voc-coco.ignore)`  


