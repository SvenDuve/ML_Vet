include("ROI.jl")


using Images
using ImageMagick
using QuartzImageIO
using ImageIO




path = "/Users/svenduve/HiDrive/vetData/labelData"

list = ROI.getLabelledFiles(path)

list[2]


pol1 = ROI.setPolygon(list[2])
pol2 = ROI.setPolygon(list[3])
pol3 = ROI.setPolygon(list[4])
pol4 = ROI.setPolygon(list[5])
pol5 = ROI.setPolygon(list[6])
pol6 = ROI.setPolygon(list[7])


currentFile = JSON.parsefile(list[3])

label = ROI.setROI(pol1, "Katarakt")
label2 = ROI.setROI(pol1, "Epithelpigment")
label3 = ROI.setROI(pol3, "Neovaskularisation")

label6 = ROI.setROI(pol6, "Hornhautdefekt")
label7 = ROI.setROI(pol6, "Neovaskularisation")

p = Polygon(pol3.points["Neovaskularisation"]...)

using GeometricalPredicates

inpolygon(p, Point(235, 180))


img = rand(10,10)


Gray.(label2)


i = 0
fileList = []
diagnosis = "Neovaskularisation"
for it in list
    try
        polObj = ROI.setPolygon(it)
        if diagnosis in keys(polObj.points)
            imgFile = split(polObj.path, "/")[end]
            push!(fileList, (imgFile, it))
        end
        i += 1
    catch
        println("No key given")
    end
end


pathToImage = "/Users/svenduve/HiDrive/vetData/imageData_small"

d=2
load(joinpath(pathToImage, fileList[d][1]))
Gray.(ROI.setROI(ROI.setPolygon(joinpath(fileList[d][2])), diagnosis))



pathToSegmentationImage = "/Users/svenduve/HiDrive/vetData/labelAugendetektion_small"


fileList = ROI.getLabelledFiles(pathToSegmentationImage)



# example label
# label - 
#11 0.34135977337110485 0.609 0.4164305949008499 0.262
#14 0.5070821529745043 0.508 0.9745042492917847 0.972


# koordinaten gehen von ursprung links oben aus. Y werte sind positive gehen aber nach unten 

using JSON
fileJson = JSON.parsefile(fileList[1])
region = fileJson["regions"][1]["boundingBox"]
b = (region["left"], region["left"] + region["width"], region["top"], region["top"] + region["height"])
