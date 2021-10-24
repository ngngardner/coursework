# NaiveBayes

The purpose of this project is to implement Naive Bayesian classifier in the julia language.

# Dependencies

Julia is required to run this project. Julia can be installed with `apt`: `apt install julia`.

Julia packages required for this project are listed in `ngardn10BayesianPackages.jl`. To install required packages, run `julia ngardn10BayesianPackages.jl`

# Running

The main program is run with julia ngardn10Bayesian.jl.
Use julia ngardn10Bayesian.jl --help for more info.

# Example

`julia ngardn10Bayesian.jl -i wdbc.data.mb.csv -M 70` output stored in `ngardn10BayesianApply70.0wdbc.data.mb.csv`.

Confusion Matrix: 
91,5
6,82


Accuracy: 
0.9402173913043478
