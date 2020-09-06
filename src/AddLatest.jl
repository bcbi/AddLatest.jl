module AddLatest

import LibGit2
import Pkg
import UUIDs

export AbstractRegistry
export GitRegistry
export LocalFolderRegistry
export RegistryParsingCache
export VersionedPackage
export latest

include("types.jl")

include("assert.jl")
include("git-registry.jl")
include("identify-package.jl")
include("latest.jl")
include("parse-registry.jl")
include("pkg-api.jl")
include("registry-list.jl")

end # end module AddLatest
