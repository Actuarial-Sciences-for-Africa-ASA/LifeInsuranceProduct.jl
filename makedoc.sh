julia --project=. -e 'using Pkg; Pkg.add("Documenter"); Pkg.instantiate(); include("docs/make.jl"); Pkg.rm("Documenter");Pkg.gc()' \
&& python3 -m http.server 8080 -d docs/build \
&& gp preview $(gp url 8080)

