import Pkg
import UUIDs

@inline function package_spec(versioned_package::VersionedPackage)
    name = versioned_package.name::String
    uuid = versioned_package.uuid::UUIDs.UUID
    version = versioned_package.version::String
    tree = versioned_package.tree::String
    package_spec = Pkg.API.Package(
        name = name,
        uuid = uuid,
        version = version,
    )::Pkg.Types.PackageSpec
    return package_spec
end

@inline function Pkg.Types.PackageSpec(versioned_package::VersionedPackage)
    package_spec = package_spec(versioned_package)::Pkg.Types.PackageSpec
    return package_spec
end

# Note: Pkg.API.Package == Pkg.PackageSpec

@inline function Pkg.API.Package(versioned_package::VersionedPackage)
    package_spec = package_spec(versioned_package)::Pkg.Types.PackageSpec
    return package_spec
end

@inline function Base.convert(::Type{P}, versioned_package::VersionedPackage) where P <: Pkg.Types.PackageSpec
    package_spec = package_spec(versioned_package)::Pkg.Types.PackageSpec
    return package_spec
end

# Note: Pkg.API.add == Pkg.add

@inline function Pkg.API.add(versioned_package::VersionedPackage)
    package_spec = package_spec(versioned_package)::Pkg.Types.PackageSpec
    return Pkg.API.add(package_spec)
end

@inline function Pkg.API.add(versioned_packages::AbstractVector{<:VersionedPackage})
    package_specs = package_spec.(versioned_packages)
    return Pkg.API.add(package_specs)
end

# Note: Pkg.API.pin == Pkg.pin

@inline function Pkg.API.pin(versioned_package::VersionedPackage)
    package_spec = package_spec(versioned_package)::Pkg.Types.PackageSpec
    return Pkg.API.pin(package_spec)
end

@inline function Pkg.API.pin(versioned_packages::AbstractVector{<:VersionedPackage})
    package_specs = package_spec.(versioned_packages)
    return Pkg.API.pin(package_specs)
end
