### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ 763a0dab-db93-4e55-b69b-20881e13c955
begin
	using Images
	using StatsBase
end

# ╔═╡ 6d67bb5b-73d8-40a9-8846-b03fd0a91dde
function tuple_to_rgb(t::Tuple{Float64, Float64, Float64})
	return RGB{Float32}(t[1], t[2], t[3])
end

# ╔═╡ 7942af40-adc3-11eb-21ce-f72f58311357
colors = Dict([
	"red" => tuple_to_rgb((214, 102, 97)./255),
	"blue" => tuple_to_rgb((135, 206, 235)./255),
	"green" => tuple_to_rgb((107, 171, 91)./255),
	"purple" => tuple_to_rgb((170, 125, 192)./255),
])

# ╔═╡ 53504cab-208d-480f-9232-6152606c2cf3
function set_color(
		image::Matrix{ColorTypes.RGB{Float32}},
		size::Int64,
		num_sections::Int64,
		section::Int64,
		color::ColorTypes.RGB{Float32})
	# set color of a section of an image given the number of sections times the 
	# size of the sections
	section -= 1
	
	row = section ÷ num_sections
	col = section % num_sections
	
	temp = deepcopy(image)
	temp[
		(row*size)+1:(row*size)+size,
		(col*size)+1:(col*size)+size,
	] .= color
	return temp
end

# ╔═╡ e2819626-3519-411d-991d-6cca0a2b60a6
function get_color(
		image::Matrix{ColorTypes.RGB{Float32}},
		size::Int64,
		section::Int64,
		num_sections::Int64)
	section -= 1
	
	row = section ÷ num_sections
	col = section % num_sections
	return image[
		(row*size)+1:(row*size)+size,
		(col*size)+1:(col*size)+size,
	]
end

# ╔═╡ aa3a1cb9-ca7b-4079-8ec6-748641450ec1
function adjacent_sections(
		section::Int64,
		num_sections::Int64)
	# get sections adjacent to the input section
	adjacents = []
	
	not_top = section > num_sections
	not_bottom = section <= num_sections*num_sections - num_sections
	not_left = section % num_sections != 1
	not_right = section % num_sections != 0
	
	if not_top
		# section not in top-most row, top is available
		push!(adjacents, section-num_sections)
		
		# check top-left and top-right
		if not_left
			push!(adjacents, section-num_sections-1)
		end
		if not_right
			push!(adjacents, section-num_sections+1)
		end
	end
	if not_bottom
		# section not in bottom-most column, bottom is available
		push!(adjacents, section+num_sections)
			
		# check bottom-left and bottom-right
		if not_left
			push!(adjacents, section+num_sections-1)
		end
		if not_right
			push!(adjacents, section+num_sections+1)
		end
	end
	
	if not_left
		# section not in left-most column, left is available
		push!(adjacents, section-1)
	end
	if not_right
		# section not in right-most column, right is available
		push!(adjacents, section+1)
	end
	
	return adjacents
end

# ╔═╡ cdf0a07c-e4c4-442b-88f5-3db3994e7190
function evaluate(
		image::Matrix{ColorTypes.RGB{Float32}},
		size::Int64,
		num_sections::Int64)
	# energy of 0 when a color is not repeated in adjacent sections
	energy = 0
	
	for i in 1:num_sections*num_sections
		color = get_color(image, size, i, num_sections)
		for section in adjacent_sections(i, num_sections)
			adj_color = get_color(image, size, section, num_sections)
			if color == adj_color
				energy += 1
			end
		end
	end
	
	return energy
end

# ╔═╡ 8c8eba2b-5cc4-457b-8c8d-81c1602d65f2
function evaluate_section(
		image::Matrix{ColorTypes.RGB{Float32}},
		size::Int64,
		section::Int64,
		num_sections::Int64)
	# energy of 0 when a color is not repeated in adjacent sections
	energy = 0
	
	color = get_color(image, size, section, num_sections)
	for i in adjacent_sections(section, num_sections)
		adj_color = get_color(image, size, i, num_sections)
		if color == adj_color
			energy += 1
		end
	end
	
	return energy
end

# ╔═╡ d98b4354-3441-419f-8ae6-9013bf1de68e
function available_colors(
		image::Matrix{ColorTypes.RGB{Float32}},
		size::Int64,
		section::Int64,
		num_sections::Int64)
	# a section can be changed to a different color, but not it's current color
	res = [key for key in keys(colors)]
	for color in res
		if all(x -> x == colors[color], get_color(image, size, section, num_sections))
			filter!(x -> x != color, res)
			return res
		end
	end
	
	return res
end

# ╔═╡ 79eb7125-aecf-42d8-b233-a90c20ebe1e3
function available_sections(
		image::Matrix{ColorTypes.RGB{Float32}},
		size::Int64,
		num_sections::Int64)
	# only sections with energy 0 
	# (no adjacents cells have a matching color) can be changed
	res = [i for i in 1:num_sections*num_sections]
	
	for i in [i for i in 1:num_sections*num_sections]
		energy = evaluate_section(image, size, i, num_sections)
		if energy == 0
			filter!(x -> x != i, res)
		end
	end
	
	return res
end

# ╔═╡ cf2e5721-0c12-44a9-b0f6-a6a74dcf831e
function get_move(
		image::Matrix{ColorTypes.RGB{Float32}},
		size::Int64,
		num_sections::Int64)
	# a 'move' consists of a section and a color
	# section = sample(available_sections(image, size, num_sections))
	section = sample(available_sections(image, size, num_sections))
	color = sample(available_colors(image, size, section, num_sections))
		
	return section, color
end

# ╔═╡ bd1f3e97-5ea0-4537-910e-4ba7836efd37
function sim_annealing(
		image::Matrix{ColorTypes.RGB{Float32}},
		size::Int64,
		num_sections::Int64;
		initial_temp = 1000,
		final_temp = 1)
	
	curr_temp = initial_temp
	moves_taken = []
	
	while !(evaluate(image, size, num_sections) == 0)
		while true
			# select move randomly
			section, color = get_move(image, size, num_sections)
			move = Dict([
				"Section" => section,
				"Color" => color
			])
			
			# calculate cost of taking move
			temp = set_color(image, size, num_sections, section, colors[color])
			cost = evaluate(image, size, num_sections) - evaluate(temp, size, num_sections)
			
			# accept better solution or with probability e^(-cost/temp)
			if cost >= 0 || rand() < exp(-cost/curr_temp)
				image = temp
				push!(moves_taken, move)
				break
			end
		end
		
		curr_temp -= 1
		if (curr_temp <= final_temp)
			break
		end
	end
	
	return image, moves_taken
end

# ╔═╡ 818b4f14-65b5-447a-b35b-d14df6e9559d
begin
	num_sections = 4
	size = 32
	
	image = zeros(RGB{Float32}, num_sections*size, num_sections*size)
	
	for section in 1:num_sections*num_sections
		color = sample([key for key in keys(colors)])
		image = set_color(image, size, num_sections, section, colors[color])
	end
end

# ╔═╡ d312c9e6-8a5a-43a0-bb83-72dd36d09128
begin
	res, moves = sim_annealing(image, size, num_sections, initial_temp=10000)
	image, res, length(moves)
end

# ╔═╡ Cell order:
# ╠═763a0dab-db93-4e55-b69b-20881e13c955
# ╠═6d67bb5b-73d8-40a9-8846-b03fd0a91dde
# ╠═7942af40-adc3-11eb-21ce-f72f58311357
# ╠═53504cab-208d-480f-9232-6152606c2cf3
# ╠═e2819626-3519-411d-991d-6cca0a2b60a6
# ╠═aa3a1cb9-ca7b-4079-8ec6-748641450ec1
# ╠═cdf0a07c-e4c4-442b-88f5-3db3994e7190
# ╠═8c8eba2b-5cc4-457b-8c8d-81c1602d65f2
# ╠═d98b4354-3441-419f-8ae6-9013bf1de68e
# ╠═79eb7125-aecf-42d8-b233-a90c20ebe1e3
# ╠═cf2e5721-0c12-44a9-b0f6-a6a74dcf831e
# ╠═bd1f3e97-5ea0-4537-910e-4ba7836efd37
# ╠═818b4f14-65b5-447a-b35b-d14df6e9559d
# ╠═d312c9e6-8a5a-43a0-bb83-72dd36d09128
