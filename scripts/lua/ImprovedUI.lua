local initialized = false
local function initui()
    if(initialized) then
        return
    end
    initialized = true
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
	local CommandBarButtonSize = 0.04
	local CommandBarButtonOffsetX = 0.2
	local CommandBarButtonOffsetY = 0.13
    
	for i = 0,3 do
        for j = 0,2 do
            pCommandFrame=GetCommandBarButton(j , i)
            ClearFrameAllPoints(pCommandFrame)
            SetFrameWidth(pCommandFrame, CommandBarButtonSize)
            SetFrameHeight(pCommandFrame,CommandBarButtonSize)
            SetFramePoint(pCommandFrame , ANCHOR_TOP , pGameUI , ANCHOR_BOTTOM , CommandBarButtonOffsetX+i*CommandBarButtonSize,CommandBarButtonOffsetY-j*CommandBarButtonSize)
        end
    end
	
	--items
    
	for i = 0,5 do
		local pItemFrame=GetItemBarButton(i)
		ClearFrameAllPoints(pItemFrame)
		SetFrameParent(pItemFrame , pGameUI)
		SetFramePoint(pItemFrame , ANCHOR_TOP , pGameUI , ANCHOR_BOTTOM , CommandBarButtonOffsetX-(2-i%2)*CommandBarButtonSize,CommandBarButtonOffsetY-CommandBarButtonSize*(i//2))
		SetFrameWidth(pItemFrame, CommandBarButtonSize)
		SetFrameHeight(pItemFrame,CommandBarButtonSize)
	end
	
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


    EditUpperButtonBarButton(0,ANCHOR_TOPLEFT, 0.05,0.010,0.06,0.03)
    EditUpperButtonBarButton(1,ANCHOR_TOPLEFT, 0.05,0.048,0.06,0.03)
    EditUpperButtonBarButton(2,ANCHOR_TOPLEFT, 0.05,0.073,0.06,0.03)
    EditUpperButtonBarButton(3,ANCHOR_TOPLEFT, 0.05,0.095,0.06,0.03)

	local multiboard = ReadRealMemory(GetGameUI(0,0)+0x3AC)
    if(type(multiboard)=="number" and multiboard~=0) then
        --ClearFrameAllPoints(multiboard)
        SetFrameParent(multiboard , pGameUI)
        SetFramePoint(multiboard , ANCHOR_TOPRIGHT , pGameUI , ANCHOR_TOPRIGHT , -0.01 , -0.06)

    end

    SetUIFramePoint(GetUIWorldFrameWar3() , ANCHOR_TOPRIGHT , pRootFrame , ANCHOR_TOPRIGHT , 0 , 0)
    SetUIFramePoint(GetUIWorldFrameWar3() , ANCHOR_BOTTOMLEFT , pRootFrame , ANCHOR_BOTTOMLEFT , 0 ,0)

    local pUberTip = ReadRealMemory(GetGameUI(0,0)+0x1cc)
    if(pUberTip~=0 and type(pUberTip)=="number") then
        ClearFrameAllPoints(pUberTip)
        SetUIFramePoint(pUberTip , ANCHOR_BOTTOMRIGHT , pRootFrame , ANCHOR_BOTTOMRIGHT , -0.01 , 0.14)
    end
end



ImprovedUI = {}

ImprovedUI.init = initui


local function UIMode(mode)
    if(mode) then
        ImprovedUI.init()
    else
    end
end

ImprovedUI.switch = UIMode


