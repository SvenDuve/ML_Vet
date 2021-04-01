include("ROI.jl")

using Statistics
using GeometricalPredicates
using Images
using JSON


pathToBBLabels = "/Users/svenduve/HiDrive/vetData/labelAugendetektion_small/"


fileList = ROI.getLabelledFiles(pathToBBLabels)


jsonFile = JSON.parsefile(fileList[5])
length(jsonFile["regions"])

struct labelBB
    id
    heigth
    width
    regions
end #labelBB


jsonFile["asset"]

categories = Dict("Hundeauge_links" => 1, "Hundeauge_rechts" => 2, "Katzenauge_links" => 3, "Katzenauge_rechts" => 4)

function setLabels(origin)

    jsonFile = JSON.parsefile(origin)

    labelFileName = split(jsonFile["asset"]["name"], ".")[1] * ".txt"

    open(labelFileName, "w") do io
        for bb in jsonFile["regions"]
            class = categories[bb["tags"][1]]
            x = bb["boundingBox"]["left"]
            y = bb["boundingBox"]["top"]
            width = bb["boundingBox"]["width"]
            height = bb["boundingBox"]["height"]
            write(io, "$(class) $(x) $(y) $(width) $(height)\n")
        end
    end;

    return labelFileName

end #setLabels


origin = fileList[5]


setLabels(origin)