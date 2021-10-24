
using ArgParse

function parse_commandline()
    s = ArgParseSettings()
    @add_arg_table s begin
        "--input_file", "-i"
            help = "Input file to run algorithm on."
            arg_type = String
            default = "wdbc.data.mb.csv"
        "-k"
            help = "Number of `k` to use for knn algorithm."
            arg_type = Int
            default = 3
        "--class_attribute", "-c"
            help = "Column in the input data which contains the class attribute."
            arg_type = Int
            default = -1
        "--percent_train", "-P"
            help = "Percentage of data to use for training."
            arg_type = Float64
            default = 70.0
        "--normalize", "-n"
            help = "Whether to normalize the data."
            action = :store_true
        "--random", "-r"
            help = "Whether to randomly sample the data."
            action = :store_true
        "--logging", "-l"
            help = "Whether to randomly sample the data."
            action = :store_false
    end

    return parse_args(ARGS, s)
end