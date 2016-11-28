function process_session_data!(sessiondata)
    for key in names(sessiondata)
        sessiondata[key] = convert(Array,datapoke[key])
    end
    sessiondata[:FlippingGamma] = sessiondata[:GamVec0]+
    (sessiondata[:GamVec1]-sessiondata[:GamVec0]).*sessiondata[:Protocollo]
    sessiondata[:RewardProb] = sessiondata[:ProbVec0]+
    (sessiondata[:ProbVec1]-sessiondata[:ProbVec0]).*sessiondata[:Protocollo]
    return
end
