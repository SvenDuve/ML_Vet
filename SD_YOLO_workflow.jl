include("ROI.jl")

using Statistics
using GeometricalPredicates
using Images
using JSON


# some workflow

# read label data

origin = "/Users/svenduve/HiDrive/vetData/labelAugendetektion_small/"
#target = "/Users/svenduve/localGitHub/ML_Vet/label"
target = "/Users/svenduve/darknet/vetTrain/labels"
fileList = ROI.getLabelledFiles(origin)

i = 1

for file in fileList
    try
        println(i)
        ROI.setLabels(file; target);
    catch
        @warn "Could not write $(file)"
    end
    i += 1
end


# prepare file list

origin = "/Users/svenduve/HiDrive/vetData/imageData_small/"

ROI.setListFile(fileList[1:10], origin, "train.txt")

ROI.setListFile(fileList[11:14], origin, "valid.txt")

ROI.setListFile(fileList, target, "train.txt")
ROI.setListFile(fileList, target, "valid.txt")




pathOnVM = "/home/svenduve/darknet/vetTrain/images"