import UUIDs

"""
    latest(name::AbstractString;
           cache = RegistryParsingCache(),
           registries = [],
           include_default_registries::Bool = true)

Get the latest registered version of a package, given the name of the package.

## Examples

```julia
julia> Pkg.add(latest("Example"))
```
"""
@inline function latest(name::AbstractString;
                        cache = RegistryParsingCache(),
                        registries = [],
                        include_default_registries::Bool = true)
    package = PartialUnversionedPackage(name)
    result = _latest(
        package;
        cache = cache,
        registries = registries,
        include_default_registries = include_default_registries,
    )
    return result
end

"""
    latest(name::AbstractString,
           uuid::UUID;
           cache = RegistryParsingCache(),
           registries = [],
           include_default_registries::Bool = true)

Get the latest registered version of a package, given the name and UUID of the package.

## Examples

```julia
julia> Pkg.add(latest("Example", UUID("7876af07-990d-54b4-ab0e-23690620f79a")))
```
"""
@inline function latest(name::AbstractString,
                        uuid::UUIDs.UUID;
                        cache = RegistryParsingCache(),
                        registries = [],
                        include_default_registries::Bool = true)
    package = PartialUnversionedPackage(name, uuid)
    result = _latest(
        package;
        cache = cache,
        registries = registries,
        include_default_registries = include_default_registries,
    )
    return result
end


@inline function _latest(package::PartialUnversionedPackage,;
                         cache,
                         registries,
                         include_default_registries::Bool)
    registry_list = make_registry_list(registries;
                                       include_default_registries = include_default_registries)
    parse_registries!(cache, registry_list)
    full_package = identify_package(package, cache)
    package.name == full_package.name || throw(PackageNotFoundException("An unexpected error occured when trying to find the package"))
    if package.uuid !== nothing
        package.uuid == full_package.uuid || throw(PackageNotFoundException("An unexpected error occured when trying to find the package"))
    end
    versions = Vector{VersionAndTree}(undef, 0)
    for registry in keys(cache)
        if haskey(cache[registry], full_package)
            push!(versions, cache[registry][full_package])
        end
    end
    num_versions = length(versions)
    version_numbers = [VersionNumber(versions[j].version) for j in 1:num_versions]
    max_version_number = maximum(version_numbers)
    indices_of_max_version_numbers = findall(version_numbers .== max_version_number)
    versions_at_max = versions[indices_of_max_version_numbers]
    first_version_at_max = versions_at_max[1]
    for v in versions_at_max
        assert_no_disagreement(first_version_at_max, v)
    end
    result = VersionedPackage(
        full_package.name,
        full_package.uuid,
        first_version_at_max.version,
        first_version_at_max.tree,
    )
    return result
end
