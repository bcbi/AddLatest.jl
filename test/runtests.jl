using AddLatest
using Test

import Documenter
import Pkg
import UUIDs

@testset "AddLatest.jl" begin
    cache_1 = RegistryParsingCache()

    @testset "Unit tests" begin
        @testset "assert.jl" begin
            @test_throws AddLatest.PackageNotFoundException AddLatest.assert_package_found(false, "PkgA", nothing)
            @test_throws AddLatest.PackageNotFoundException AddLatest.assert_package_found(false, "PkgA", UUIDs.UUID(0))
            @test_throws AddLatest.PackageAmbiguousException AddLatest.assert_no_ambiguity(true, "PkgA", nothing)
            @test_throws AddLatest.PackageAmbiguousException AddLatest.assert_no_ambiguity(true, "PkgA", UUIDs.UUID(0))
            let 
                a = AddLatest.VersionAndTree("1.0.0", "foo")
                b = AddLatest.VersionAndTree("1.0.0", "bar")
                @test_throws AddLatest.RegistriesDisagreeException AddLatest.assert_no_disagreement(a, b)
            end
        end
        @testset "registry-list.jl" begin
            @test AbstractRegistry(LocalFolderRegistry("foo")) == LocalFolderRegistry("foo")
        end
    end

    @testset "Integration tests" begin
        @testset "Integration with the Pkg API" begin
            @testset "without specifying a cache" begin
                Pkg.add(latest("Example"))
            end
            @testset "specify a cache" begin
                
                @testset "name only" begin
                    Pkg.add(latest("Example"; cache = cache_1))
                    Pkg.add(latest("Example"; cache = cache_1, registries = ["https://github.com/JuliaRegistries/General.git"]))
                    Pkg.add([latest("Example"; cache = cache_1)])
                    Pkg.add(AddLatest._convert_to_package_spec(latest("Example"; cache = cache_1)))
                    Pkg.add(Pkg.Types.PackageSpec(latest("Example"; cache = cache_1)))
                    Pkg.add(Pkg.API.Package(latest("Example"; cache = cache_1)))
                    Pkg.add(AddLatest.convert(Pkg.Types.PackageSpec, latest("Example"; cache = cache_1)))
                end
                @testset "name and uuid" begin
                    Pkg.add(latest("Example", UUIDs.UUID("7876af07-990d-54b4-ab0e-23690620f79a"); cache = cache_1))
                end
            end
        end
        @testset "test a package with a yanked version" begin 
            latest("MLJBase"; cache = cache_1)
        end
    end
    
    Base.empty!(cache_1)

    @testset "Doctests" begin
        Documenter.doctest(AddLatest)
    end
end
