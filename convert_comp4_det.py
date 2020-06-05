#!/usr/bin/env python
import sys,os,re,argparse
from glob import glob
from shutil import rmtree

def check(path):
    if os.path.exists(path):return str(path)
    return None
parser = argparse.ArgumentParser()
parser.add_argument('-db', '--input_dir',        type=check, nargs=1, required=True)
parser.add_argument('-s', '--detection_results', type=str, default="detection-results")
parser.add_argument('-g', '--ground_truth',      type=str, default="ground-truth")
parser.add_argument('-r', '--comp4_dir',         type=check, required=True)
args = parser.parse_args()

c4_dir=args.comp4_dir
dr_dir=os.path.join(args.input_dir[0], args.detection_results)
gt_dir=os.path.join(args.input_dir[0], args.ground_truth)

# cleanup after checking
c4_files = glob(c4_dir+"/*")
if len(c4_files)==0:
    print("Error: not found any files in %s"%c4_dir)
    sys.exit(-1)

for f in glob(dr_dir+'/*'):
    if os.path.isdir(f):
        rmtree(f)
    else:
        os.remove(f)

# loading result files
dn_id={}
c4_classes=[]
print(c4_files)
for f in c4_files:
    if not 'comp4_det_test_' in f:
        print("Warning: Can not process file without comp4_det_test_*.txt type, skip"+f)
        continue
    class_name = re.sub('comp4_det_test_','',os.path.splitext(os.path.basename(f))[0])
    class_name = re.sub(' ','_',class_name)
    #print(f,class_name)
    c4_classes.append(class_name)
    with open(f) as dn:
        for dn_list in [d.strip().split() for d in dn]:
            image_id, score, lx, ly, rx, ry = dn_list
            dn_id.setdefault(image_id,[])
            dn_id[image_id].append([class_name,score,lx,ly,rx,ry])
for i,key in enumerate(c4_classes):
    if i==0:print("Info: {} classes found, listing below".format(len(c4_classes)))
    if i!=0 and i%5==0:print("")
    sys.stdout.write("{:24s}".format(key))
print('')

# save result as FmtDR in detection-results directory
matchs=0
mismatchs=0
for image_id in dn_id:

    dr_file=os.path.join(dr_dir, image_id+'.txt')
    gt_file=os.path.join(gt_dir, image_id+'.txt')

    # check mismatch between gt and result files
    if not os.path.exists(gt_file):
        mismatchs+=1
        if mismatchs==1:print("Warning: check mismatch between ground-truth and result file")
        if mismatchs<10:print("{:4d}: {}".format(mismatchs,gt_file))
        if mismatchs==9:print("    ...")
        continue
    else:
        matchs+=1
    with open(dr_file, "w") as f:
        objs=dn_id[image_id]
        for obj in objs:
            class_name, score, lx, ly, rx, ry = obj
            class_name, score, lx, ly, rx, ry = str(class_name),float(score),float(lx),float(ly),float(rx),float(ry)
            f.write("{} {} {} {} {} {}\n".format(class_name, score, lx, ly, rx, ry))
# endroll
print("Info: matchs/mismatchs = {}/{}".format(matchs,mismatchs))
if mismatchs>0:
    print("Warning:{} mismatchs found between ground_truth and result files".format(mismatchs))
if matchs==0:
    print("Faild:{} matchs!".format(matchs))

