# Setup

Create folder in ```./darknet```

Finde labels and run in Julia:

```julia
include("ROI.jl")
```


with ```origin = "path/to/origin/whereTheLabelsAre"```

and ```targe = "path/to/whereTheImageFilesAre"```

```fileList = ROI.getLabelledFiles(origin)```

run the loop in ```SD_YOLO_workflow.jl```, this will write the labels in a txt next to the images in the image folder.

Then set the train list:

Requires train/test/validation split!!


In ```SD_YOLO_workflow.jl```

```ROI.setListFile``` can be used to generate a train test split. 



# Config für Darknet


Need a ```.data``` file, like

```
classes= 4
train  = /Users/svenduve/darknet/vetTrain/train.txt
valid  = /Users/svenduve/darknet/vetTrain/valid.txt
names = /Users/svenduve/darknet/vetTrain/voc.names
backup = backup
```

Here, ```train.txt``` contains a list of all train images.
Here, ```valid.txt``` contains a list of all validation images.

name given in darknet is ```voc.data```, should be changed to something more meaningful.


also reauire a ```.names``` file like this:

```
Hundeauge_rechts
Hundeauge_links
Katzenauge_rechts
Katzenauge_links
```


Get the pretrained weights:

```
wget https://pjreddie.com/media/files/darknet53.conv.74
```



Once the setup is done, in the darknet root folder, we need:

```
./darknet detector train vetTrain/voc.data cfg/yolov3-voc.cfg darknet53.conv.74
```

Here:
- ```vetTrain/voc.data``` is our set config file. The rest is done for us.

This uses pretrained weights as mentioned above. 

