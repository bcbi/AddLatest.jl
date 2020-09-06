using AddLatest
using Documenter

makedocs(;
    modules=[AddLatest],
    authors="Dilum Aluthge",
    repo="https://github.com/bcbi/AddLatest.jl/blob/{commit}{path}#L{line}",
    sitename="AddLatest.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://bcbi.github.io/AddLatest.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/bcbi/AddLatest.jl",
)
