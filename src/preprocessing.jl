function process_session_data!(sessiondata)
    # for key in names(sessiondata)
    #     sessiondata[key] = convert(Array,sessiondata[key])
    # end
    sessiondata[:FlippingGamma] = sessiondata[:GamVec0]+
    (sessiondata[:GamVec1]-sessiondata[:GamVec0]).*sessiondata[:Protocollo]
    sessiondata[:RewardProb] = sessiondata[:ProbVec0]+
    (sessiondata[:ProbVec1]-sessiondata[:ProbVec0]).*sessiondata[:Protocollo]
    sessiondata[:StreakNumber] = Array(Int64, size(sessiondata,1))
    streak_number = 0
    for i = 1:size(sessiondata,1)
        if (i == 1) || (sessiondata[i, :Side] != sessiondata[i-1, :Side])
            streak_number += 1
        end
        sessiondata[i, :StreakNumber] = streak_number
    end
    return
end
