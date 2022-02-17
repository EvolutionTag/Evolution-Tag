function IsCommandBarButtonShown(pCommandBarButton)
	return (pCommandBarButton==0 or (ReadInt(pCommandBarButton+0x90)~=0))
end

function GetCommandBarButtonData(pCommandBarButton)
	if(pCommandBarButton==0) then  return nil end
	return ReadInt(pCommandBarButton+0x190)
end

function IsButtonOnCD(pCommandBarButton)
	if(pCommandBarButton==0) then return nil end
	local data = GetCommandBarButtonData(pCommandBarButton)
	if(data == 0) then return nil end
	return (ReadInt(data+0x6D0)==0)
end

function GetCommandBarButtonAbilityId(pCommandBarButton)
	if(pCommandBarButton==0) then return nil end
	local data = GetCommandBarButtonData(pCommandBarButton)
	if(data==0) then return nil end
	return ReadInt(data+0x4)
end

function GetCommandBarButtonOrderId(pCommandBarButton)
	if(pCommandBarButton==0) then return nil end
	local data = GetCommandBarButtonData(pCommandBarButton)
	if(data==0) then return nil end
	return ReadInt(data+0x8)
end

function GetCommandBarButtonAbility(pCommandBarButton)
	if(pCommandBarButton==0) then return nil end
	local data = GetCommandBarButtonData(pCommandBarButton)
	if(data==0) then return nil end
	return ReadInt(data+0x6d4)
end

function GetSipleAbilityTimer(pAbility)
	if(pAbility==0) then return nil end
	return pAbility+0xD0
end

function TimerGetCurrentTimeStamp(pTimer)
	if(pTimer==0) then return nil end
	local dispatcher = ReadInt(pTimer+0xC)
	if(dispatcher==0) then return nil end
	local t = ReadFloat(dispatcher+0x40)
	return t
end

function GetTimerTimeElapsed(pTimer)
	if(pTimer==0) then return nil end
	
	local endstamp = ReadFloat(pTimer+0x4)
	
	local currstamp = TimerGetCurrentTimeStamp(pTimer)
	
	return (endstamp-currstamp)
end

function GetSimpleAbilityCooldown(pAbility)
	local pTimer = pAbility+0xD0
	local id = GetAbilityId(pAbility)
	return AnyTimerGetTimeElapsed(pTimer,id)
end

function GetSimpleButtonCooldown(pCommandBarButton)
	local ability = GetCommandBarButtonAbility( pCommandBarButton)
	if(ability==0) then return nil end
	local cooldown = GetSimpleAbilityCooldown(ability)
	return cooldown
end

function GetAbilityId(pAbility)
	if(not pAbility or pAbility==0) then return nil end
	return ReadInt(pAbility+0x34)
end

function BeatifyCooldown(cool)
	if(cool>10) then
		return math.floor(cool)
	else
		return (cool-cool%0.1)
	end
end

local AHer = id2i('AHer')
local Asel = id2i('Asel')
local Asei = id2i('Asei')
local Asid = id2i('Asid')
local Asud = id2i('Asud')

local CDFuncs = {}

function GetSellAbilityCooldowns(pAbil)
	if(pAbil==0) then return nil end
	local cnt = ReadInt(pAbil+0xc8)
	local pIds = pAbil+0xcc
	local pIs = pAbil + 0x98
	local pTimers = 0x318
	local IdTable = {}
	local NumTable = {}
	local CDs = {}
	if(cnt>100) then return nil end
	for i = 0,cnt-1 do
		if(ReadInt(pIs+0x4*i)~=0) then
			IdTable[i] = ReadInt(pIds+0x4*i)
			NumTable[IdTable[i]] = i
			local pTimer = pAbil+pTimers+0x1c*i
			
			--local cdtimer = ReadInt(pTimer)
			--
			--if(cdtimer==0) then return nil end
			CDs[IdTable[i]] = TimerExGetTimeElapsed(pTimer,IdTable[i])
		end
	end
	return CDs
end

function GetSellDynamicAbilityCooldowns(pAbil)
	if(pAbil==0) then return nil end
	local cnt = ReadInt(pAbil+0xc8)
	local pIds = pAbil+0xcc
	local pIs = pAbil + 0x98
	local pTimers = 0x1c4
	local IdTable = {}
	local NumTable = {}
	local CDs = {}
	if(cnt>100) then return nil end
	for i = 0,cnt-1 do
		if(ReadInt(pIs+0x4*i)~=0) then
			IdTable[i] = ReadInt(pIds+0x4*i)
			NumTable[IdTable[i]] = i
			local pTimer = pAbil+pTimers+0x1c*i
			
			--local cdtimer = ReadInt(pTimer)
			--
			--if(cdtimer==0) then return nil end
			CDs[IdTable[i]] = TimerExGetTimeElapsed(pTimer,IdTable[i])
		end
	end
	return CDs
end

CDFuncs[AHer] = function(pAbil,Order)
	return nil
end

function GetSellAbilityCD(pAbil,Order)
	local CDs = GetSellAbilityCooldowns(pAbil)
	if(not CDs) then return -1 end
	return CDs[Order]
end

function GetSellDynamicAbilityCD(pAbil,Order)
	local CDs = GetSellDynamicAbilityCooldowns(pAbil)
	if(not CDs) then return -1 end
	return CDs[Order]
end

CDFuncs[Asel] = GetSellAbilityCD
CDFuncs[Asei] = GetSellAbilityCD
CDFuncs[Asid] = GetSellDynamicAbilityCD
CDFuncs[Asud] = GetSellDynamicAbilityCD



function GetSpecialAbilityCDFunc(AbilId)
	local cdfunc = CDFuncs[AbilId]
	return cdfunc
end

function GetAbilityCd(pAbil,Order)
	if(not pAbil or pAbil == 0) then return nil end
	local abilid = GetAbilityId(pAvil)
	local cdfunc = GetSpecialAbilityCDFunc(GetAbilityId(pAbil))
	if(not cdfunc) then
		
		return GetSimpleAbilityCooldown(pAbil)
	end
	
	return cdfunc(pAbil,Order)
end

function GetAbyButtonCD(pButton)
	if(not pButton or pButton==0) then return 0 end
	--if(not(IsButtonOnCD(pButton))) then return 0 end
	local ability = GetCommandBarButtonAbility( pButton)
	local Order = GetCommandBarButtonOrderId(pButton)
	local cooldown = GetAbilityCd(ability,Order)
	if(not cooldown) then cooldown = 0 end
	return cooldown
end

function CreateCFont(pButton)
	pFrame=CreateCSimpleFont(pButton)
	SetCSimpleRegionVertexColourEx(pFrame , 0xFF , 0xFF , 0xFF , 0xFF)
	SetCSimpleFontStringFont(pFrame , "Fonts\\FRIZQT__.TTF" , .030 , 0)
	SetCSimpleFontText(pFrame , "")
	SetFramePoint(pFrame , ANCHOR_CENTER , pButton , ANCHOR_CENTER , 0. , 0.)
	SetFrameText(pFrame,"")
	return pFrame
end

function PrintCdForCBBtn(i,j)
	local btn = GetCommandBarButton(i,j)
	if(IsCommandBarButtonShown(btn)) then
		local cd = GetAbyButtonCD(btn)
		if(cd and cd>0) then
			SetFrameText(CDFrames[1][i][j],tostring(BeatifyCooldown(cd)))
		else 
			SetFrameText(CDFrames[1][i][j],"")
		end
	else
		SetFrameText(CDFrames[1][i][j],"")
	end
end

function PrintCdForIBtn(i)
	local btn = GetItemBarButton(i)
	if(IsCommandBarButtonShown(btn)) then
		local cd = GetAbyButtonCD(btn)
		if(cd and cd>0) then
			SetFrameText(CDFrames[2][i],tostring(BeatifyCooldown(cd)))
		else 
			SetFrameText(CDFrames[2][i],"")
		end
	else
		SetFrameText(CDFrames[2][i],"")
	end
end

function testcd()
	if(not CDFrames) then
		CDFrames = {}
		local abilitytable = {}
		for i = 0,2 do
			local abiltable2 = {}
			for j = 0,3 do
				abiltable2[j] = CreateCFont(GetCommandBarButton(i,j))
			end
			abilitytable[i] = abiltable2
		end
		CDFrames[1] = abilitytable
		local itemtable = {}
		for i = 0,5 do
			itemtable[i] = CreateCFont(GetItemBarButton(i))
		end
		CDFrames[2] = itemtable
	end
	if(not cdevent) then
		cdevent = event:new(EVENT_ID_SCREEN_UPDATE,function()
			if(CDTimestamp) then
				local ctimestamp = GetTickCount64()
				if(ctimestamp-CDTimestamp<10 and not ctimestamp<0 and not CDTimestamp<0) then return end
			end
			CDTimestamp = GetTickCount64()
				
				
			if(not IsInGame()) then 
				event.disconnect(cdevent)
				cdevent = nil
				return
			end
			for i = 0,2 do
				for j = 0,3 do
					PrintCdForCBBtn(i,j)
				end
			end
			for i = 0,5 do
				PrintCdForIBtn(i)
			end
		end)
	end
end