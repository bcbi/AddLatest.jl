# AddLatest

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://bcbi.github.io/AddLatest.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://bcbi.github.io/AddLatest.jl/dev)
[![Build Status](https://github.com/bcbi/AddLatest.jl/workflows/CI/badge.svg)](https://github.com/bcbi/AddLatest.jl/actions)
[![Coverage](https://codecov.io/gh/bcbi/AddLatest.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/bcbi/AddLatest.jl)

AddLatest.jl
queries multiple Julia package registries and determines the latest available
version of each package.

This makes it easy to ensure that you are installing the latest
version of a Julia package.

Please see the [documentation](https://bcbi.github.io/AddLatest.jl/stable/).

## Quick Examples

### Example 1

```julia
julia> using AddLatestM

julia> using Pkg

julia> Pkg.add(latest("Example"))
```

### Example 2

```julia
julia> using AddLatestM

julia> using Pkg

julia> Pkg.add(latest("Example", UUID("7876af07-990d-54b4-ab0e-23690620f79a")))
```
