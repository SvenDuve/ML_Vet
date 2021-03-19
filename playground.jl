include("ROI.jl")




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
label2 = ROI.setROI(pol2, "Epithelpigment")
label3 = ROI.setROI(pol3, "Neovaskularisation")

label6 = ROI.setROI(pol6, "Hornhautdefekt")
label7 = ROI.setROI(pol6, "Neovaskularisation")

p = Polygon(pol3.points["Neovaskularisation"]...)

using GeometricalPredicates

inpolygon(p, Point(235, 180))



