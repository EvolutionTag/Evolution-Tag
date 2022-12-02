function DumpData(name)
	
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
	

	local function GetMapName()
		local pgame = AC.pGameState
		if(pgame<500) then return end
		local game = ReadInt(pgame)
		if(game<500) then return end
		local mapsetup = ReadInt(game+0x30)
		if(mapsetup<500) then return end
		local pName = mapsetup+4;
		return ConvertJString(pName)
	end

	local function GetMapFile()
		local pMap = AC.game + 0xaae788
		local pData = ReadInt(pMap)
		if(pData<500) then return nil end
		return Cstring2LuaString(pData+8)
	end

	function GetPlayerHashReal(preal)
		local pfunc = AC.game+0x40feb0
		return thiscall1(pfunc,preal)
	end

	function GetPlayerHash(p)
		local preal = ConvertHandle(p)
		return GetPlayerHashReal(preal)
	end


	local gamestate = ReadRealMemory(ReadRealMemory(AC.pGameState) + 0x1C)
	if(not gamestate or gamestate == 0) then
	-- Log('Handle table not found')
	 return
	end
	local len = ReadInt(gamestate+0x198)
	local handletable = ReadInt(gamestate+0x19C)
	if(not handletable or handletable == 0) then
	-- Log('Handle table not found 2')
	 return
	end

	local FuncTable = {}

	FuncTable[GetIdFromName('CUnit')] = function(u,handle)
		--Log("unit has id: ",handleid)
		--gprint(i2id(GetUnitTypeId(handleid)))
		handle["type"] = "unit"
		handle["id"] = i2id(GetUnitTypeId(u))
		handle["hp"] = GetWidgetLife(u)
		handle["hidden"] = IsUnitHidden(u)
		handle["mp"] = GetUnitState(u,UNIT_STATE_MANA)
		handle["mmp"] = GetUnitState(u,UNIT_STATE_MAX_MANA)
		handle["mhp"] = GetUnitState(u,UNIT_STATE_MAX_LIFE)
		handle["alive"] = GetWidgetLife(u)>0.4
		handle["x"] = GetUnitX(u)
		handle["y"] = GetUnitY(u)
		handle["userdata"] = GetUnitUserData(u)
		handle["accuire"] = GetUnitAcquireRange(u)
		handle["name"] = GetUnitName(u)
		handle["facing"] = GetUnitFacing(u)
		handle["MS"] = GetUnitMoveSpeed(u)
		local orderid =  GetUnitCurrentOrder(u)
		if(orderid~=0) then
			handle["orderid"] = orderid
			handle["order"] = OrderId2String(orderid)
		end
		handle["TS"] = GetUnitTurnSpeed(u)
		handle["PropWindow"] = GetUnitPropWindow(u)
		handle["Fly Height"] = GetUnitFlyHeight(u)
		handle["owner"] = GetOwningPlayer(u)
		handle["ownerid"] = GetPlayerId(GetOwningPlayer(u))
		local AHer = GetUnitAbility(u,'AHer')
		if(AHer~=0) then
			local hero = {}
			hero["str"] = GetHeroStr(u,true)
			hero["agi"] = GetHeroAgi(u,true)
			hero["int"] = GetHeroInt(u,true)
			hero["XP"] = GetHeroXP(u)
			hero["SP"] = GetHeroSkillPoints(u)
			hero["level"] = GetHeroLevel(u)
			handle["hero"] = hero
		end
		local invsize = UnitInventorySize(u)
		
		if(invsize>0) then
			handle["inventorysize"] = UnitInventorySize(u)
			local inventory = {}
			for i = 0, invsize do
				local itemid = UnitItemInSlot(u,i)
				if(itemid~=0) then
					local item = {}
					item["id"] = i2id(GetItemTypeId(itemid))
					item["handle"] = itemid
					inventory[i] = item
				end
			end
			handle["inventory"] = inventory
		end
		local abilities = {}
		local abilcnt = 0
		for i in UnitAbilities(u) do
			local ability = {}
			ability["ptr"] = IntToHex(i.ptr)
			ability["id"] = i2id(ReadInt(i.ptr+0x34))
			abilcnt = abilcnt + 1
			table.insert(abilities,ability)
		end
		abilities["cnt"] = abilcnt
		handle["abilities"] = abilities
		local inventory = {}
		
		--gprint(handleid)
	end
	FuncTable[GetIdFromName('CItem')] = function(i,handle)
		--Log("unit has id: ",handleid)
		--gprint(i2id(GetUnitTypeId(handleid)))
		handle["type"] = "item"
		handle["x"] = GetItemX(i)
		handle["y"] = GetItemY(i)
		handle["player"] = GetItemPlayer(i)
		handle["playerid"] = GetPlayerId(GetItemPlayer(i))
		handle["typeid"] = i2id(GetItemTypeId(i))
		handle["invul"] =IsItemInvulnerable(i)
		handle["visible"] =IsItemVisible(i)
		handle["owned"] =IsItemOwned(i)
		handle["powerup"] =IsItemPowerup(i)
		handle["pawnable"] =IsItemPawnable(i)
		handle["level"] =GetItemLevel(i)
		handle["name"] =GetItemName(i)
		handle["charges"] =GetItemCharges(i)
		handle["userdata"] =GetItemUserData(i)
		--gprint(handleid)
	end


	FuncTable[GetIdFromName('CTimerWar3')] = function(t,handle)
		--Log("unit has id: ",handleid)
		--gprint(i2id(GetUnitTypeId(handleid)))
		handle["type"] = "timer"
		handle["timeout"] = TimerGetTimeout(t)
		handle["elapsed"] = TimerGetElapsed(t)
		handle["remaining"] = TimerGetRemaining(t)
		--gprint(handleid)
	end
	FuncTable[GetIdFromName('CMapLocation')] = function(l,handle)
		--Log("unit has id: ",handleid)
		--gprint(i2id(GetUnitTypeId(handleid)))
		handle["type"] = "location"
		handle["x"] = GetLocationX(l)
		handle["y"] = GetLocationY(l)
		handle["z"] = GetLocationZ(l)
		--gprint(handleid)
	end

	FuncTable[GetIdFromName('CPlayerWar3')] = function(p,handle)
		--Log("unit has id: ",handleid)
		--gprint(i2id(GetUnitTypeId(handleid)))
		handle["type"] = "Player"
		handle["gold"] = GetPlayerState(p,PLAYER_STATE_RESOURCE_GOLD)
		handle["lumber"] = GetPlayerState(p,PLAYER_STATE_RESOURCE_LUMBER)
		handle["hero tokens"] = GetPlayerState(p,PLAYER_STATE_RESOURCE_HERO_TOKENS)
		handle["foodcap"] = GetPlayerState(p,PLAYER_STATE_RESOURCE_FOOD_CAP)
		handle["food used"] = GetPlayerState(p,PLAYER_STATE_RESOURCE_FOOD_USED)
		handle["food cap celling"] = GetPlayerState(p,PLAYER_STATE_FOOD_CAP_CEILING)
		handle["allied victory"] = GetPlayerState(p,PLAYER_STATE_ALLIED_VICTORY)
		handle["placed"] = GetPlayerState(p,PLAYER_STATE_PLACED)
		handle["obs on death"] = GetPlayerState(p,PLAYER_STATE_OBSERVER_ON_DEATH)
		handle["observer"] = GetPlayerState(p,PLAYER_STATE_OBSERVER)
		handle["gold upkeep"] = GetPlayerState(p,PLAYER_STATE_GOLD_UPKEEP_RATE)
		handle["lumber upkeep"] = GetPlayerState(p,PLAYER_STATE_LUMBER_UPKEEP_RATE)
		handle["gold gathered"] = GetPlayerState(p,PLAYER_STATE_GOLD_GATHERED)
		handle["lumber gathered"] = GetPlayerState(p,PLAYER_STATE_LUMBER_GATHERED)
		handle["playerid"] = GetPlayerId(p)
		handle["team"] = GetPlayerTeam(p)
		handle["color"] = GetPlayerColor(p)
		handle["controller"] = GetPlayerController(p)
		handle["slotstate"] = GetPlayerSlotState(p)
		handle["name"] = GetPlayerName(p)
		handle["hash"] = GetPlayerHash(p)
		--gprint(handleid)
	end

	local result = {}

	local data = {}
	local counts = {}

	local handles = {}
	data["Handle Count"] = len
	Log('Dumping handles, cnt: ',len)
	for i = 0,len do
		local ptr = ReadInt(handletable+i*0xC+0x4)
		local handleid = i+0x100000
		if(not ptr or ptr ==0) then
		--	Log('handle with id: ',IntToHex(handleid),'is unitialized')
		else
		--	Log('handle with id: ',IntToHex(handleid),'is initialized')
			local handle = {}
			handle["ptr"] = IntToHex(ptr)
			--Log('ptr: ',ptr)
			local VFTable = ReadInt(ptr)
			local baseid = GetIdFromVtable(VFTable-AC.game)
			handle["handleid"] = handleid
			handle["baseid"] = baseid
			local typecnt = counts[baseid]
			if(not typecnt) then
				typecnt = 0
			end
			counts[baseid] = typecnt + 1
			handles[handleid] = handle
			local specfunc = FuncTable[baseid]
			if(specfunc) then
				local r,s = pcall(specfunc,handleid,handle)
				if(not r) then
					gprint(s)
				end
			end
		end
	end

	result["handles"] = handles
	local tcounts = {}
	for id,cnt in pairs(counts) do
		tcounts[GetNameFromId(id)] = cnt
	end


	tcounts["All"] = len

	Log('Dumping states')
	local states = {}
	states["fogmaskenabled"] = IsFogMaskEnabled()
	states["fogenabled"] = IsFogEnabled()
	states["gamespeed"] = GetGameSpeed()
	states["difficulty"] = GetGameDifficulty()
	states["Time Of a day"] = GetFloatGameState(GAME_STATE_TIME_OF_DAY)
	states["Mapname"] = GetMapName()
	states["MapFile"] = GetMapFile()
	data["states"] = states
	data["counts"] = tcounts
	Log('Dumping camera')
	local camera = {}
	camera["boundminx"] = GetCameraBoundMinX()
	camera["boundminy"] = GetCameraBoundMinY()
	camera["boundmaxx"] = GetCameraBoundMaxX()
	camera["boundmaxy"] = GetCameraBoundMaxY()
	camera["cameratargetposx"] = GetCameraTargetPositionX()
	camera["cameratargetposy"] = GetCameraTargetPositionY()
	camera["cameratargetposz"] = GetCameraTargetPositionZ()
	camera["cameraeyeposx"] = GetCameraEyePositionX()
	camera["cameraeyeposy"] = GetCameraEyePositionY()
	camera["cameraeyeposz"] = GetCameraEyePositionZ()
	camera["CAMERA_FIELD_TARGET_DISTANCE"] = GetCameraField(CAMERA_FIELD_TARGET_DISTANCE)
	camera["CAMERA_FIELD_FARZ"] = GetCameraField(CAMERA_FIELD_FARZ)
	camera["CAMERA_FIELD_ANGLE_OF_ATTACK"] = GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK)
	camera["CAMERA_FIELD_FIELD_OF_VIEW"] = GetCameraField(CAMERA_FIELD_FIELD_OF_VIEW)
	camera["CAMERA_FIELD_ROTATION"] = GetCameraField(CAMERA_FIELD_ROTATION)
	camera["CAMERA_FIELD_ZOFFSET"] = GetCameraField(CAMERA_FIELD_ZOFFSET)
	Log('Dumping hashes')
	data["camera"] = camera
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
	data["hash"] = hash
	local pRandomStruct = ReadInt(AC.game+0xab73d8)
	if(pRandomStruct>500) then
		local random = {}
		random["key1"] = ReadRealMemory(pRandomStruct)
		random["key2"] = ReadRealMemory(pRandomStruct+0x4)
		result.random = random
	end
	local netdata = GetCNetData()
	local turns = {}

	Log('Dumping turndata')
	turns['sync'] = GetTurnIdFromSyncData(netdata)
	turns['idle'] = GetIdleTurnIdFromSyncData(netdata)
	data['turns'] = turns


	result["data"] = data
	Log('Success created dump')
	persistence.store(name, result);
	Log('Dump was stored to file')
end

function DumpSimple()
    local CNet = GetCNetData()
    local turn = GetTurnIdFromSyncData(CNet)
    DumpData('GoodTool\\Logs\\DUMP_'..tostring(turn)..tostring(GetPlayerId(GetLocalPlayer()))..' '..'auto'..'.lua')
end
function DumpSimpleLogged() 
	local CNet = GetCNetData()
    local turn = GetTurnIdFromSyncData(CNet)
	local file = 'GoodTool\\Logs\\DUMP_'..tostring(turn)..tostring(GetPlayerId(GetLocalPlayer()))..' '..'auto'..'.lua'
    DumpData(file)


	local plcnt = 0
	for i = 0,11 do
		if(GetPlayerController(Player(i))==MAP_CONTROL_USER and GetPlayerSlotState(Player(i))==PLAYER_SLOT_STATE_PLAYING) then
			plcnt = plcnt + 1
		end
	end

	local name = GetPlayerName(GetLocalPlayer())

	local message = string.format("(Evolution Tag) Warning! Desync Happened, Player: %d/%d: %s",GetPlayerId(GetLocalPlayer()),plcnt,name)
	local url = "https://discord.com/api/webhooks/1046980074336944128/g9v1swVNqWGwsH_1s2CzuuQKGGODie5cwt_-VNoG8NuZxi5fmC7ar8tMz_oKSGKyvstt"
	local payload_json = string.format('{"content":"%s"}',message)
	local freplay = "GoodTool\\LastReplay.w3g"
	local netdata = GetCNetData()
		thiscall2(AC.game+0x53e360,netdata,freplay) --save replay
	local command = string.format('%s -s --insecure --location --request POST "%s" --form payload_json=%q --form log=@%q --form replay=@%q',Curlpath,url,payload_json,file,freplay)
	--print("\n",command,"\n")
	RunCmdThreaded(command)
end
function DumpTimed(time,name)
	local time = time
	local name = name
	local CNet = GetCNetData()
	local e;
	local r,s = pcall(function() HookOnTick(true) end)
	if(not r) then
		gprint(s)
	end
	local function OnTick()
		local turn = GetTurnIdFromSyncData(CNet)
		if(turn >=time) then
			if(not name) then
				name = ""
			end
			DumpData('GoodTool\\Logs\\DUMP_'..tostring(turn)..' '..tostring(name)..'.lua')
			event.disconnect(e)
		end
	end

	e = event:new(EVENT_ID_ON_TICK,function() OnTick() end)
end


function DumpTimedPeriodic(begin,endt,period,name)
	local time = begin
	local name = name
	local endt = endt
	local period = period
	local name = name
	local CNet = GetCNetData()
	local e;
	local r,s = pcall(function() HookOnTick(true) end)
	if(not r) then
		gprint(s)
	end
	local function OnTick()
		local turn = GetTurnIdFromSyncData(CNet)
		if(turn >=time) then
			if(not name) then
				name = ""
			end
			DumpData('GoodTool\\Logs\\DUMP_'..tostring(turn)..' '..tostring(name)..'.lua')
			if(time>endt) then
				event.disconnect(e)
			end
			time = turn+period
		end
	end

	e = event:new(EVENT_ID_ON_TICK,function() OnTick() end)
end
