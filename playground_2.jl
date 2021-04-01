include("UNet.jl")

u = UNet.Unet(3)


w = rand(Float32, 256,256,3,1);

w′ = rand(Float32, 256,256,3,1);

function loss(x, y)
    op = clamp.(u(x), 0.001f0, 1.f0)
    mean(UNet.bce(op, y))
end


using Base.Iterators

rep = Iterators.repeated((w, w′), 10);
using Statistics
using Flux, Flux.Zygote, Flux.Optimise
opt = Momentum()

Flux.train!(loss, Flux.params(u), rep, opt);



## read binary in Julia

X = AbstractVector{Any}


read!("/Users/svenduve/Downloads/yolov3-tiny.weights", X)

open(f -> read(f, String), "/Users/svenduve/Downloads/yolov3-tiny.weights")


io = open("/Users/svenduve/Downloads/yolov3-tiny.weights", "r")


data = Vector{Float32}(undef, sizeof(io))

data = Array{UInt8}(undef, sizeof(io))

open("/Users/svenduve/Downloads/yolov3-tiny.weights", "r") do io
    readbytes!(io, data)
end


read!(io, data);

X = read(io, String)

readuntil(io, UInt8(0))
close(io)


close("/Users/svenduve/Downloads/yolov3-tiny.weights")


using RawArray

X = raread("/Users/svenduve/Downloads/yolov3-tiny.weights")