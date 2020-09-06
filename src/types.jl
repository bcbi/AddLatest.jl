import UUIDs

struct PartialUnversionedPackage
    name::String
    uuid::Union{UUIDs.UUID, Nothing}
end

@inline function PartialUnversionedPackage(name::AbstractString)
    return PartialUnversionedPackage(name, nothing)
end

struct FullUnversionedPackage
    name::String
    uuid::UUIDs.UUID
end

"""
A specific version of a package.

Fields:
- `name::String`
- `uuid::UUID`
- `version::String`
- `tree::String`
"""
struct VersionedPackage
    name::String
    uuid::UUIDs.UUID
    version::String
    tree::String
end

struct VersionAndTree
    version::String
    tree::String
end

@inline function VersionAndTree(version::AbstractString, tree::AbstractString)
    versionnumber = VersionNumber(version)
    return VersionAndTree(version, versionnumber, tree)
end

"""
Supertype for all registry types.
"""
abstract type AbstractRegistry end

"""
A registry that is cloned using Git.

## Examples

```julia
julia> registries = [GitRegistry("https://github.com/JuliaRegistries/General.git")]

julia> Pkg.add(latest("Example"; registries = registries))
```
"""
struct GitRegistry <: AbstractRegistry
    url::String
end



"""
A registry that already exists in a folder on the filesystem.

## Examples

```julia
julia> registries = [LocalFolderRegistry("/path/to/my/registry/")]

julia> Pkg.add(latest("Example"; registries = registries))
```
"""
struct LocalFolderRegistry <: AbstractRegistry
    path::String
end

struct ParsedRegistry
    dict::Dict{FullUnversionedPackage, VersionAndTree}
end

@inline function ParsedRegistry()
    dict = Dict{FullUnversionedPackage, VersionAndTree}()
    return ParsedRegistry(dict)
end

@inline function Base.keys(parseresult::ParsedRegistry)
    return Base.keys(parseresult.dict)
end

@inline function Base.haskey(parseresult::ParsedRegistry, key)
    return Base.haskey(parseresult.dict, key)
end

@inline function Base.getindex(parseresult::ParsedRegistry, key)
    return Base.getindex(parseresult.dict, key)
end

@inline function Base.setindex!(parseresult::ParsedRegistry, key, value)
    return Base.setindex!(parseresult.dict, key, value)
end

"""
A cache for holding the results of parsed registries.

## Examples

```julia
julia> cache = RegistryParsingCache()

julia> Pkg.add(latest("PkgA", cache))

julia> Pkg.add(latest("PkgB", cache))

julia> Pkg.add(latest("PkgC", cache))
```
"""
struct RegistryParsingCache
    cachedict::Dict{AbstractRegistry, ParsedRegistry}
end

@inline function RegistryParsingCache()
    cachedict = Dict{AbstractRegistry, ParsedRegistry}()
    return RegistryParsingCache(cachedict)
end

@inline function Base.keys(cache::RegistryParsingCache)
    return Base.keys(cache.cachedict)
end

@inline function Base.haskey(cache::RegistryParsingCache, key)
    return Base.haskey(cache.cachedict, key)
end

@inline function Base.getindex(cache::RegistryParsingCache, key)
    return Base.getindex(cache.cachedict, key)
end

@inline function Base.setindex!(cache::RegistryParsingCache, key, value)
    return Base.setindex!(cache.cachedict, key, value)
end

@inline function Base.empty!(cache::RegistryParsingCache)
    return Base.empty!(cache.cachedict)
end

struct PackageAmbiguousException <: Exception
    msg::String
end

struct PackageNotFoundException <: Exception
    msg::String
end

struct RegistriesDisagreeException <: Exception
    msg::String
end
