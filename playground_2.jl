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
