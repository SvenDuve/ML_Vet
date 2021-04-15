module ROI

    # We create 
    # a function that gets me the file list for the labels
    # a struct that carries informations about an image 
    # a function that sets the ROI in a matrix of size image 

    using Statistics
    using GeometricalPredicates
    using Images
    using JSON
    
    export getLabelledFiles, setPolygon, setROI, setLabels, getCoordinates
    
    categories = Dict("Hundeauge_links" => 1, "Hundeauge_rechts" => 2, "Katzenauge_links" => 3, "Katzenauge_rechts" => 4)
    
    struct polyROI
        path
        height
        width
        points
    end # polyROI

    struct bb
        path

    end # bb



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


    function setLabels(origin; target = pwd())
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

<<<<<<< HEAD
    function setListFile(fileList, origin, name)
=======
    function setListFile(fileList, target, name)
>>>>>>> main

        open(name, "w") do io

            for file in fileList
                try
                    assetFile = JSON.parsefile(file)
<<<<<<< HEAD
                    write(io, origin * "$(assetFile["asset"]["name"])\n")                    
=======
                    write(io, target * "$(assetFile["asset"]["name"])\n")                    
>>>>>>> main
                catch
                    @warn "Could not write $(file)"
                end

            end

        end

    end # setListFile

end #ROI