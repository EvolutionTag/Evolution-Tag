SmartCast = {}

local function ClickButton(button)
	if(type(button)~="number" or button==0) then
	   -- TextPrint("Unknown button")
		return
	end
	--TextPrint("Clicking button")
	thiscall2(AC.game+0x603440,button,1)
end
SmartCast.follow = false
local s = {}

SmartCast.PressedKeys = {}

local function AbilityButton(x,y) 
	local dat = {}
	dat.type = "ability"
	dat.x = x
	dat.y = y
	return dat
end

local function InventoryButton(n)
	local dat = {}
	dat.type = "inventory"
	dat.n = n
	return dat
end


s[VK.Q]=AbilityButton(0,0)
s[VK.W]=AbilityButton(0,1)
s[VK.E]=AbilityButton(0,2)
s[VK.R]=AbilityButton(0,3)
s[VK.A]=AbilityButton(1,0)
s[VK.S]=AbilityButton(1,1)
s[VK.D]=AbilityButton(1,2)
s[VK.F]=AbilityButton(1,3)
s[VK.Z]=AbilityButton(2,0)
s[VK.X]=AbilityButton(2,1)
s[VK.C]=AbilityButton(2,2)
s[VK.V]=AbilityButton(2,3)
s[VK.T]=InventoryButton(0)
s[VK.Y]=InventoryButton(1)
s[VK.G]=InventoryButton(2)
s[VK.H]=InventoryButton(3)
s[VK.B]=InventoryButton(4)
s[VK.N]=InventoryButton(5)

local SCKey = s
s = {}
local ALTKey = s
s = nil

local scheme = {}
SmartCast.scheme = scheme

local default = {}
default.SCKey = SCKey
default.ALTKey = ALTKey

scheme.default = default

local features = {}
scheme.features = features

features.SCKey = {}
features.ALTKey = {}

SmartCast.SCKey = SCKey
SmartCast.ALTKey = ALTKey

features.SCKey[0x20a] = function()
	local targ = RRS()
	if(not targ or targ == 0) then
		targ = FS()
	end
	if(not targ or targ == 0) then 
		SetCameraPosition(GetCameraTargetPositionX(),GetCameraTargetPositionY())
		SmartCast.follow = false
	else
		
		if(not SmartCast.follow) then SetCameraTargetController(targ,0,0,false)
			else SetCameraPosition(GetUnitX(targ),GetUnitY(targ))
		end
		SmartCast.follow = not follow
	end
end


features.SCKey[273] = function()
	if(IsKeyPressed(VK.CTRL)) then
		SetCameraField(CAMERA_FIELD_TARGET_DISTANCE,GetCameraField(CAMERA_FIELD_TARGET_DISTANCE)+100,0)
		return false
	end
end
features.SCKey[272] = function()
	if(IsKeyPressed(VK.CTRL)) then
		SetCameraField(CAMERA_FIELD_TARGET_DISTANCE,GetCameraField(CAMERA_FIELD_TARGET_DISTANCE)-100,0)
		return false
	end
end

local rotation = 0
local attack_angle = -90
features.ALTKey[273] = function()
	if(IsKeyPressed(VK.CTRL)) then
		attack_angle = attack_angle - 1
		SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK,attack_angle,0)
	else
		rotation = rotation - 1
		SetCameraField(CAMERA_FIELD_ROTATION,rotation,0)
	end
	return false
end
features.ALTKey[272] = function()
	if(IsKeyPressed(VK.CTRL)) then
		attack_angle = attack_angle + 1
		SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK,attack_angle,0)
	else
		rotation = rotation + 1
		SetCameraField(CAMERA_FIELD_ROTATION,rotation,0)
	end
	return false
end

local VirtualEvent = {}
SmartCast.VirtualEvent = VirtualEvent

VirtualEvent.cancel = function() end

VirtualEvent.__index = VirtualEvent

local SafeToCancel = {}
SmartCast.SafeToCancel = SafeToCancel

SafeToCancel[0x935DEC] = true --TargetMode
SafeToCancel[0x941748] = true --BuildMode
SafeToCancel[0x934B58] = true --SignalMode
SafeToCancel[0x934AF8] = true --DragSelectMode
SafeToCancel[0x934B28] = true --DragScrollMode

SmartCast.CancelCurrentModeSafe = function()
	local pGameUi = GetGameUI(0,0)
	if(not pGameUi or pGameUi==0) then
		return
	end
	local pMode = ReadInt(pGameUi+0x1b4)
	if(not pMode or pMode==0) then
		return
	end
	
	
	if(SmartCast.SafeToCancel[ReadInt(pMode)-AC.game]) then
		CancelCurrentMode()
	end
end

local function RunKey(e)
	return SmartCast.OnKey(e)
end


local function ReRunKey()
	return SmartCast.ProcessKeys()
end

SmartCast.RunKey = RunKey
SmartCast.ReRunKey = ReRunKey

SmartCast.PressedKey = function(key,code,e)
	if(not IsInGame()) then return end
	--gprint(1)
	if(not code or code==0) then return end
	--gprint(2)
	if(IsChatBoxOpen()) then return end
	
	--gprint(3)
	local data
	local basescheme = SmartCast.scheme.default
	if(Settings.get("HotKey_CustomScheme")) then
		basescheme = SmartCast.scheme.custom
		if(not basescheme) then
			basescheme = SmartCast.scheme.features
		end
	end
	if(not basescheme) then
		return
	end
	if(not IsKeyPressed(VK.ALT)) then
		data = basescheme.SCKey[key] or SmartCast.scheme.features.SCKey[key]
	else
		data = basescheme.ALTKey[key] or SmartCast.scheme.features.ALTKey[key]
	end
	--gprint(4)
	if(data==nil) then return end
	--gprint(5)
	--gprint(6)
	local u = FS()
	if(not u or u == 0 or GetUnitTypeId(u)==0) then return end
	--gprint(7)
	local ui = GetGameUI(0,0)
	local inmenu = ReadRealMemory(ui+0x25C)==1
	if(inmenu) then return; end
	--gprint(8)
	local curr = ReadRealMemory(ui+0x1b4)
	local bmode = ReadRealMemory(ui+0x220)
	local tmode = ReadRealMemory(ui+0x210)
	local smode = ReadRealMemory(ui+0x214)
	if(not IsSelectMode() and (curr ~= bmode)) then SmartCast.CancelCurrentModeSafe()  end
	curr = ReadRealMemory(ui+0x1b4)
	if(not IsSelectMode() and (curr ~= bmode)) then return  end
	--gprint(10)
	 
	local btn
	if(type(data)=="function") then
		pcall(data,key)
		e:cancel()
		return;
	else
		if(data.type=="ability") then
			btn = GetCommandBarButton(data.x,data.y) 
		elseif (data.type=="inventory") then
			btn = GetItemBarButton(data.n)
		else
			return;
		end
	end

	--gprint(11)
	ClickButton(btn)
	e:cancel()
	local target = FindCLayerUnderCursor()
	local pUberTip = ReadRealMemory(GetGameUI(0,0)+0x1cc)
	local pUbertipTarget = 0
	--Log("Ubertip: ",IntToHex(pUberTip))
	if(pUberTip and pUberTip~=0) then
		--Log("Checking ubertip")
		if(ReadInt(pUberTip+0x90)~=0) then
			pUbertipTarget = ReadInt(pUberTip+0x124)
			--Log(IntToHex(pUbertipTarget))
		end
		
	else
		--Log('Incorrect UberTip: ', pUberTip)
	end
	local TargetVF = 0
	if(pUbertipTarget and pUbertipTarget~=0) then
		TargetVF = ReadInt(pUbertipTarget)
	end
	--Log(ClickableFrames[target] , ClickableFrames[pUbertipTarget], IntToHex(target), IntToHex(pUbertipTarget))
	--gprint(ClickableFrames[target] , ClickableFrames[pUbertipTarget] , ClickableFrames[TargetVF])
	curr = ReadRealMemory(ui+0x1b4)
	if(ClickableFrames[target] or ClickableFrames[pUbertipTarget] or ClickableFrames[TargetVF]) then
	else
		if((not IsSelectMode()) and curr~=bmode) then 
			SmartCast.CancelCurrentModeSafe()
			return;
		end
		if(curr == bmode) then
			return;
		end
		return
	end
	if(not Settings.get("HotKey_QuickCast")) then
		e:cancel()
		return;
	end
	--gprint(12)
	curr = ReadRealMemory(ui+0x1b4)
	if(curr~=tmode) then return  end
	MouseClickInstant(1)
	e:cancel()
	--gprint(13)
	if(not IsSelectMode() ) then 
		SmartCast.CancelCurrentModeSafe()
	else
		return
	end
	return;
end

SmartCast.ProcessKeys = function()
	--gprint(1)
	ClickableFrames = {}
	ClickableFrames[GetUIWorldFrameWar3()] = true
	for i = 0,5 do
		ClickableFrames[GetItemBarButton(i)] = true
	end
	ClickableFrames[GetUIPortrait()] = true
	for i = 0,7 do
		ClickableFrames[GetHeroBarButton(i)] = true
	end
	ClickableFrames[GetUIMinimap()] = true
	ClickableFrames[AC.game+0x93E83C] = true
	ClickableFrames[0] = nil
	local e = VirtualEvent
	for key,mode in pairs(SmartCast.PressedKeys) do
		--gprint(key)
		local r,s = pcall(SmartCast.PressedKey,key,mode,e)
		if(not r) then
			gprint(r)
		end
	end
end

SmartCast.OnKey = function(e)

	--gprint(0)
	ClickableFrames = {}
	ClickableFrames[GetUIWorldFrameWar3()] = true
	for i = 0,5 do
		ClickableFrames[GetItemBarButton(i)] = true
	end
	ClickableFrames[GetUIPortrait()] = true
	for i = 0,7 do
		ClickableFrames[GetHeroBarButton(i)] = true
	end
	ClickableFrames[GetUIMinimap()] = true
	ClickableFrames[AC.game+0x93E83C] = true
	ClickableFrames[0] = nil
	local key = e:getData(EVENT_DATA_ID_INPUTED_KEY)
	local code = e:getData(EVENT_DATA_ID_INPUTED_KEY_MODE)
	local state, result = pcall(SmartCast.PressedKey,key,code,e)
	if( IsInGame() and not IsChatBoxOpen() and SmartCast.PressedKeys[key]~=2) then
		if( code ==1) then
			if(SmartCast.PressedKeys[key]) then
				SmartCast.PressedKeys[key] = 1
			else
				SmartCast.PressedKeys[key] = 0
			end
		else
			SmartCast.PressedKeys[key] = nil
		end
	end
	if(state==false) then
		TextPrint(tostring(result))
		return
	end

end

SmartCast.mode = false

local function switch(mode)
	if(mode==nil) then
		mode = not SmartCast.mode
	end

	if(mode==SmartCast.mode) then
		return
	end

	SmartCast.mode = mode

	if(mode) then
		SmartCast.keyevent = event:new(EVENT_ID_KEY_INPUT, SmartCast.RunKey)
		SmartCast.periodickey = event:new(EVENT_ID_SCREEN_UPDATE,SmartCast.ReRunKey)
	else

		if(SmartCast.keyevent) then
			event.disconnect(SmartCast.keyevent)
			SmartCast.keyevent = nil
		end
		if(SmartCast.periodickey) then
			event.disconnect(SmartCast.periodickey)
			SmartCast.periodickey = nil
		end
	end
	
end

SmartCast.switch = switch

function SmartCast.EnableCustomScheme(mode)
	if(mode==true) then
		local r,s = pcall(function()
			SmartCast.scheme.custom = persistence.load("GoodTool/settings/scheme.lua")
		end)
		if(not r) then
			gprint(s)
		end
	else
		SmartCast.scheme.custom = nil
	end
end

Settings.addReact("HotKey",function(mode) SmartCast.switch(mode) end)
Settings.addReact("HotKey_CustomScheme",function(mode) SmartCast.EnableCustomScheme(mode) end)