using Images, ImageView
using ImageFiltering
using ImageSegmentation
using JSON


img = load("/Users/svenduve/HiDrive/VetData/imageData/1000003.jpg")
imshow(img)

y = size(img)[1]
x = size(img)[2]

160 * 0.9

img_small = imresize(img, (160, 144)) 




segments = unseeded_region_growing(img_small, 0.19)

# 3 = 0.19
# 4 = 0.18


imshow(map(i->segment_mean(segments,i), labels_map(segments)));

map(i->segment_mean(segments,i), labels_map(segments))



img_small_gray = Gray.(img_small)

function seg(img, level = 0.15)
    segments = unseeded_region_growing(img, level)
    map(i->segment_mean(segments,i), labels_map(segments))
end

seg(img_small_gray, 0.2)

segments = fast_scanning(img_small, 0.1) 
segments = prune_segments(segments, i->(segment_pixel_count(segments,i)<50), (i,j)->(-segment_pixel_count(segments,j)))




labelPath = "/Users/svenduve/HiDrive/VetData/labelData/pigment_polygon.json"
labels = JSON.parsefile(labelPath)
labels["regions"]

using Luxor

lst = [[Point(el["x"], el["y"]) for el in  labels["regions"][i]["points"]] for i in 1:length(labels["regions"])]


w = x
h = y
buffer = zeros(UInt32, w, h)
@imagematrix! buffer begin
sethue("white")
for l in lst
    poly(l, :fill)
end
end 3456 2304

rgb_buffer = map(p -> reinterpret(Images.RGB24, p), buffer)
my_mask = Gray.(rgb_buffer) .> 0.5
imshow(my_mask)




polygons = Dict{}
lst = []
for i in 1:length(labels["regions"][1])
    push!(lst, tuple(labels["regions"][i]["tags"][1], Int(round(labels["regions"][i]["points"][1]["x"])), Int(round(labels["regions"][i]["points"][1]["y"]))))
end

seeds = [(CartesianIndex(lst[1][2], lst[1][3]), 1), 
(CartesianIndex(lst[2][2], lst[2][3]), 1), (CartesianIndex(lst[3][2], lst[3][3]), 1), 
(CartesianIndex(lst[4][2], lst[4][3]), 1), (CartesianIndex(lst[5][2], lst[5][3]), 1)]

tags = Dict("pigment" => 1, "pupille" => 2, "hornhaut" => 3, "tier" => 4)
seeds = [(CartesianIndex((el[2], el[3])), tags[el[1]]) for el in lst]


img_label = map(i->segment_mean(segments,i), labels_map(segments))

segments = fast_scanning(img_label, 0.5)

labels_map(segments)



segments = seeded_region_growing(img, seeds)


segments = unseeded_region_growing(img_small, 0.15)



imshow(map(i->segment_mean(segments,i), labels_map(segments)));



segments = felzenszwalb(img_small, 5)






imshow(map(i->segment_mean(segments,i), labels_map(segments)))

imshow(map(i->get_random_color(i), labels_map(segments)))



using Luxor
using Images
using ImageView

w = 10
h = 10
buffer = zeros(UInt32, w, h)
@imagematrix! buffer begin
randompoints = [Luxor.Point(1.0, 1.0), Luxor.Point(2.0, 10.0), Luxor.Point(7.0, 3.0)]
sethue("white")
poly(randompoints, :fill)
end 10 10 

rgb_buffer = map(p -> reinterpret(Images.RGB24, p), buffer)
my_mask = Gray.(rgb_buffer) .> 0.5
imshow(my_mask)




mt = zeros(Int, 10, 10)

p1 = Dict("x"=>2, "y"=>7)
p2 = Dict("x"=>3, "y"=>4)
p3 = Dict("x"=>5, "y"=>3)
p4 = Dict("x"=>6, "y"=>4)
p5 = Dict("x"=>5, "y"=>8)


one = Point(p1["y"], p1["x"])
two = Point(p2["y"], p2["x"])
three = Point(p3["y"], p3["x"])
four = Point(p4["y"], p4["x"])
five = Point(p5["y"], p5["x"])

poly = Polygon(one, two , three, four, five)

[if inpolygon(poly, Point(x, y)) mt[x, y] = 1 end for x in range(1, stop=10), y in range(1, stop=10)]


mt2 = zeros(Int, 10, 10)
mt[7, 2] = 1
mt[4, 3] = 1
mt[3, 5] = 1
mt[4, 6] = 1
mt[8, 5] = 1





for i in range(1, stop=10)
    
    if p3["y"] < y < p1["y"]
        mt[i, Int(y)] = 1
    end
end



ll = Point(1.0,1.0)
lr = Point(1.2,1.0)
ur = Point(1.2,1.2)
ul = Point(1.0,1.2)
poly = Polygon(ll, lr, ur, ul)
inpolygon(poly, Point(1.1,1.1))


using Images
using GeometricalPredicates

pts = [(1.0, 1.0), (10.0, 50.0), (100.0, 25.0)]
adj = 256
randompoints = [Point(p[1] + adj, p[2] + adj) for p in pts]

w = 512
h = 512
buffer = zeros(Int, w, h)
poly = Polygon(randompoints...)
[if inpolygon(poly, Point(x, y)) buffer[x, y] = 1 end for x in collect(1:1:w), y in collect(1:1:h)];





path = "/Users/svenduve/HiDrive/VetData/labelData/pigment_polygon.json"








ROI.setPolygon(path)

someObject = ROI.setPolygon(labelPath)
someObject.path



labelPath = "/Users/svenduve/HiDrive/VetData/labelData/paulBeispiel.json"
labels = JSON.parsefile(labelPath)
labels["regions"]