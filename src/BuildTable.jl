module BuildTable
using DataFrames
using CSV
using ExcelReaders
export getpokes, getall

include("mouselist.jl")
include("load_data.jl")
include("preprocessing.jl")
include("streaks_etal.jl")

end
