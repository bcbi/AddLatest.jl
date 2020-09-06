```@meta
CurrentModule = AddLatest
```

# Examples

```@example
using AddLatest
using Pkg
Pkg.activate(mktempdir(; cleanup = true)) # hide

Pkg.add(latest("Example"))
```

```@example
using AddLatest
using Pkg
using UUIDs
Pkg.activate(mktempdir(; cleanup = true)) # hide

Pkg.add(latest("Example", UUID("7876af07-990d-54b4-ab0e-23690620f79a")))
```
