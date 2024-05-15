using Pkg
Pkg.add("LifeInsuranceProduct")
Pkg.add("Documenter")
Pkg.instantiate()
include("docs/make.jl")
Pkg.rm("Documenter")
Pkg.gc()