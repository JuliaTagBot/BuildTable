function getstreaks(data_pokes)
  data_streaks = by(data_pokes, [:Date,:MouseID, :StreakNumber]) do df
    streakdata = DataFrame()
    for key in [:Side, :Stim, :BoxID, :RewardProb, :FlippingGamma,
      :DayNum, :Protocollo, :Gen, :ValidDay]
      streakdata[key] = df[1,key]
    end
    streakdata[:LastReward] = findlast(df[:Reward])
    streakdata[:NumPokes] = size(df,1)
    streakdata[:AfterLast] = size(df,1)-findlast(df[:Reward])
    streakdata[:StartHigh] = (df[1,:Side] == df[1,:SideHigh])
    streakdata[:EndHigh] = (df[end,:Side] !== df[end,:SideHigh]) #careful! you may be 1 poke wrong!
    streakdata[:NumRew] = count(t -> t, df[:Reward])
    streakdata[:NumOms] = count(t -> 1-t, df[:Reward])
    streakdata[:TimeStart] = df[1,:PokeIn]
    streakdata[:TimeEnd] = df[end,:PokeOut]
    return streakdata
  end
  sort!(data_streaks; cols = [:Date,:MouseID, :StreakNumber])
  data_streaks[:BlockNumber] = Array(Int64, size(data_streaks,1))
  block_number = 1
  for i = 1:size(data_streaks,1)
      if ((i == 1) || (data_streaks[i, :Protocollo] != data_streaks[i-1, :Protocollo]) ||
          (data_streaks[i, :Date] != data_streaks[i-1, :Date]) ||
          (data_streaks[i, :MouseID] != data_streaks[i-1, :MouseID]))
          block_number = 1
      else
          block_number += 1
      end
      data_streaks[i, :BlockNumber] = block_number
  end
  return data_streaks
end

function getall(data_pokes::DataFrame)
  data = Dict()
  data[:pokes] = data_pokes
  data[:streaks] = getstreaks(data_pokes)
  data[:streaks][:Travel] = vcat(data[:streaks][2:end,:TimeStart]-data[:streaks][1:(end-1),:TimeEnd],0)
  return data
end

function getall{T}(gen_list::Array{T,1})
  return getall(getpokes(gen_list))
end
