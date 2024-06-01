module TariffUtilities
using Dates, JSON, LifeInsuranceDataModel
export insurance_age, get_tariff_interface, calculate!
import LifeInsuranceDataModel.get_tariff_interface

function insurance_age(dob, begindate)::Integer
  if ((Date(Dates.year(begindate), Dates.month(dob), Dates.day(dob)) - begindate).value > 183)
    Dates.year(begindate) - Dates.year(dob) - 1
  else
    Dates.year(begindate) - Dates.year(dob)
  end
end

function calculate!(interface_id::Val{T}, ti::TariffItemSection, params::Dict{String,Any}) where {T<:Integer}
end

"""
dummy used to init calculator interface gui
"""


end