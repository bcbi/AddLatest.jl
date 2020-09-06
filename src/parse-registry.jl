import Pkg
# import TOML
import UUIDs

@inline function _delete_yanked_versions!(versions)
    versions_deepcopy = deepcopy(versions)
    for (version, info) in pairs(versions_deepcopy)
        if get(info, "yanked", false) == "true"
            delete!(versions, version)
        end
    end
    return nothing
end

"""
    parse_registry(registry::LocalFolderRegistry)

Parse a registry located at the filesystem path `path_to_registry`.

Example usage:
```julia
julia> registry = LocalFolderRegistry("/path/to/my/registry/")
julia> parseresult = parse_registry(registry)
```
"""
@inline function parse_registry(registry::LocalFolderRegistry)
    path_to_registry = registry.path
    base_path = abspath(path_to_registry)
    registry = Pkg.TOML.parsefile(joinpath(base_path, "Registry.toml"))
    packages = registry["packages"]
    parseresult = ParsedRegistry()
    for (uuid_string, info) in packages
        uuid = UUIDs.UUID(uuid_string)
        name = info["name"]
        path = joinpath(base_path, info["path"])
        package = FullUnversionedPackage(name, uuid)
        versions = Pkg.TOML.parsefile(joinpath(path, "Versions.toml"))
        _delete_yanked_versions!(versions)
        if !isempty(versions)
            all_version_strings = collect(keys(versions))
            all_version_numbers = VersionNumber.(all_version_strings)
            i = argmax(all_version_numbers)
            max_version_string = all_version_strings[i]
            max_version_tree = versions[max_version_string]["git-tree-sha1"]
            parseresult[package] = VersionAndTree(max_version_string, max_version_tree)
        end
    end
    return parseresult
end

@inline function parse_registries!(cache, registry_list::AbstractVector{<:AbstractRegistry})
    for registry in registry_list
        if !haskey(cache, registry)
            parseresult = parse_registry(registry)
            cache[registry] = parseresult
        end
    end
    return nothing
end
