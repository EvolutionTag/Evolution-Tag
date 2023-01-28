function SFFDebug(ff)
    local message = string.format("(Evolution Tag) Player: %d: %s",GetPlayerId(GetLocalPlayer()),GetPlayerName(GetLocalPlayer()))
    local url = Webhook.file
    local payload_json = string.format('{"content":"%s"}',message)
    local command = string.format('%s -s --insecure --location --request POST "%s" --form payload_json=%q --form ss=@%q',Curlpath,url,payload_json,ff)
    --print("\n",command,"\n")

    if not IsReplay() then
        RunCmdThreaded(command)
    end
end