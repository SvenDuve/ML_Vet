using Flux
using Statistics
using DataFrames
using Images
using ImageTransformations


# get x

x = rand(572, 572, 3, 1)


# for some y

y = 


function crop(big, small)

    h = size(big)[1] - size(small)[1]
    w = size(big)[2] - size(small)[2]

    return Int(h / 2), Int(w / 2)

end
# set the model

function model(x)

    conv1 = Conv((3, 3), 3 => 64, relu)(Float32.(x))
    conv1 = Conv((3, 3), 64 => 64, relu)(conv1)
    pool1 = MaxPool((2,2))(conv1)
    @show size(pool1)
    
    conv2 = Conv((3, 3), 64 => 128, relu)(pool1)
    conv2 = Conv((3, 3), 128 => 128, relu)(conv2)
    pool2 = MaxPool((2,2))(conv2)
    @show size(pool2)

    conv3 = Conv((3, 3), 128 => 256, relu)(pool2)
    conv3 = Conv((3, 3), 256 => 256, relu)(conv3)
    pool3 = MaxPool((2,2))(conv3)
    @show size(pool3)

    conv4 = Conv((3, 3), 256 => 512, relu)(pool3)
    conv4 = Conv((3, 3), 512 => 512, relu)(conv4)
    pool4 = MaxPool((2,2))(conv4)
    @show size(conv4)

    conv5 = Conv((3, 3), 512 => 1024, relu)(pool4)
    conv5 = Conv((3, 3), 1024 => 1024, relu)(conv5)

    @show size(conv5)
    
    convT4 = ConvTranspose((2,2), 1024 => 512, stride=(2,2))(conv5)
    h, w = crop(conv4, convT4)
    cropped4 = cat([conv4[h+1:end-h,w+1:end-w,:,:], convT4]..., dims=3)
    @show size(convT4)
    @show size(cropped4)
    @show h, w

    conv4up = Conv((3, 3), 1024 => 512, relu)(cropped4)
    conv4up = Conv((3, 3), 512 => 512, relu)(conv4up)
    convT3 = ConvTranspose((2, 2), 512 => 256, stride=(2,2))(conv4up)
    @show size(conv4up), size(convT3)

    h, w = crop(conv3, convT3)
    cropped3 = cat([conv3[h+1:end-h,w+1:end-w,:,:], convT3]..., dims=3)

    @show size(cropped3)

    conv3up = Conv((3, 3), 512 => 256, relu)(cropped3)
    conv3up = Conv((3, 3), 256 => 256, relu)(conv3up)
    convT2 = ConvTranspose((2, 2), 256 => 128, stride=(2,2))(conv3up)
    @show size(conv3up), size(convT2)

    h, w = crop(conv2, convT2)
    cropped2 = cat([conv2[h+1:end-h,w+1:end-w,:,:], convT2]..., dims=3)

    @show size(cropped2)

    conv2up = Conv((3, 3), 256 => 128, relu)(cropped2)
    conv2up = Conv((3, 3), 128 => 128, relu)(conv2up)
    convT1 = ConvTranspose((2, 2), 128 => 64, stride=(2,2))(conv2up)
    @show size(conv2up), size(convT1)

    h, w = crop(conv1, convT1)
    cropped = cat([conv1[h+1:end-h,w+1:end-w,:,:], convT1]..., dims=3)

    @show size(cropped)

    conv1up = Conv((3, 3), 128 => 64, relu)(cropped)
    conv1up = Conv((3, 3), 64 => 64, relu)(conv1up)
    finalconv = Conv((1,1), 64 => 2, sigmoid)(conv1up)
    
    return finalconv

end

model(x);



(size(X)[1] - size(Y)[1]) / 2

