scinited = false
showcimmandbar = false
function initsc()
    if(scinited) then return end
    scinited = true
    function ClickButton(button)
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
    SCKey = s
    s = {}
    ALTKey = s
    s = nil
    function OnKey(key,code)
        local state, result = pcall(function(key,code)
            if(IsChatBoxOpen()) then return true end
            if(code~=1) then return true end
           -- TextPrint("OnKey, id: "..IntToHex(key))
            if(not IsInGame()) then
                return true
            end
			local data
			if(not IsKeyPressed(VK.ALT)) then
				data = SCKey[key]
			else
				data = ALTKey[key]
			end
            if(data==nil) then return true end
            if(type(FS())~="number" or FS()==0) then
                return true
            end
            local tip = GetUnitTypeId(FS())
            if(type(tip)~="number" or tip==0) then
                return true
            end
            local ui = GetGameUI(0,0)
            local inmenu = ReadRealMemory(ui+0x25C)==1
			if(inmenu) then
				return true;
			end
            local uidisabled = ReadRealMemory(ui+0x258)==1
            if(inmenu or uidisabled) then return true end
            local curr = ReadRealMemory(ui+0x1b4)
            local bmode = ReadRealMemory(ui+0x220)
            local tmode = ReadRealMemory(ui+0x210)
            local smode = ReadRealMemory(ui+0x214)
            if(not IsSelectMode()) then CancelCurrentMode()  end
            curr = ReadRealMemory(ui+0x1b4)
            if(curr~=smode) then return true  end
             
            local btn
            if(type(data)=="table") then
               
                if(data[1]==nil or data[2]==nil) then return true end
                btn = GetCommandBarButton(data[1],data[2]) 
            elseif(type(data)=="number") then
                btn = GetItemBarButton(data)
            elseif(type(data)=="function") then
                data(key)
            else
                   return true
            end
            
            ClickButton(btn)
			local target = FindCLayerUnderCursor()
			if(target==GetUIMinimap() or target==GetUIPortrait() or target == GetUIWorldFrameWar3()) then
            else
				curr = ReadRealMemory(ui+0x1b4)
				if((not IsSelectMode()) and curr~=bmode) then 
					CancelCurrentMode()
				end
                return true
            end
            curr = ReadRealMemory(ui+0x1b4)
            if(curr~=tmode) then return false  end
            MouseClickInstant(1)
            curr = ReadRealMemory(ui+0x1b4)
            if(not IsSelectMode() ) then 
                CancelCurrentMode()
            else
                return false
            end
            return false 
        end,key,code)
        if(state==false) then
            TextPrint(tostring(result))
            return true
        end

        return result
    end
	if(not keyboardhooked) then 
		HookKeyboard(true)
		keyboardhooked = true
	end
end

function initui()
    local pCommandFrame
    local command_frame_delta_y= - 0.038
    local command_frame_start_y= - 0.145
    local item_frame_start_y= - 0.16
    local item_frame_delta_y= - 0.034
    local pItemFrame
    local pUIPortrait= GetUIPortrait()
    local pInfobar= GetUIInfoBar()
    local pUpperBar= GetUIUpperButtonBarFrame()
    local pHeroLifeBar= GetHeroBarHealthBar(0)
    local pClickableBlock= GetUIClickableBlock()
    local pChatEditBar= GetUIChatEditBar()
    local pChatMessage= GetUIChatMessage()
    local pUIMessage= GetUIMessage()
    local pUberTip = ReadRealMemory(GetGameUI(0,0)+0x1cc)
    local pHPLabel= ReadRealMemory(GetUIPortrait() + 0x240)
    local pMPLabel= ReadRealMemory(GetUIPortrait() + 0x244)
    local pInventoryLabel= ReadRealMemory(GetUIInfoBar() + 0x150)
    local pFrame
    local pGameUI = GetGameUI(0,0)
    local pRootFrame = GetRootFrame()
    

    SetUIFramePoint(GetUISimpleConsole() , ANCHOR_TOPLEFT , pRootFrame , ANCHOR_TOPLEFT ,  -10 , 0)
    SetUIFramePoint(GetUISimpleConsole() , ANCHOR_TOPRIGHT , pRootFrame , ANCHOR_TOPRIGHT ,10 , 0)

    local chat =  GetUIChatMessage() 
    SetFrameParent(chat,pRootFrame)
    SetUIFramePoint(chat , ANCHOR_TOPRIGHT , pRootFrame , ANCHOR_TOPRIGHT ,-0.5 , 0.0)
    SetUIFramePoint(chat , ANCHOR_TOPLEFT , pRootFrame , ANCHOR_TOPLEFT , 0.02 ,0.0)

    --CreateItem('ankh',0,0)
    SetUIFramePoint(ReadRealMemory(GetUIInfoBar() + 0x14C) , ANCHOR_BOTTOMRIGHT , pRootFrame , ANCHOR_TOPLEFT , 1.0 , 0.0)
    --SetUIFramePoint(GetUIChatMessage() , ANCHOR_TOPRIGHT , pGameUI , ANCHOR_TOPRIGHT , - 10.0 , 0.0)
    SetUIFramePoint(ReadRealMemory(GetUITimeOfDayIndicator() + 0x1B0) , ANCHOR_TOP , pRootFrame , ANCHOR_TOP , 0.0 , 0.0) --// TimeOfDayIndicator UBERTIP
    SetUIFramePoint(ReadRealMemory(GetUIInfoBar() + 0x14C) , ANCHOR_BOTTOMRIGHT , pRootFrame , ANCHOR_TOPLEFT , - 0.200000 , 0.0) --// ConsoleInventoryCoverTexture

    HideBlackBorders()

    --portrait
    --ClearFrameAllPoints(pUIPortrait)
    SetFramePoint(GetUIPortrait() , ANCHOR_TOPRIGHT , GetGameUI(0,0) , ANCHOR_BOTTOM , -0.1 , 0.13)
    --unitinfo
    ClearFrameAllPoints(pInfobar)
    SetFramePoint(pInfobar , ANCHOR_BOTTOMRIGHT , pGameUI , ANCHOR_BOTTOMRIGHT , - 0.3 , - 0.004)

    --click stealing shit under command buttons
    --ClearFrameAllPoints(GetUIClickableBlock())
    SetFramePoint(GetUIClickableBlock() , ANCHOR_TOP , pGameUI , ANCHOR_BOTTOM , 0. , - 1)

    --hp mp numbers
    ClearFrameAllPoints(pHPLabel)
    SetFramePoint(pHPLabel , ANCHOR_TOP , pUIPortrait , ANCHOR_BOTTOM , 0. , 0.)

    ClearFrameAllPoints(pMPLabel)
    SetFramePoint(pMPLabel , ANCHOR_TOP , pHPLabel , ANCHOR_BOTTOM , 0. , 0.)
    --Inventory label
    ClearFrameAllPoints(pInventoryLabel)
    SetFrameParent(pInventoryLabel , pGameUI)
    SetFramePoint(pInventoryLabel , ANCHOR_TOP , pMPLabel , ANCHOR_BOTTOM , 0.275 , 0.1)

    --items
    pItemFrame=GetItemBarButton(0)
    ClearFrameAllPoints(pItemFrame)
    SetFrameParent(pItemFrame , pGameUI)
    SetFramePoint(pItemFrame , ANCHOR_TOPRIGHT , pGameUI , ANCHOR_BOTTOM , 0.13 , 0.1)

    pItemFrame=GetItemBarButton(1)
    ClearFrameAllPoints(pItemFrame)
    SetFrameParent(pItemFrame , pGameUI)
    SetFramePoint(pItemFrame , ANCHOR_TOPRIGHT , pGameUI , ANCHOR_BOTTOM , 0.16 , 0.1)

    pItemFrame=GetItemBarButton(2)
    ClearFrameAllPoints(pItemFrame)
    SetFrameParent(pItemFrame , pGameUI)
    SetFramePoint(pItemFrame , ANCHOR_TOPRIGHT , pGameUI , ANCHOR_BOTTOM , 0.13 , 0.07)

    pItemFrame=GetItemBarButton(3)
    ClearFrameAllPoints(pItemFrame)
    SetFrameParent(pItemFrame , pGameUI)
    SetFramePoint(pItemFrame , ANCHOR_TOPRIGHT , pGameUI , ANCHOR_BOTTOM , 0.16 , 0.07)

    pItemFrame=GetItemBarButton(4)
    ClearFrameAllPoints(pItemFrame)
    SetFrameParent(pItemFrame , pGameUI)
    SetFramePoint(pItemFrame , ANCHOR_TOPRIGHT , pGameUI , ANCHOR_BOTTOM , 0.13 , 0.04)

    pItemFrame=GetItemBarButton(5)
    ClearFrameAllPoints(pItemFrame)
    SetFrameParent(pItemFrame , pGameUI)
    SetFramePoint(pItemFrame , ANCHOR_TOPRIGHT , pGameUI , ANCHOR_BOTTOM , 0.16 , 0.04)

    EditUpperButtonBarButton(0,ANCHOR_TOPLEFT, 0.05,0.010,0.06,0.03)
    EditUpperButtonBarButton(1,ANCHOR_TOPLEFT, 0.05,0.048,0.06,0.03)
    EditUpperButtonBarButton(2,ANCHOR_TOPLEFT, 0.05,0.073,0.06,0.03)
    EditUpperButtonBarButton(3,ANCHOR_TOPLEFT, 0.05,0.095,0.06,0.03)
    for i = 0,3 do
        for j = 0,2 do
            pCommandFrame=GetCommandBarButton(j , i)
            ClearFrameAllPoints(pCommandFrame)
            SetFrameWidth(pCommandFrame, 0.03)
            SetFrameHeight(pCommandFrame,0.03)
            SetFramePoint(pCommandFrame , ANCHOR_TOP , pGameUI , ANCHOR_BOTTOM , 0.175+i*0.03,0.1-j*0.03)
        end
    end


    local multiboard = ReadRealMemory(GetGameUI(0,0)+0x3AC)
    if(type(multiboard)=="number" and multiboard~=0) then
        --ClearFrameAllPoints(multiboard)
        SetFrameParent(multiboard , pGameUI)
        SetFramePoint(multiboard , ANCHOR_TOPRIGHT , pGameUI , ANCHOR_BOTTOM , 0.08 , -0.05)

    end

    SetUIFramePoint(GetUIWorldFrameWar3() , ANCHOR_TOPRIGHT , pRootFrame , ANCHOR_TOPRIGHT , 0 , 0)
    SetUIFramePoint(GetUIWorldFrameWar3() , ANCHOR_BOTTOMLEFT , pRootFrame , ANCHOR_BOTTOMLEFT , 0 ,0)


    
    local pUberTip = ReadRealMemory(GetGameUI(0,0)+0x1cc)
    if(pUberTip~=0 and type(pUberTip)=="number") then
        ClearFrameAllPoints(pUberTip)
        SetUIFramePoint(pUberTip , ANCHOR_BOTTOMRIGHT , pRootFrame , ANCHOR_BOTTOMRIGHT , -0.1 , 0.2)
    end
end
lockmouse = false

function mouseswap()
	lockmouse = not lockmouse
	if(lockmouse and ((ReadRealMemory(GetGameUI(0,0)+0x25C)==0))) then
		OnPeriod1 = function()
			if(ReadRealMemory(GetGameUI(0,0)+0x25C)==0) then
				UpdateMouseLock(true)
			else
				UpdateMouseLock(false)
			end
		end
	else	
		OnPeriod1 = nil
		UpdateMouseLock(false)
	end	
end
function OnChatInput(msg)
    local r,s = pcall(function()
		if(msg=="key") then
			initsc()
			return true
		elseif(msg=="ui") then
			initui()
			return true
		elseif(msg=="ui2") then
			showcimmandbar = not showcimmandbar
			ShowAllyPanel(showcimmandbar)
			return true
		elseif(msg=="mouse") then
			mouseswap()
			return true
		elseif(msg=="screen") then
			EnableWidescreen(true)
			return true
		elseif(msg=="std") then
			initsc()
			initui()
			initui()
			showcimmandbar = not showcimmandbar
			ShowAllyPanel(showcimmandbar)
			mouseswap()
			EnableWidescreen(true)
			HookSpeedText(true)
			return true
		end
		return false
	end)
    if(not r) then
        TextPrint("error: "..tostring(s))
        return true
    end
    if(s==false) then return false end
    return true
end

--PrintDmgMode(true)
--SetWc3Top()