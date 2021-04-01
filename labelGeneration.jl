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

function setLabels(origin; target = pwd())
    print(target)
    jsonFile = JSON.parsefile(origin)
    size = (jsonFile["asset"]["size"]["width"], jsonFile["asset"]["size"]["height"])

    labelFileName = joinpath(target, split(jsonFile["asset"]["name"], ".")[1] * ".txt")
    

    open(labelFileName, "w") do io
        for bb in jsonFile["regions"]
            class = categories[bb["tags"][1]]
            x, y, w, h = getCoordinates(bb, size)
            write(io, "$(class) $(x) $(y) $(w) $(h)\n")
        end
    end

    return labelFileName

end #setLabels


function getCoordinates(bb, size)::NTuple{4,Float32}

    x_min, y_min = bb["points"][1]["x"], bb["points"][1]["y"]
    x_max, y_max = bb["points"][3]["x"], bb["points"][3]["y"]

    dw = 1 / size[1]
    dh = 1 / size[2]
    x = dw * ((x_max - x_min) / 2 - 1)
    y = dh * ((y_max - y_min) / 2 - 1)
    w = dw * (x_max - x_min)
    h = dh * (y_max - y_min)
    return (x, y, w, h)

end #convertCoord

# box -> 1: xmin 2: xmax 3: ymin 4: ymax 
# w = width
# h = height

# dw -> 1 / width
# dh -> 1 / height

# x -> (xmin + xmax) / 2 -1 

origin = fileList[5]

getCoordinates(jsonFile["regions"][1], (jsonFile["asset"]["size"]["width"], jsonFile["asset"]["size"]["height"]))


setLabels(origin)

target = "/Users/svenduve/localGitHub/ML_Vet/label"

for file in fileList[1:10]
    setLabels(file; target)
end