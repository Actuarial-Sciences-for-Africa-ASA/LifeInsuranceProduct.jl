# LifeInsuranceProduct.jl

![Beware, Work In Progress](docs/src/assets/wip.png)

This project is by now just a pilot to investigate possible interface designs for
LifeInsuranceProducts that should be pluggable into [our project LifeInsuranceContracts](https://github.com/Actuarial-Sciences-for-Africa-ASA/LifeInsuranceContracts.jl) 


It provides a very simple calculator API example providing 
- functions leveraging [the LifeContingencies library](https://github.com/JuliaActuary/LifeContingencies.jl)
comprising computation of
    - present value and 
    - net premium with varying payment frequencies where applicable for
    - annuity, lifelong and temporary
    - Life Risk 
    - Two Life Risk
- as well as function meta data in JSON format [usable for calling these functions from HTML forms in a life insurance web app](https://github.com/Actuarial-Sciences-for-Africa-ASA/GenieBuiltLifeProto)

[LifeInsuranceProduct](src/LifeInsuranceProduct.jl) bundles and dispatches calls for tariff metadata and computations as of now to
    - [SingleLifeRiskTariff](src/SingleLifeRiskTariff.jl)
    - [JointLifeRiskTariff](src/JointLifeRiskTariff.jl)
    - [PensionTariff](src/PensionTariff.jl)
    - [ProfitParticipationTariff](src/ProfitParticipationTariff.jl)

To explore usage of this package
use the debugger on these scripts:
  - [SingleLifeRiskTariff](debugcalcSLR.jl)
  - [JointLifeRiskTariff](debugcalcSLR.jl)
  - [PensionTariff](debugcalcPEN.jl)

To populate the data base use this 
 - [script](testAPI.jl) or this
 - [notebook](testAPI.ipynb) 
  
To generate documentation 
- [exec makedocs.jl in Julia REPL](makedocs.jl)
- View generated docs using the link for 8080 under the ports tab 

# Usage
A web app using this module for persistence is being built at https://github.com/Actuarial-Sciences-for-Africa-ASA/GenieBuiltLifeProto.jl

## Next Steps

Click the button below to start a new development environment:

The gitpod workspace uses a Docker a public image: [michaelfliegner/gitpodpgijulia](https://hub.docker.com/repository/docker/michaelfliegner/gitpodpgijulia/general)

[The Dockerfile for this image resides here](https://github.com/Actuarial-Sciences-for-Africa-ASA/gitpod-pg-ijulia-Dockerfile)

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/?autostart=true#https://github.com/Actuarial-Sciences-for-Africa-ASA/LifeInsuranceProduct.jl) 

[On startup vscode will open this jupyter notebook:](testAPI.ipynb)




