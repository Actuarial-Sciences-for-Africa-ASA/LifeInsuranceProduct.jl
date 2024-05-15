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
- [run makedocs.jl](makedocs.jl)

