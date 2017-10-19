type Gen{T<:AbstractArray}
  name::String
  firstday::Int64
  mice::Vector{String}
  days::T
end

# Name of genotype, day of start experiment, mice, valid days:
# Choice = 3 is coherent sides, choice = 4 is independent sides, just behaviour
const vgat = Gen("vgat", 161205,
["L01", "L02","L03", "L04","L05", "L06","L07", "L08", "L09"], collect(1:100))

const vgatnew = Gen("vgat", 170000,
["L01", "L02","L03", "L04","L05", "L06","L07", "L08", "L09"], collect(1:100))

# fiber photometry
const photo = Gen("photo", 170114,
["PH1", "PH2","PH3", "PH4","PH5"], collect(1:100))

# ACC inactivation
const acc = Gen("acc", 170114,
["F01", "F02","F03", "F04","F05", "F06", "F07", "F08", "F09","F10"], collect(1:100))

const accblind = Gen("accblind", 170114,
["B21", "B22","B23", "B24","B25", "B41", "B42", "B43", "B44","B45"], collect(1:100))

const ofc = Gen("ofc", 170615,
["E21", "E22","E23", "E24","E25", "E41", "E42", "E43", "E44","E45"], collect(1:100))

const ofcblind = Gen("ofcblind", 170615,
["P21", "P22","P23", "P24","P25", "P41", "P42", "P43", "P44","P45"], collect(1:100))


# To do: do a nice folder for all of them! Put in the hard drive!
