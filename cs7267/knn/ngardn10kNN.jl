
include("ngardn10kNNArgs.jl")

using CSV
using DataFrames
using StatsBase
using Tables
using DelimitedFiles

"""
    Given two vectors v1 and v2, calculate the Euclidean distance between them.
"""
function distance(v1, v2)
    size(v1) == size(v2) || throw(ArgumentError("vectors must be same size"))
    v3 = (v1 .- v2).^2
    return sum(v3)
end

"""
    Normalize input training data matrix and input test data matrix
    based on training data z-score.
"""
function normalize(train, test)
    n, d = size(train)
    
    σ = Vector{Float64}(undef, d)
    μ = Vector{Float64}(undef, d)

    temp_train = copy(train)
    temp_test = copy(test)
    fill!(temp_train, 0)
    fill!(temp_test, 0)
    
    for j in 1:d
        μ[j] = sum(train[:, j])/size(train[:, j], 1)
        σ[j] = sqrt(sum((train[:, j] .- μ[j]).^2))
        
        for i in 1:n
            temp_train[i, j] = (train[i, j] - μ[j])/σ[j]
        end
    end
    
    n, d = size(test)
    
    for j in 1:d
        for i in 1:n
            temp_test[i, j] = (test[i, j] - μ[j])/σ[j]
        end
    end

    return (temp_train, temp_test, σ, μ)
end

"""
    Inverse z-score normalization for input data matrix `a` given
    standard deviation vector `σ` and mean vector `μ`.
"""
function inverse_normalize(a, σ, μ)
    n, d = size(a)
    temp = copy(a)
    fill!(temp, 0)
    
    for j in 1:d
        for i in 1:n
            temp[i, j] = σ[j]*a[i, j] + μ[j]
        end
    end
    return temp
end

"""
    For a given input distance matrix `dist` where rows are points
    X[1 ... m], columns are Y[1 ... n], and the values are the 
    distance between the points, sort the rows based on the distance
    between them.
"""
function sortdistances(dist)
    n, d = size(dist)
    
    temp = copy(dist)
    fill!(temp, 0)
    
    for i in 1:n
        sorted_row = sort(dist[i, :])
        for j in 1:d
            temp[i, j] = sorted_row[j]
        end
    end
    
    return temp
end

"""
    Given input data vector `v`, return a vector with each 
    unique value contained within `v`.
"""
function uniques(v)
    n = size(v, 1)

    D = eltype(v)
    u = Vector{D}()

    for i in 1:n
        if v[i] ∉ u
            push!(u, v[i])
        end
    end

    return u
end

"""
    Given input data vector `v`, return the count of each
    unique value contained within `v`.
"""
function counts(v)
    n = size(v, 1)    # size of input data vector
    u = uniques(v)   # vector of unique values in v
    m = size(u, 1)    # size of uniques vector
    c = zeros(Int, m) # array of unique counts

    for j in 1:m
        for i in 1:n
            if v[i] == u[j]
                c[j] += 1
            end
        end
    end

    return c
end

"""
    Predict given a matrix of nearest neighbors labels `class_labels`.

    # Arguments
    - `k`: number of nearest neighbors to consider for classification
    - `Y_test`: vector of ground truth class labels
    - `unique_labels`: vector of each unique label in Y_test
    - `class_labels`: matrix with the nearest neighbors labels
"""
function predict(k, Y_test, unique_labels, class_labels)
    m = size(Y_test, 1)
    Y_pred = Vector{Int}(undef, m) # allocate vector for Y_pred

    for i in 1:m
        row = class_labels[i, 1:k]      # get row data
        label_counts = counts(row)      # count the number of uniques in row

        # get the index with the max value, break ties by first index
        max_count = maximum(label_counts)
        if max_count == k
            Y_pred[i] = row[1] # if all the neighbors are the same class, the below method will fail
        else
            idx = findall(x->x==max_count, label_counts)[1]
            Y_pred[i] = unique_labels[idx]  # set Y_pred equal to the label with max count
        end
    end
    return Y_pred
end

"""
    knn algorithm that classifies data based on the input `k`
    nearest-neighbors.

    # Arguments
    - `data`: input data matrix
    - `k`: number of nearest neighbors to consider for classification
    - `class_attribute`: column containing the class attribute
    - `percent_train`: percentage of data to use for model training
        in the range 0 < percent_train <= 100
    - `input_file`: name of the input file to store evaulation
    # Optional
    - `normalized`: whether to normalize the input data
    - `random`: whether to randomly sample the input data
    - `logging`: log progress and steps
"""
function knn(
    data, k, class_attribute, percent_train, input_file; normalized=true, random=false, logging=true)

    eval_file  = string("ngardn10", k, "NNEvaluate", percent_train, input_file)
    apply_file = string("ngardn10", k, "NNApply", percent_train, input_file)

    # get class attribute from data
    if class_attribute == -1
        X = data[:, 1:end-1]
        Y = data[:, end]
    else
        X = data[:, setdiff(1:end, class_attribute)]
        Y = data[:, class_attribute]
    end
    
    # get the number of samples to use for training
    n, d = size(X)
    num_train = convert(Int64, round(n*(percent_train/100), digits=0))
    
    # randomly sampled indices from X
    if random
        i = sample(1:n, num_train)
    else
        i = 1:num_train
    end
    
    # split test and train
    X_train = X[i, :]
    Y_train = Y[i, :]
    X_test = X[setdiff(1:end, i), :]
    Y_test = Y[setdiff(1:end, i), :]
    if logging
        println("Dataset Shape:")
        println(size(X))
        println("Train Shape:")
        println(size(X_train))
        println("Test Shape:")
        println(size(X_test))
    end
    
    # normalize
    if normalized == true
        !logging || println("Normalizing data...")
        X_train, X_test, σ, μ = normalize(X_train, X_test)
    end
    
    # first data matrix, where the test data are rows and the 
    # train data are columns. the data in the matrix is the 
    # distance between the test and the train data.
    m = size(X_test, 1)
    n = size(X_train, 1)
    dist = Array{Float64}(undef, m, n)
    for i in 1:m
        for j in 1:n
            dist[i, j] = distance(X_test[i, :], X_train[j, :])
        end
    end

    # second data matrix, where distances are sorted by row
    sorted_dist = sortdistances(dist)
    if logging
        CSV.write(eval_file, Tables.table(dist))
        open(eval_file, "a") do io
            write(io, "\n\n\n\n")
        end
        CSV.write(eval_file, Tables.table(sorted_dist), append=true)
    end
    
    # third data matrix, which provides class labels
    class_labels = Array{Int}(undef, m, n)
    for i in 1:m
        for j in 1:n
            sd = sorted_dist[i, j]
            # finds the first index where the sorted_dist is in dist
            idx = findall(x->x==sd, dist[i, :])[1]
            class_labels[i, j] = Y_train[idx]
        end
    end
    if logging
        open(eval_file, "a") do io
            write(io, "\n\n\n\n")
        end
        CSV.write(eval_file, Tables.table(class_labels), append=true)
    end

    # predict data based on k nearest neighbors
    unique_labels = uniques(Y_test) # get unique labels in Y_test
    Y_pred = predict(k, Y_test, unique_labels, class_labels)
    
    # inverse normalize
    if normalized
        !logging || println("Inverse normalizing data for verification...")
        X_train = inverse_normalize(X_train, σ, μ)
        X_test = inverse_normalize(X_test, σ, μ)
    end
    
    # array with test_data, ground truth label, and predicted label
    output_data = cat(X_test, Y_test, Y_pred, dims=2)
    
    
    # confusion matrix
    if logging
        CSV.write(apply_file, Tables.table(output_data))
        println("Ground truth labels:")
        println(Y_test)
        println("Predicted labels:")
        println(Y_pred)
    end
    
    n = size(unique_labels, 1)
    confusion = zeros(Int, (n,n))
    for i in 1:size(Y_test, 1)
        test_idx = findall(x->x==Y_test[i], unique_labels)
        pred_idx = findall(x->x==Y_pred[i], unique_labels)
        confusion[test_idx, pred_idx] = confusion[test_idx, pred_idx] .+ 1
    end

    if logging
        println("Confusion matrix: ")
        println(confusion)
        open(apply_file, "a") do io
            write(io, "\n\n\n\n")
            write(io, "Confusion Matrix: \n")
        end
        CSV.write(apply_file, Tables.table(confusion), append=true)
    end
    
    # overall accuracy
    num_correct = 0
    for i in 1:n
        num_correct += confusion[i, i]
    end
    
    accuracy = num_correct/sum(confusion)
    if logging
        println("Accuracy: ")
        println(accuracy)
        open(apply_file, "a") do io
            write(io, "\n\n\n\n")
            write(io, "Accuracy: \n")
            writedlm(io, accuracy)
        end
    end

    return accuracy
end

function main()
    parsed_args = parse_commandline()

    input_file      = parsed_args["input_file"]
    k               = parsed_args["k"]
    class_attribute = parsed_args["class_attribute"]
    percent_train   = parsed_args["percent_train"]
    normalized      = parsed_args["normalize"]
    random          = parsed_args["random"]
    logging         = parsed_args["logging"]

    df = CSV.read(input_file, header=false)
    data = convert(Matrix, df)
    
    knn(data, k, class_attribute, percent_train, input_file; 
        normalized=normalized, random=random, logging=logging)
end

main()
