### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 3a42ecde-8d83-11eb-3cc3-6f83510d6d2e
begin
	using Flux
	using Images
	using ImageTransformations
end

# ╔═╡ 6ca70910-8d83-11eb-0878-57c0056a291f
begin
	x = rand(Float32, (572, 572, 3, 1))
	y = rand(Float32, (572, 572))
end

# ╔═╡ 99f4a14c-8d83-11eb-19ee-d14585b7bf22
md"""Lets try and push this arbitrary Array through the convolution"""

# ╔═╡ cd584cf8-8d83-11eb-01e7-c33df52c6ced
begin
	#filter = (3,3)
	#in = 3
	#out = 3
	Conv_level_one_one = Conv((3,3), 3 => 64, relu)
	Conv_level_one_two = Conv((3,3), 64 => 64, relu)
	Max_level_one_one = MaxPool((2, 2))
	Conv_level_two_one = Conv((3,3), 64 => 128, relu)
	Conv_level_two_two = Conv((3,3), 128 => 128, relu)
	Max_level_two_one = MaxPool((2, 2))
	Conv_level_three_one = Conv((3,3), 128 => 256, relu)
	Conv_level_three_two = Conv((3,3), 256 => 256, relu)
	Max_level_three_one = MaxPool((2, 2))
	Conv_level_four_one = Conv((3,3), 256 => 512, relu)
	Conv_level_four_two = Conv((3,3), 512 => 512, relu)
	Max_level_four_one = MaxPool((2, 2))
	Conv_level_bottom_one = Conv((3,3), 512 => 1024, relu)
	Conv_level_bottom_two = Conv((3,3), 1024 => 1024, relu)
	ConvTrans_up_level_four_one = ConvTranspose((2,2), 1024 => 512, stride=(2,2))
	
end

# ╔═╡ 48661c22-8d84-11eb-2583-f1793451a3e5
begin
	level_one_Out = Conv_level_one_two(Conv_level_one_one(x))
	level_two_Out = Conv_level_two_two(Conv_level_two_one(Max_level_one_one(level_one_Out)))	
	level_three_Out = Conv_level_three_two(Conv_level_three_one(Max_level_two_one(level_two_Out)))
	level_four_Out = Conv_level_four_two(Conv_level_four_one(Max_level_three_one(level_three_Out)))
	level_five_Out = Conv_level_bottom_two(Conv_level_bottom_one(Max_level_four_one(level_four_Out)))
	level_four_up_in = ConvTrans_up_level_four_one(level_five_Out)
	size(level_four_Out)
end

# ╔═╡ Cell order:
# ╠═3a42ecde-8d83-11eb-3cc3-6f83510d6d2e
# ╠═6ca70910-8d83-11eb-0878-57c0056a291f
# ╠═99f4a14c-8d83-11eb-19ee-d14585b7bf22
# ╠═cd584cf8-8d83-11eb-01e7-c33df52c6ced
# ╠═48661c22-8d84-11eb-2583-f1793451a3e5
