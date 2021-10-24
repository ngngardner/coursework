# knn

The purpose of this project is to implement k-nearest-neighbors in the julia language.

# Dependencies

Julia is required to run this project. Julia can be installed with `apt`: `apt install julia`.

Julia packages required for this project are listed in `ngardn10kNNPackages.jl`. To install required packages, run `julia ngardn10kNNPackages.jl`

# Running

The main program is run with `julia ngardn10kNN.jl`. The following flags are available:

--normalize, -n: flag, default false: If specified, normalize the data using z-score transformation.

--random, -r: flag, default false. If specified, randomly sample percent_train data from input dataset.

--logging, -l: flag, default true. If specified, do not log to terminal and file.

Use `julia ngardn10kNN.jl --help` for more info.

# Example

`julia ngardn10kNN.jl -i wdbc.data.mb.csv -k 3 -c -1 -P 70`

```
Dataset Shape:
(613, 30)
Train Shape:
(429, 30)
Test Shape:
(184, 30)
Ground truth labels:
[-1.0, ..., 1.0]
Predicted labels:
[-1, ..., 1]
Confusion matrix: 
[90 6; 13 75]
Accuracy: 
0.8967391304347826
```

`julia ngardn10kNN.jl -i wdbc.data.mb.csv -k 3 -c 31 -P 70 -r`

```
Dataset Shape:
(613, 30)
Train Shape:
(429, 30)
Test Shape:
(303, 30)
Ground truth labels:
[-1.0, ..., -1.0]
Predicted labels:
[-1, ..., -1]
Confusion matrix: 
[179 9; 20 95]
Accuracy: 
0.9042904290429042
```