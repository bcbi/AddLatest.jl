using AddLatest
using Test

import Documenter
import Pkg
import UUIDs

@testset "AddLatest.jl" begin
    @testset "Unit tests" begin
    end

    @testset "Integration tests" begin
        @testset "Integration with the Pkg API" begin
            @testset "without specifying a cache" begin
                Pkg.add(latest("Example"))
            end
            @testset "specify a cache" begin
                cache = RegistryParsingCache()
                @testset "name only" begin
                    Pkg.add(latest("Example"; cache = cache))
                    Pkg.add(latest("Example"; cache = cache, registries = ["https://github.com/JuliaRegistries/General.git"]))
                    Pkg.add([latest("Example"; cache = cache)])
                    Pkg.add(AddLatest._convert_to_package_spec(latest("Example"; cache = cache)))
                    Pkg.add(Pkg.Types.PackageSpec(latest("Example"; cache = cache)))
                    Pkg.add(Pkg.API.Package(latest("Example"; cache = cache)))
                    Pkg.add(AddLatest.convert(Pkg.Types.PackageSpec, latest("Example"; cache = cache)))
                end
                @testset "name and uuid" begin
                    Pkg.add(latest("Example", UUIDs.UUID("7876af07-990d-54b4-ab0e-23690620f79a"); cache = cache))
                end
            end
        end
    end

    @testset "Doctests" begin
        Documenter.doctest(AddLatest)
    end
end
