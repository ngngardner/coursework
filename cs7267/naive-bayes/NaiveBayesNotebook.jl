### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ d6a60030-1ded-11eb-1100-cf77a754e1ca
begin
	import Revise
	import CSV
	import Tables
	
	using StatsBase
	using DelimitedFiles
end

# ╔═╡ c1a37be0-1df2-11eb-1051-27222b14dc31
# split the data in to test data and train data based on the input percentage
function train_test_split(
		data,
		class_attribute,
		percent_train;
		sampling::String="none")
	
	# split according to class_attribute
	if class_attribute == -1
		X = data[:, 1:end-1]
		Y = data[:, end]
	else
		X = data[:, setdiff(1:end, class_attribute)]
		Y = data[:, class_attribute]
	end
	
	# split according to percent_train
	n, d = size(X)
	num_train = convert(Int64, round(n*(percent_train/100), digits=0))
	
	# sample either randomly or first num_train elements
	if sampling == "random"
		i = sample(1:n, num_train) # not working
	else
		i = 1:num_train
	end
	
	X_train = X[i, :]
    Y_train = Y[i, :]
    X_test = X[setdiff(1:end, i), :]
    Y_test = Y[setdiff(1:end, i), :]
	
	# all classes in dataset
	classes = unique(Y)
	
	return X_train, Y_train, X_test, Y_test, classes
end

# ╔═╡ fc2b55a0-1dfa-11eb-0598-193587200904
# calculate mean in each column (dimension) for the given input array
function meancols(input::Array{Float64, 2})
	n, d = size(input)

	μ = Vector{Float64}(undef, d)

	for j in 1:d
		μ[j] = sum(input[:, j])/size(input[:, j], 1)
	end

	return μ
end

# ╔═╡ 00b0b6b2-1dfb-11eb-137d-c9ba9a1ebdb4
# calculate stddev in each column (dimension) for the given input array
function stddev(input::Array{Float64, 2})
	n, d = size(input)

	temp = copy(input)
	
	# calculate mean in each column
	μ = meancols(input)
	σ = Vector{Float64}(undef, d)

	for j in 1:d
		σ[j] = sqrt(sum((input[:, j] .- μ[j]).^2)/n)
	end

	return σ
end

# ╔═╡ 55ae2ad0-1df6-11eb-0c2c-3787366a0ef7
# gaussian probability
function probability(x::Float64, μ::Float64, σ::Float64)
	return 1/(sqrt(2π)*σ) * exp(-(x-μ)^2/(2*σ^2))
end

# ╔═╡ aae1d7e0-1df6-11eb-30e2-0b1a5ba5b92c
struct Summary
	class_label::Float64
	mean::Array{Float64, 1}
	stddev::Array{Float64, 1}
	probability::Float64
end

# ╔═╡ c9d63b40-1df7-11eb-37ab-199a038f4b68
# find mean, standard deviation, and probability of the class for each class
# based on training data
function summarize(X_train, Y_train, classes)
	n = size(classes, 1)
	summaries = Vector{Summary}(undef, n)
	
	for i in 1:n
		idx = findall(y->y==classes[i], Y_train)
		rows = Vector{Int}(undef, size(idx, 1))
		for j in eachindex(idx)
			rows[j] = idx[j][1]
		end
		temp = X_train[rows, :]
		
		# probability of the class
		p = size(temp, 1)/size(X_train, 1)
		
		summaries[i] = Summary(classes[i], meancols(temp), stddev(temp), p)
	end
	
	return summaries
end

# ╔═╡ 2ddbdd80-1dfc-11eb-2316-b1b558f7a30d
# probability that input x is a member of the class provided by Summary s
function member_probability(x::Array{Float64}, s::Summary)
	d = size(x, 1)
	p = Vector{Float64}(undef, d)
	
	p = s.probability
	for i in 1:d
		p *= probability(x[i], s.mean[i], s.stddev[i])
	end
	
	return p
end

# ╔═╡ 122a701e-1dfb-11eb-26ab-8bace19a3f06
function predict(X_test, summaries::Summary, classes)
	n, d = size(X_test)
	m = size(classes, 1)
	
	Y_pred = Vector{Int}(undef, n)

	for i in 1:n
		temp = X_test[i, :]
		p = Vector{Float64}(undef, m)
			
		for j in 1:m
			p[j] = member_probability(temp, summaries[j])
		end
		
		Y_pred[i] = classes[findmax(p)[2]]
	end
	
	return Y_pred
end

# ╔═╡ 04d19750-1e00-11eb-16f7-1f1fba6acdb5
# create confusion matrix
function confusion_matrix(Y_test, Y_pred)
	# unique labels
	unique_labels = unique(Y_test)
	n = size(unique_labels, 1)
	confusion = zeros(Int, (n, n))
	
	for i in 1:size(Y_test, 1)
		test_idx = findall(y->y==Y_test[i], unique_labels)
		pred_idx = findall(y->y==Y_pred[i], unique_labels)
		
		confusion[test_idx, pred_idx] = confusion[test_idx, pred_idx] .+ 1
	end
	
	return confusion
end

# ╔═╡ 7a33cae0-1e00-11eb-1e99-19c622ee4e47
# find accuracy based off confusion matrix
function accuracy(confusion::Array{Int, 2})
	n = size(confusion, 1)
	
	num_correct = 0
	for i in 1:n
		num_correct += confusion[i, i]
	end
	
	return num_correct/sum(confusion)
end

# ╔═╡ f4da7450-1e01-11eb-18f4-f5c0668adea6
function file_one(summaries, train_file)
	n = size(summaries, 1)
	d = size(summaries[1].mean, 1)
	
	for i in 1:n
		res = Array{Float64}(undef, d, 4)
		for j in 1:d
			res[j, 1] = summaries[i].class_label
			res[j, 2] = j
			res[j, 3] = summaries[i].mean[j]
			res[j, 4] = summaries[i].stddev[j]
		end
		
		if i == 1
			CSV.write(train_file, Tables.table(res))
		else
			CSV.write(train_file, Tables.table(res), append=true)
		end
	end
	
	
	open(train_file, "a") do io
		write(io, "\n\n")
	end
	
	res = Array{Float64}(undef, n, 2)
	for i in 1:n
		res[i, 1] = summaries[i].class_label
		res[i, 2] = summaries[i].probability
	end
	
	CSV.write(train_file, Tables.table(res), append=true)
end

# ╔═╡ e6d60420-1e04-11eb-2239-65870f23a085
function file_two(X_test, Y_test, Y_pred, confusion, apply_file)
	data = cat(X_test, Y_test, Y_pred, dims=2)
	CSV.write(apply_file, Tables.table(data))
	
	open(apply_file, "a") do io
		write(io, "\n\n")
		write(io, "Confusion Matrix: \n")
	end
	
	CSV.write(apply_file, Tables.table(confusion), append=true)
	
	open(apply_file, "a") do io
		write(io, "\n\n")
		write(io, "Accuracy: \n")
		writedlm(io, accuracy(confusion))
	end
end

# ╔═╡ 12869380-1df3-11eb-23d6-d703cfc0387c
begin
	input_file = "wdbc.data.mb.csv"
	label_col = -1
	percent_train = 70
	
	train_file = string("ngardn10BayesianTrain", percent_train, input_file)
    apply_file = string("ngardn10BayesianApply", percent_train, input_file)
end

# ╔═╡ 08872da0-1df2-11eb-3717-53bce47aed49
begin
	df = CSV.read(input_file, header=false)
	data = convert(Matrix, df)
	
	X_train, Y_train, X_test, Y_test, classes = train_test_split(data, label_col, percent_train)
	
	summaries = summarize(X_train, Y_train, classes)
	
	Y_pred = predict(X_test, summaries, classes)
	confusion = confusion_matrix(Y_test, Y_pred)
	acc = accuracy(confusion)
	
	file_one(summaries, train_file)
	file_two(X_test, Y_test, Y_pred, confusion, apply_file)
end

# ╔═╡ Cell order:
# ╠═d6a60030-1ded-11eb-1100-cf77a754e1ca
# ╠═c1a37be0-1df2-11eb-1051-27222b14dc31
# ╠═fc2b55a0-1dfa-11eb-0598-193587200904
# ╠═00b0b6b2-1dfb-11eb-137d-c9ba9a1ebdb4
# ╠═55ae2ad0-1df6-11eb-0c2c-3787366a0ef7
# ╠═aae1d7e0-1df6-11eb-30e2-0b1a5ba5b92c
# ╠═c9d63b40-1df7-11eb-37ab-199a038f4b68
# ╠═2ddbdd80-1dfc-11eb-2316-b1b558f7a30d
# ╠═122a701e-1dfb-11eb-26ab-8bace19a3f06
# ╠═04d19750-1e00-11eb-16f7-1f1fba6acdb5
# ╠═7a33cae0-1e00-11eb-1e99-19c622ee4e47
# ╠═f4da7450-1e01-11eb-18f4-f5c0668adea6
# ╠═e6d60420-1e04-11eb-2239-65870f23a085
# ╠═12869380-1df3-11eb-23d6-d703cfc0387c
# ╠═08872da0-1df2-11eb-3717-53bce47aed49
