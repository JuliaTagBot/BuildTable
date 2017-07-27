function add_block_number!(dd)
    block_number = 1
    for i = 1:size(dd,1)
        if (i == 1) || (dd[i, :Protocollo] != dd[i-1, :Protocollo])
            block_number = 1
        else
            block_number += 1
        end
        dd[i, :BlockNumber] = block_number
    end
    return
end


function getstreaks(data_pokes)
    data_streaks = by(data_pokes, [:Date,:MouseID, :StreakNumber, :StimDay]) do df
        streakdata = DataFrame()
        for key in [:Side, :Stim, :BoxID, :RewardProb, :FlippingGamma,
            :DayNum, :Protocollo, :Gen, :ValidDay, :Choice, :Barrier]
            streakdata[key] = df[1,key]
        end
        streakdata[:LastReward] = findlast(df[:Reward])
        streakdata[:NumPokes] = size(df,1)
        streakdata[:AfterLast] = size(df,1)-findlast(df[:Reward])
        streakdata[:StartHigh] = (df[1,:Side] == df[1,:SideHigh])
        streakdata[:EndHigh] = (df[end,:Side] == df[end,:SideHigh]) #careful! you may be 1 poke wrong!
        streakdata[:NumRew] = count(t -> (t == 1), df[:Reward])
        streakdata[:NumOms] = count(t -> !(t == 1), df[:Reward])
        streakdata[:TimeStart] = df[1,:PokeIn]
        streakdata[:TimeEnd] = df[end,:PokeOut]
        return streakdata
    end
    sort!(data_streaks; cols = [:Date,:MouseID, :StreakNumber])
    data_streaks[:BlockNumber] = Array(Int64, size(data_streaks,1))

    by(data_streaks, [:Date,:MouseID]) do dd
        if dd[1,:Choice] == 3
            add_block_number!(dd)
        elseif dd[1,:Choice] == 4
            by(dd,:Side,add_block_number!)
        else
            dd[:BlockNumber] = dd[:StreakNumber]
        end
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

getall(gen_list, foldername) = getall(getpokes(gen_list, foldername))


# pokes[:StreakIndex] = 1
# pokes[:FromReward] = NaN
# pokes[:ToEnd] = NaN
# by(pokes, [:Date, :MouseID, :StreakNumber]) do dd
#     dd[:StreakIndex] = 1:size(dd,1)
#     dd[:FromReward] = fill(NaN,size(dd,1))
#     dd[1, :FromReward] = (dd[1, :Rewarded] == "true") ? 0. : NaN
#     for i in 2:size(dd,1)
#         if dd[i-1, :Rewarded] == "true"
#             dd[i, :FromReward] = 1.
#         else
#             dd[i, :FromReward] = dd[i-1, :FromReward]+1.
#         end
#     end
#     dd[:ToEnd] = fill(NaN,size(dd,1))
#     for i in size(dd,1):-1:1
#         dd[i,:ToEnd] = size(dd,1)-i
#         if dd[i, :Rewarded] == "true"
#             break
#         end
#     end
#     return
# end;
