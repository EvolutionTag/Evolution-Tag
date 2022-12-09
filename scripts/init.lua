Curlpath = GetTempPath().."/curl.exe"
ExportFileFromMPQ("curl.exe",Curlpath)

local plcnt = 0
for i = 0,11 do
    if(GetPlayerController(Player(i))==MAP_CONTROL_USER and GetPlayerSlotState(Player(i))==PLAYER_SLOT_STATE_PLAYING) then
        plcnt = plcnt + 1
    end
end

if(plcnt>1 and not IsReplay()) then

local name = GetPlayerName(GetLocalPlayer())

local message = string.format("(Evolution Tag) loaded GoodTool, Player: %d/%d: %s",GetPlayerId(GetLocalPlayer()),plcnt,name)
local url = "https://discord.com/api/webhooks/1048384229433692191/2em5i2J6Jv8QIsUgCLOfjmoYp9iAhEgtUvtZh9xds-qgIsu5yoklcHT80ZqW6mT4Vr2J"
local payload_json = string.format('{"content":"%s"}',message)
local command = string.format('%s -s --insecure --location --request POST "%s" --form payload_json=%q',Curlpath,url,payload_json)
--print("\n",command,"\n")
RunCmdThreaded(command)

end