module ROI

    # We create 
    # a function that gets me the file list for the labels
    # a struct that carries informations about an image 
    # a function that sets the ROI in a matrix of size image 

    using Statistics
    using GeometricalPredicates
    using Images
    using JSON

    export impJSON, getLabelledFiles

    struct polyROI
        path
        height
        width
        points
    end # polyROI


    function getLabelledFiles(path)

        fileList = []

        for file in readdir(path, join=true)
            push!(fileList, file)
        end #for

        return fileList

    end # getLabelledFiles



    function setPolygon(pathToLabel)

        dt = JSON.parsefile(pathToLabel)

        polyObject = polyROI(
            dt["asset"]["path"],
            dt["asset"]["size"]["height"],
            dt["asset"]["size"]["width"],
            Dict(dt["regions"][i]["tags"][1] => [Point(el["x"], el["y"]) for el in dt["regions"][i]["points"]] for i in 1:length(dt["regions"]))
        ) #end polyROI

        return polyObject

    end # setPolygon

    function setROI(polygon, label)

        buffer = zeros(Int, polygon.height, polygon.width)
        poly = Polygon(polygon.points[label]...)
        return [if inpolygon(poly, Point(y, x)) buffer[x, y] = 1 else buffer[x, y] = 0 end for x in collect(1:1:polygon.height), y in collect(1:1:polygon.width)]

    end # setROI

end #ROI