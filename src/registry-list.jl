@inline function AbstractRegistry(registry::LocalFolderRegistry)
    return registry
end

@inline function AbstractRegistry(registry::GitRegistry)
    return registry
end

@inline function AbstractRegistry(url::AbstractString)
    registry = GitRegistry(url)
    return registry
end

@inline function make_registry_list(registries::AbstractVector;
                                    include_default_registries::Bool)
    registry_list = Vector{AbstractRegistry}(undef, 0)
    for registry in registries
        push!(registry_list, AbstractRegistry(deepcopy(registry)))
    end
    default_registries = [GitRegistry("https://github.com/JuliaRegistries/General.git")]
    if include_default_registries
        for default_registry in default_registries
            push!(registry_list, AbstractRegistry(default_registry))
        end
    end
    unique!(registry_list)
    return registry_list
end
