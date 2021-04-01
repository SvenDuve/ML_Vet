include("ROI.jl")

using Statistics
using GeometricalPredicates
using Images
using JSON


# some workflow

# read label data

origin = "/Users/svenduve/HiDrive/vetData/labelAugendetektion_small/"
target = "/Users/svenduve/localGitHub/ML_Vet/label"
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

ROI.setListFile(fileList, "data.txt")

