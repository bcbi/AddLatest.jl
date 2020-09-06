@inline function package_matches(x::PartialUnversionedPackage,
                                 y::FullUnversionedPackage)
    x_name = x.name
    x_uuid = x.uuid
    y_name = y.name
    y_uuid = y.uuid
    if x_uuid === nothing
        return x_name == y_name
    else
        return (x_name == y_name) && (x_uuid == y_uuid)
    end
end

@inline function identify_package(x::PartialUnversionedPackage,
                                  parseresult::ParsedRegistry)
    result = Vector{FullUnversionedPackage}(undef, 0)
    for key in keys(parseresult)
        if package_matches(x, key)
            push!(result, key)
        end
    end
    return result
end

@inline function identify_package(x::PartialUnversionedPackage,
                                  cache)::FullUnversionedPackage
    x_name = x.name
    x_uuid = x.uuid
    registries = collect(keys(cache))
    num_registries = length(registries)
    matches_per_registry = Vector{Vector{FullUnversionedPackage}}(undef, num_registries)
    num_matches_per_registry = Vector{Int}(undef, num_registries)
    for i in 1:num_registries
        registry = registries[i]
        parseresult = cache[registry]
        this_registry_matches = identify_package(x, parseresult)
        matches_per_registry[i] = this_registry_matches
        num_matches_per_registry[i] = length(this_registry_matches)
    end
    package_was_found = sum(num_matches_per_registry) > 0
    ambiguity_exists = any(num_matches_per_registry .> 1)
    assert_package_found(package_was_found, x_name, x_uuid)
    assert_no_ambiguity(ambiguity_exists, x_name, x_uuid)
    indices_of_registries_with_match = findall(num_matches_per_registry .== 1)
    registries_with_match = registries[indices_of_registries_with_match]
    matches = matches_per_registry[indices_of_registries_with_match]
    num_registries_with_match = length(registries_with_match)
    first_match = only(matches[1])
    for m in matches
        assert_no_ambiguity(first_match != only(m), x_name, x_uuid)
    end
    return first_match
end
