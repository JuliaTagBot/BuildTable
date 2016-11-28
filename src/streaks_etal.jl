function getstreaks(data_pokes)
  data_streaks = by(data_pokes, [:Date,:MouseID, :StreakNumber]) do df
    streakdata = DataFrame()
    for key in [:Side, :Stim, :BoxID, :RewardProb, :FlippingGamma, :Rewardsize,
      :Barrier, :Manipulation, :DayNum, :Protocol, :Gen, :ValidDay]
      streakdata[key] = df[1,key]
    end
    streakdata[:LastReward] = findlast(df[:Rewarded])
    streakdata[:NumPokes] = size(df,1)
    streakdata[:AfterLast] = size(df,1)-findlast(df[:Rewarded])
    streakdata[:StartHigh] = (df[1,:Side] == df[1,:SideHigh])
    streakdata[:EndHigh] = (df[end,:Side] !== df[end,:SideHigh]) #careful! you may be 1 poke wrong!
    streakdata[:NumRew] = count(t -> t, df[:Rewarded])
    streakdata[:NumOms] = count(t -> t, df[:Omission])
    streakdata[:TimeStart] = df[1,:TimeIn]
    streakdata[:TimeEnd] = df[end,:TimeOut]
    return streakdata
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
