type Gen
  name
  firstday
  mice
  days
end

# Name of genotype, day of start experiment, mice, valid days:
const vgat = Gen("vgat", 161205,
["LO1", "L02","L03", "L04","LO5", "L06","L07", "L08", "L09"], vcat(1:26))
