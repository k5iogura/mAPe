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

see input/ and output/ directries.  
