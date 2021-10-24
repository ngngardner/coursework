
using ArgParse

function parse_commandline()
    s = ArgParseSettings()
    @add_arg_table s begin
        "--input_file", "-i"
            help = "Input file to run algorithm on."
            arg_type = String
            default = "wdbc.data.mb.csv"
        "--percent_train", "-M"
            help = "Percentage of data to use for training."
            arg_type = Float64
            default = 70.0
        "--class_attribute", "-c"
            help = "Column in the input data which contains the class attribute."
            arg_type = Int
            default = -1
    end

    return parse_args(ARGS, s)
end
