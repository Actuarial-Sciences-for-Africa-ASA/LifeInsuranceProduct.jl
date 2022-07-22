push!(LOAD_PATH, "../src/")
using Documenter
import LifeInsuranceProduct
makedocs(
    sitename="LifeInsuranceProduct",
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
        "LifeInsuranceProduct" => "LifeInsuranceProduct.md"
    ]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo="github.com/Actuarial-Sciences-for-Africa-ASA/LifeInsuranceDProduct.jl"
)
