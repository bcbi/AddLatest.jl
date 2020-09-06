@inline function always_assert(condition::Bool, msg::String)
    if !condition
        throw(AlwaysAssertionException(msg))
    end
    return nothing
end

@inline function assert_package_found(package_was_found::Bool, name, uuid)
    if !package_was_found
        if uuid === nothing
            msg = "Package with name `$(name)` was not found."
        else
            msg = "Package with name `$(name)` and UUID `$(uuid)` was not found."
        end
        throw(PackageNotFoundException(msg))
    end
    return nothing
end

@inline function assert_no_ambiguity(ambiguity_exists::Bool, name, uuid)
    if ambiguity_exists
        if uuid === nothing
            msg = "Package with name `$(name)` is ambiguous. Disambiguate by providing the UUID."
        else
            msg = "There are multiple different packages with name `$(name)` and UUID `$(uuid)`."
        end
        throw(PackageAmbiguousException(msg))
    end
    return nothing
end

@inline function assert_no_disagreement(a::VersionAndTree, b::VersionAndTree)
    if a != b
        msg = "Two registries disagree. One registry has `$(a)`, and another registry has `$(b)`."
        throw(RegistriesDisagreeException(msg))
    end
    return nothing
end
