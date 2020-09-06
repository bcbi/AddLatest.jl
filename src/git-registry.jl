import LibGit2

"""
    parse_registry(registry::GitRegistry)

Clone a registry via Git and parse it.

Example usage:
```julia
julia> registry = GitRegistry("https://github.com/JuliaRegistries/General.git")

julia> parseresult = parse_registry(registry)
```
"""
@inline function parse_registry(registry::GitRegistry)
    temp_directory = mktempdir(; cleanup = true)
    registry_directory = joinpath(temp_directory, "REGISTRY")
    LibGit2.clone(registry.url, registry_directory)
    parseresult = parse_registry(LocalFolderRegistry(registry_directory))
    rm(temp_directory; force = true, recursive = true)
    return parseresult
end
