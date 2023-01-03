HookOnTickEx(true)


local function GetSynchronousDataHash(pData)
    if(not pData or pData<500) then return end
    local pVFTable = ReadInt(pData)
    if(not pVFTable or pVFTable<500) then return end
    local pfunc = ReadInt(pVFTable)
    if(not pfunc or pfunc<500) then return end
    return thiscall1(pfunc,pData)
    
end

local function GetFinalHash()
    return thiscall1(AC.game+0x005e20,GetEngineDataPointersWithId(0xd))
end

local EngineDataPTRS = ReadInt(GetEngineDataPointersWithId(0xd)+0x10)


local HighResolutionHashLog = {}
local prev = 0
HighResolutionHashLogger = event:new(EVENT_ID_ON_TICK,
    function() 
        local netdata = GetCNetData()
        local turn = GetTurnIdFromSyncData(netdata);
        if (turn >= prev + 5) then 
            local result = {}
            local pRandomStruct = ReadInt(AC.game+0xab73d8)
            result["random1"] = ReadRealMemory(pRandomStruct)
		    result["random2"] = ReadRealMemory(pRandomStruct+0x4)
            local hash = {}
            hash["cheat"] = IntToHex(GetSynchronousDataHash(ReadInt(EngineDataPTRS)))
            hash["net"] = IntToHex(GetSynchronousDataHash(ReadInt(EngineDataPTRS+0x8)))
            hash["rand"] = IntToHex(GetSynchronousDataHash(ReadInt(EngineDataPTRS+0xc)))
            hash["slkdata1"] = IntToHex(GetSynchronousDataHash(ReadInt(EngineDataPTRS+0x10)))
            hash["slkdata2"] = IntToHex(GetSynchronousDataHash(ReadInt(EngineDataPTRS+0x1c)))
            hash["upgradedata"] = IntToHex(GetSynchronousDataHash(ReadInt(EngineDataPTRS+0x24)))
            hash["unitcustom"] = IntToHex(GetSynchronousDataHash(ReadInt(EngineDataPTRS+0x30)))
            hash["itemcustom"] = IntToHex(GetSynchronousDataHash(ReadInt(EngineDataPTRS+0x34)))
            hash["destructablecutom"] = IntToHex(GetSynchronousDataHash(ReadInt(EngineDataPTRS+0x38)))
            hash["abilitycustom"] = IntToHex(GetSynchronousDataHash(ReadInt(EngineDataPTRS+0x40)))
            hash["buffcustom"] = IntToHex(GetSynchronousDataHash(ReadInt(EngineDataPTRS+0x44)))
            hash["upgradecustom"] = IntToHex(GetSynchronousDataHash(ReadInt(EngineDataPTRS+0x48)))
            hash["misccustom"] = IntToHex(GetSynchronousDataHash(ReadInt(EngineDataPTRS+0x4c)))
            hash["abilitydata"] = IntToHex(GetSynchronousDataHash(ReadInt(EngineDataPTRS+0x14)))
            hash["game"] = IntToHex(GetSynchronousDataHash(ReadInt(AC.pGameState)))
            hash["general"] = GetFinalHash()

            result["hash"] = hash;
            HighResolutionHashLog[turn] = result;
            HighResolutionHashLog[turn-40000] = nil
            prev = turn
        end
    end)

function LogHashes(filename) 
    persistence.store(filename, HighResolutionHashLog);
end

function LogHashesEx() 
    local plcnt = 0
	for i = 0,11 do
		if(GetPlayerController(Player(i))==MAP_CONTROL_USER and GetPlayerSlotState(Player(i))==PLAYER_SLOT_STATE_PLAYING) then
			plcnt = plcnt + 1
		end
	end

    if IsReplay() then
		return;
	end
    local file = GetTempPath()..'\\Hashes_'..tostring(turn)..tostring(GetPlayerId(GetLocalPlayer()))..'auto.lua'
    LogHashes(file)

    local name = GetPlayerName(GetLocalPlayer())

	local message = string.format("(Evolution Tag) Sending HashData, Player: %d/%d: %s",GetPlayerId(GetLocalPlayer()),plcnt,name)
	local url = Webhook.hashes
	local payload_json = string.format('{"content":"%s"}',message)
    local zfile = file..".zip"
    ZipFile(file,zfile)
    local command = string.format('%s -s --insecure --location --request POST "%s" --form payload_json=%q --form log=@%q',Curlpath,url,payload_json,zfile)

    RunCmdThreaded(command)

end
