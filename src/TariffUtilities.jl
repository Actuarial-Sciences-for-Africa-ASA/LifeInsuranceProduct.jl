module TariffUtilities
using Dates, JSON, LifeInsuranceDataModel
export TariffInterface, insurance_age, get_tariff_interface, calculate!

"""
mutable struct TariffInterface
"""

mutable struct TariffInterface
  description::String
  calls::Dict{String,Any}
  calculator::Function
  parameters::Dict{String,Any}
  contract_attributes::Dict{String,Any}
  partnerroles::Vector{Int}
end

function insurance_age(dob, begindate)::Integer
  if ((Date(Dates.year(begindate), Dates.month(dob), Dates.day(dob)) - begindate).value > 183)
    Dates.year(begindate) - Dates.year(dob) - 1
  else
    Dates.year(begindate) - Dates.year(dob)
  end
end

function get_tariff_interface(interface_id::Val{T}) where {T<:Integer}
end

function calculate!(interface_id::Val{T}, ti::TariffItemSection, params::Dict{String,Any}) where {T<:Integer}
end

"""
dummy used to init calculator interface gui
"""
function get_tariff_interface(::Val{0})
  calls = JSON.parse("""
       {"calculation_target":
         {"selected": "none",
         "options": []
       
       }, "result": {"value": 0}
       }
     """)
  attributes = JSON.parse("{}")
  tariffitem_attributes = JSON.parse("{}")
  TariffInterface("",
    calls, calculate!, attributes, tariffitem_attributes, [])
end

end