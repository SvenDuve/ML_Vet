include("ROI.jl")


origin = "/home/svenduve/darknet/vetTrain/labels"
target = "/home/svenduve/darknet/vetTrain/images"
fileList = ROI.getLabelledFiles(origin)


for file in fileList
    try
        ROI.setLabels(file; target);
    catch
        @warn "Could not write $(file)"
    end
end


pathOnVM = "/home/svenduve/darknet/vetTrain/"

ROI.setListFile(fileList[1:3], pathOnVM, "train.txt")
ROI.setListFile(fileList[4], pathOnVM, "valid.txt")



