function load_session_data(filepath)
    sessiondata = DataFrame()
    errortext = ""
    preprocessingerrorflag = 0
    # Read in the data
    if ~isfile(filepath)
        errortext = "filepath does not exist"
        preprocessingerrorflag = 1
        return sessiondata, preprocessingerrorflag, errortext
    end
    sessiondata = CSV.read(filepath; nullable = false)
    return sessiondata, preprocessingerrorflag, errortext
end

function getpokes(gen_list)
    libraryname = "datalibrary.xlsx"
    foldername =  string("/Users/",ENV["USER"],"/Google Drive/Flipping/run_task/")
    dataLibrary = readxlsheet(string(foldername,libraryname), "Sheet1");

    pokestot = DataFrame()
    for gen in gen_list
        for session in 1:size(dataLibrary,1)
            filename = string("raw_data/",dataLibrary[session,2])
            if (dataLibrary[session,3] in gen.mice) && (dataLibrary[session,4] >= gen.firstday)
                filepath = string(foldername, filename)
                sessiondata, errorflag1, errortext1 = load_session_data(filepath)

                if (errorflag1 == 1)
                    println(errortext1)
                    println(filepath)
                    continue
                end
                process_session_data!(sessiondata)
                for j in 1:9
                    sessiondata[Symbol(dataLibrary[1,j])] =
                    [dataLibrary[session,j] for i in 1:size(sessiondata,1)]
                end
                sessiondata[:Gen] = gen.name
                if isempty(pokestot)
                    pokestot = copy(sessiondata)
                else
                    append!(pokestot, sessiondata)
                end
            end
        end
    end

    # Post-Processin (after getting the big database)
    pokestot[:DayNum] = copy(pokestot[:Date])
    pokestot[:ValidDay] = Array(Bool, size(pokestot,1))
    for gen in gen_list
        indexes = (pokestot[:Gen] .== gen.name)
        days = union(pokestot[indexes,:Date])
        sort!(days)
        for (ind,val) in enumerate(days)
            pokestot[(pokestot[:Date].==val) & indexes, :DayNum] = ind
        end
        pokestot[indexes,:ValidDay] = bitbroadcast(t -> t in gen.days, pokestot[indexes,:DayNum])
    end
    return pokestot
end
