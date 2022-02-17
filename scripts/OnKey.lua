local function ClickButton(button)
	if(type(button)~="number" or button==0) then
	   -- TextPrint("Unknown button")
		return
	end
	--TextPrint("Clicking button")
	thiscall2(AC.game+0x603440,button,1)
end
follow = false
local s = {}

s[VK.Q]={0,0};s[VK.W] = {0,1};s[ VK.E] = {0,2};s[VK.R] = {0,3};s[ VK.T]=0;s[VK.Y]=1;
s[VK.A] = {1,0};s[VK.S]= {1,1};s[VK.D] = {1,2};s[ VK.F] = {1,3};s[VK.G]=2;s[VK.H]=3;
s[VK.Z] = {2,0};s[VK.X]={2,1};s[VK.C]={2,2};s[VK.V] = {2,3};s[VK.B]=4;s[VK.N]=5;
s[0x20a] = function()
	if(FS()==0 or FS()==nil) then 
		SetCameraPosition(GetCameraTargetPositionX(),GetCameraTargetPositionY())
		follow = false
	else
		if(follow) then SetCameraTargetController(FS(),0,0,false)
			else SetCameraPosition(GetUnitX(FS()),GetUnitY(FS()))
		end
		follow = not follow
	end
   end
local SCKey = s
s = {}
local ALTKey = s
s = nil

function OnKey(e)
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
	local state, result = pcall(function(key,code)
		if(not IsInGame()) then return end
		--gprint(1)
		if(code~=1) then return end
		--gprint(2)
		if(IsChatBoxOpen()) then return end
		
		--gprint(3)
		local data
		if(not IsKeyPressed(VK.ALT)) then
			data = SCKey[key]
		else
			data = ALTKey[key]
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
		if(not IsSelectMode()) then CancelCurrentMode()  end
		if(not IsSelectMode()) then return  end
		--gprint(10)
		 
		local btn
		if(type(data)=="table") then
		   
			if(data[1]==nil or data[2]==nil) then return end
			btn = GetCommandBarButton(data[1],data[2]) 
		elseif(type(data)=="number") then
			btn = GetItemBarButton(data)
		elseif(type(data)=="function") then
			data(key)
		else
			   return
		end
		--gprint(11)
		ClickButton(btn)
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
		if(ClickableFrames[target] or ClickableFrames[pUbertipTarget]or ClickableFrames[TargetVF]) then
		else
			if((not IsSelectMode()) and curr~=bmode) then 
				CancelCurrentMode()
				e:cancel()
				return;
			end
			return
		end
		--gprint(12)
		curr = ReadRealMemory(ui+0x1b4)
		if(curr~=tmode) then e:cancel(); return  end
		MouseClickInstant(1)
		e:cancel()
		--gprint(13)
		if(not IsSelectMode() ) then 
			CancelCurrentMode()
		else
			return
		end
		return;
	end,key,code)
	if(state==false) then
		TextPrint(tostring(result))
		return
	end
end

