using NaiveBayes
using Documenter

makedocs(;
    modules=[NaiveBayes],
    authors="ngngardner <ngngardner@gmail.com> and contributors",
    repo="https://github.com/ngngardner/NaiveBayes.jl/blob/{commit}{path}#L{line}",
    sitename="NaiveBayes.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://ngngardner.github.io/NaiveBayes.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/ngngardner/NaiveBayes.jl",
)
