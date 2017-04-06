type Gen{T<:AbstractArray}
  name::String
  firstday::Int64
  mice::Vector{String}
  days::T
end

# Name of genotype, day of start experiment, mice, valid days:
const vgat = Gen("vgat", 161205,
["L01", "L02","L03", "L04","L05", "L06","L07", "L08", "L09"], collect(1:100))

const vgatnew = Gen("vgat", 170000,
["L01", "L02","L03", "L04","L05", "L06","L07", "L08", "L09"], collect(1:100))

const photo = Gen("photo", 170114,
["PH1", "PH2","PH3", "PH4","PH5"], collect(1:100))

const acc = Gen("acc", 170114,
["F01", "F02","F03", "F04","F05", "F06", "F07", "F08", "F09","F10"], collect(1:100))
