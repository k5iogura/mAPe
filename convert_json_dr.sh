import os,sys,re,json

coco_ids = [1,2,3,4,5,6,7,8,9,10,11,13,14,15,16,17,18,19,20,21,22,23,24,25,27,28,31,32,33,34,35,36,37,38,39,40,41,42,43,44,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,67,70,72,73,74,75,76,77,78,79,80,81,82,84,85,86,87,88,89,90]

thresh = 0.005
val5="2007_test.txt"
jsnt="coco_results.json"
coco="coco.names"
with open(coco) as c:
    cnames = [re.sub(' ','_',cn.strip()) for cn in c]
with open(jsnt) as j:
    jsons = json.load(j)
with open(val5) as v:
    jpegs = [jpg.strip() for jpg in v]

for jpeg in jpegs:
    f1 = os.path.basename(jpeg)
    f2 = os.path.splitext(f1)[0]
    f3 = f2+'.txt'
    fi = re.search('([0-9]+).jpg',f1).groups()[0]
    image_id =int(fi)
    res= [j for j in jsons if j['image_id'] == image_id and j['score'] > thresh]
    with open('val5k/'+f3, "w") as f:
        for r in res:
            c, b, s = r['category_id'], r['bbox'], r['score']
            c = coco_ids.index(c)
            cname = cnames[c]
            ## lx, ly, rx, ry = b[0]-b[2]/2., b[1]-b[3]/2., b[0]+b[2]/2., b[1]+b[3]/2.
            lx, ly, rx, ry = b[0], b[1], b[0]+b[2], b[1]+b[3]
            f.write("{} {} {} {} {} {}\n".format(cname,s,lx,ly,rx,ry))

