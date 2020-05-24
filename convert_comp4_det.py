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
parser.add_argument('-r', '--comp4_dir',         type=check, required=True)
args = parser.parse_args()

c4_dir=args.comp4_dir
dr_dir=os.path.join(args.input_dir[0], args.detection_results)

c4_files = glob(c4_dir+"/*")
if len(c4_files)==0:
    print("Error: not found any files in %s"%c4_dir)
    sys.exit(-1)

for f in glob(dr_dir+'/*'):
    if os.path.isdir(f):
        rmtree(f)
    else:
        os.remove(f)
dn_id={}
for f in c4_files:
    if not 'comp4_det_test_' in f:
        print("Error: Can not process file without comp4_det_test_*.txt type, bye")
        sys.exit(-1)
    class_name = re.sub('comp4_det_test_','',os.path.splitext(os.path.basename(f))[0])
    class_name = re.sub(' ','_',class_name)
    print(f,class_name)
    with open(f) as dn:
        for dn_list in [d.strip().split() for d in dn]:
            image_id, score, lx, ly, rx, ry = dn_list
            dn_id.setdefault(image_id,[])
            dn_id[image_id].append([class_name,score,lx,ly,rx,ry])
for image_id in dn_id:
    with open(dr_dir+'/'+image_id+'.txt', "w") as f:
        objs=dn_id[image_id]
        for obj in objs:
            class_name, score, lx, ly, rx, ry = obj
            class_name, score, lx, ly, rx, ry = str(class_name),float(score),float(lx),float(ly),float(rx),float(ry)
            f.write("{} {} {} {} {} {}\n".format(class_name, score, lx, ly, rx, ry))
