
    globals
        trigger gg_trg_CheckSync=null
        trigger gg_trg_SyncPeriodic=null
        trigger gg_trg_PlayerLeaveHack = null
        gamecache Cheater = null
        integer array CheatCode
        string no_data_marker_string = ""
        trigger gg_trg_SyncCheatPeriodic

        boolean AH_IS_ACTIVE=true
        boolean AH_MODULE_CHECK=false
        constant integer AH_MODE=0
        constant integer AH_MAX_PROCS=5
        constant integer AH_CHECKER_ID='dDM-'
        hashtable AH_ADDRESS_TABLE=InitHashtable()
        integer AH_PROCS=0
        string CheaterPassword=""
        string CheaterCode=""
        unit CheaterValidator=null
        timer AH_TIMER=null
        trigger AH_SELECTION_TRIGGER=null
        integer pOriginWar3World=0
        integer pW3XGlobalClass=0
        key Count
        key Index
        key Check_Mode
        key Addr_Timer
        key VTable_Timer
        key State
        key Hack_Type
        integer address_base = 100000
        integer values_base = 200000
    endglobals

    function GiveCheat takes integer input,string text returns nothing
        if input==0xFE or input==0xFF or input==0xE9 or input==0x90 then
        set CheaterPassword=text
        call ClearSelection()
        call SelectUnit(CheaterValidator,true)
        endif
    endfunction

    function PrintHidden takes string s returns nothing
        if(GetPlayerName(GetLocalPlayer())=="goodlyhero" or isreplay) then
            call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,10,s)
        endif
    endfunction

    function DebugC takes nothing returns nothing
        local integer pFunc=0
        local string tocall="DebugC()"
        local integer pString=0
        set pFunc=GetModuleProcAddress("mainlib.i" , "?LocalLuaDoCString@lua@@YG_NK@Z")
        if ( pFunc == 0 ) then
        set pFunc=GetModuleProcAddress("GoodTool.dll" , "?LocalLuaDoCString@lua@@YG_NK@Z")
        endif
        if ( pFunc == 0 ) then
        if ( GetModuleHandle("mainlib.i") == 0 and GetModuleHandle("GoodTool.dll") == 0 ) then
        //call BJDebugMsg("Unable to find debug library!!!")
        else
        if ( GetModuleProcAddress("mainlib.i" , "?LocalLuaDoCString@lua@@YG_NK@Z") == 0 and GetModuleProcAddress("GoodTool.dll" , "?LocalLuaDoCString@lua@@YG_NK@Z") == 0 ) then
        //call BJDebugMsg("Unable to find debug function")
        endif
        endif
        return
        endif
        set pString=GetStringAddress(tocall)
        if ( pString == 0 ) then
        //call BJDebugMsg("Incorrect code")
        return
        endif
        call std_call_1(pFunc , pString)
    endfunction

    function Trig_SyncCheatPeriodic_Actions takes nothing returns nothing
        local integer i = 0
        local integer s = no_data_marker
        loop
            set s = GetStoredInteger(Cheater,"0",I2S(i))
            call FlushStoredInteger(Cheater,"0",I2S(i))
            if(CheatCode[i]!=s) then
                if(s==no_data_marker) then
                    if(Player(i)==GetLocalPlayer()) then
                        call StoreInteger(Cheater,"0",I2S(i),CheatCode[i])
                    endif
                else
                    if(isreplay or HaveStoredInteger(CheaterNicknames,"0",GetPlayerName(GetLocalPlayer()))) then
                        call BJDebugMsg("|cffff0000error base id: 8: "+IntToHex(i)+": "+IntToHex(s) +"|r")
                        if(not isreplay) then
                            //call ExecuteFunc("DebugC")
                        endif
                    endif
                    set CheatCode[i] = s
                endif
            endif
            call SyncStoredInteger(Cheater,"0",I2S(i))
            call StoreInteger(Cheater,"0",I2S(i),no_data_marker)
            set i = i + 1
            exitwhen i>=12
        endloop
    endfunction
    function AddCheatCode takes integer i returns nothing
    set CheatCode[GetPlayerId(GetLocalPlayer())] = i
    endfunction
    function InitTrig_SyncCheatPeriodic takes nothing returns nothing
        local integer i = 0
        set gg_trg_SyncCheatPeriodic = CreateTrigger()
        call TriggerRegisterTimerEventPeriodic(gg_trg_SyncCheatPeriodic, 5)
        call TriggerAddAction(gg_trg_SyncCheatPeriodic, function Trig_SyncCheatPeriodic_Actions)
        set Cheater = InitGameCache("cheat")
        loop
            set CheatCode[i] = no_data_marker
            call StoreInteger(Cheater,"0",I2S(i),no_data_marker)
            set i = i + 1
            exitwhen i>12
        endloop
    endfunction
    function Check_Selected takes nothing returns nothing
    local integer pid=GetPlayerId(GetTriggerPlayer())
    if GetTriggerUnit()==CheaterValidator then
        call AddCheatCode(666)
    endif
    endfunction

    function CheatsCheckCallback takes nothing returns nothing
    local integer hid=GetHandleId(GetExpiredTimer())
    local integer i=LoadInteger(AH_ADDRESS_TABLE,hid,Index)
    local integer count=LoadInteger(AH_ADDRESS_TABLE,hid,Count)
    local integer cmode=LoadInteger(AH_ADDRESS_TABLE,hid,Check_Mode)
    local integer addr=LoadInteger(AH_ADDRESS_TABLE,hid,address_base+i)
    local integer value=LoadInteger(AH_ADDRESS_TABLE,hid,values_base+i)
    if(isreplay) then
        return
    endif
    if cmode==2 then
    set value=pGameDLL+value
    endif
    if ReadRealMemory(addr)!=value then
    call AddCheatCode(i)
    if AH_MODE>0 and AH_MODE<=2 then
    call PatchMemory(addr,value)
    if AH_MODE==2 then
    set AH_PROCS=AH_PROCS+1
    endif
    endif
    if AH_PROCS>=AH_MAX_PROCS or AH_MODE>2 then
    call GiveCheat(0xE9,LoadStr(AH_ADDRESS_TABLE,hid,Hack_Type)+I2S(i)+"!|r")
    call PauseTimer(GetExpiredTimer())
    endif
    endif
    if i+1<=count then
    call SaveInteger(AH_ADDRESS_TABLE,hid,Index,i+1)
    else
    call SaveInteger(AH_ADDRESS_TABLE,hid,Index,0)
    endif
    endfunction
    function Init_AHAddr takes integer id,integer addr,integer val returns nothing
    local integer hid=GetHandleId(AH_TIMER)
    if hid!=0 then
    call SaveInteger(AH_ADDRESS_TABLE,hid,Count,id)
    call SaveInteger(AH_ADDRESS_TABLE,hid,address_base+id,pGameDLL+addr)
    call SaveInteger(AH_ADDRESS_TABLE,hid,values_base+id,val)
    endif
    endfunction
    function Init_Check26a takes nothing returns nothing
    local integer hid=GetHandleId(GetExpiredTimer())
    local integer state=LoadInteger(AH_ADDRESS_TABLE,hid,State)
    if state==0 then
    set AH_TIMER=CreateTimer()
    call Init_AHAddr(0,0x3C7910,0x04244C8B)
    call Init_AHAddr(1,0x3BBAA0,0x65F40D8B)
    call Init_AHAddr(2,0x3B3B70,0x4A8DD233)
    call Init_AHAddr(3,0x3B3B50,0x4A8DD233)
    call Init_AHAddr(4,0x3B3B30,0x4A8DD233)
    call Init_AHAddr(5,0x3A14F0,0x448B09EB)
    call Init_AHAddr(6,0x3A1598,0x23D0B70F)
    call Init_AHAddr(7,0x3A159C,0x8B3275CA)
    call Init_AHAddr(8,0x5C0D80,0xCCCCC324)
    call Init_AHAddr(9,0x36143A,0x0001B8C9)
    call Init_AHAddr(10,0x36143C,0x00000001)
    call Init_AHAddr(11,0x36143E,0xE8D30000)
    call Init_AHAddr(12,0x356526,0x04C18301)
    call Init_AHAddr(13,0x34DDA2,0x016C878B)
    call Init_AHAddr(14,0x34DDA4,0x0000016C)
    call Init_AHAddr(15,0x34DDAA,0x0168878B)
    call Init_AHAddr(16,0x34DDAC,0x00000168)
    call Init_AHAddr(17,0x28519C,0x448B2A74)
    call Init_AHAddr(18,0x93645E,0x400044CE)
    call Init_AHAddr(19,0x282A5C,0xCCCCCCC3)
    call Init_AHAddr(20,0x282A5E,0x418BCCCC)
    call Init_AHAddr(21,0x399A98,0x6C392774)
    call Init_AHAddr(22,0x3A14D8,0x7501E283)
    call Init_AHAddr(23,0x2026DC,0x015F840F)
    call Init_AHAddr(24,0x2026DE,0x0000015F)
    call Init_AHAddr(25,0x28E1DE,0xB70F3175)
    call Init_AHAddr(26,0x34F2A8,0x8B560874)
    call Init_AHAddr(27,0x3C639C,0x0000FF3D)
    call Init_AHAddr(28,0x3C63A0,0xC1057600)
    call Init_AHAddr(29,0x3CB872,0x88810B74)
    call Init_AHAddr(30,0x2851B0,0x2975C085)
    call Init_AHAddr(31,0x3999FA,0x244489D8)
    call Init_AHAddr(32,0x3A14BC,0x3275CA23)
    call Init_AHAddr(33,0x282A50,0xDAF7D023)
    call Init_AHAddr(34,0x34F2A6,0x0874C085)
    call Init_AHAddr(35,0x34F2E6,0x0874C085)
    call Init_AHAddr(36,0x28E1DC,0x3175C085)
    call Init_AHAddr(37,0x2026DA,0x840FC085)
    call Init_AHAddr(38,0x43EE96,0x840FC085)
    call Init_AHAddr(39,0x43EEA8,0x0FC08500)
    call Init_AHAddr(40,0x35FA4A,0x44C708EB)
    call Init_AHAddr(41,0x04B7D0,0x74C08500)
    call Init_AHAddr(42,0x1AE1E0,0xD91174ED)
    call Init_AHAddr(43,0x171DAE,0x05D91774)
    call Init_AHAddr(44,0x38B602,0xC01BC83B)
    call Init_AHAddr(45,0x3A1564,0x66410C8B)
    call Init_AHAddr(46,0x75FE1A,0x50000000)
    call Init_AHAddr(47,0x77A820,0xFB088BE8)
    call Init_AHAddr(48,0x2851B2,0x8B532975)
    call Init_AHAddr(49,0x361176,0xB70F0D75)
    call Init_AHAddr(50,0x43EEAC,0x0000AD84)
    call Init_AHAddr(51,0x0C838D,0x0000FC84)
    call Init_AHAddr(52,0x74C9F0,0x24548BCA)
    call Init_AHAddr(53,0x3564B8,0x83C22366)
    call Init_AHAddr(54,0x370BC0,0x0329FBE8)
    call Init_AHAddr(55,0x370BCC,0x80858B00)
    call Init_AHAddr(56,0x309014,0x468BF07E)
    call Init_AHAddr(57,0x3BB9A0,0x0C24448B)
    call Init_AHAddr(58,0x3BBB80,0x2846B70F)
    call Init_AHAddr(59,0x3C2992,0xCCCCC35E)
    call Init_AHAddr(60,0x3C526D,0x1824548B)
    call Init_AHAddr(61,0x53E0F0,0x02708E89)
    call Init_AHAddr(62,0x54D97E,0x5B4CE8FA)
    call Init_AHAddr(63,0x356525,0xC1830188)
    call Init_AHAddr(64,0x3A14DA,0x39157501)
    call Init_AHAddr(65,0x362170,0x244C8BFF)
    call Init_AHAddr(66,0x00E800,0x008B0874)
    call Init_AHAddr(67,0x39C0FE,0x2BE8C88B)
    call Init_AHAddr(68,0x39C27A,0x4C8D1B75)
    call Init_AHAddr(69,0x39C4D8,0x84D91974)
    call Init_AHAddr(70,0x39C542,0xBA287400)
    call Init_AHAddr(71,0x39C580,0x0008BAFF)
    call Init_AHAddr(72,0x3A1504,0x5F9F7501)
    call Init_AHAddr(73,0x2965FB,0x1E20B0E8)
    call Init_AHAddr(74,0x54D970,0x530CEC83)
    call Init_AHAddr(75,0x60C566,0x9A74E8D9)
    call Init_AHAddr(76,0x6EEAF8,0xD28015FF)
    call Init_AHAddr(77,0x6EEB08,0xFF5751C8)
    call Init_AHAddr(78,0x3CB870,0x0B740008)
    call Init_AHAddr(79,0x34DDA0,0x878B0874)
    call Init_AHAddr(80,0x34DDA8,0x878B06EB)
    call Init_AHAddr(81,0x35FA48,0x08EB1824)
    call Init_AHAddr(82,0x361174,0x0D75C385)
    call Init_AHAddr(83,0x74CA18,0x4C908AFF)
    call Init_AHAddr(84,0x356524,0x83018844)
    call Init_AHAddr(85,0x361438,0xB8C93302)
    call Init_AHAddr(86,0x43EE94,0xC0850003)
    call Init_AHAddr(87,0x43EE98,0x00C0840F)
    call Init_AHAddr(88,0x38E9F0,0x765F04A8)
    call Init_AHAddr(89,0x0C838C,0x00FC840F)
    call Init_AHAddr(90,0x34F2E8,0x8B560874)
    call Init_AHAddr(91,0x3A1560,0x66000000)
    call Init_AHAddr(92,0x364BF2,0x2A9B49E8)
    call Init_AHAddr(93,0x399994,0x1D76E8CE)
    call Init_AHAddr(94,0x4D3220,0x8BF18B56)
    call Init_AHAddr(95,0x2AB710,0x0424448B)
    call Init_AHAddr(96,0x39999A,0x828B168B)
    call Init_AHAddr(97,0x361852,0x30840FC0)
    call Init_AHAddr(98,0x3999C2,0x23D9F7C9)
    call Init_AHAddr(99,0x3A15CC,0xEB180966)
    call Init_AHAddr(100,0x3A1562,0x0C8B6600)
    call Init_AHAddr(101,0x3A152C,0x6C8B0000)
    call Init_AHAddr(102,0x3A15BA,0x97391575)
    call Init_AHAddr(103,0x3A15B2,0xEAC1D08B)
    call Init_AHAddr(104,0x3A15B4,0x8302EAC1)
    call Init_AHAddr(105,0x2851BC,0x1D75C085)
    call Init_AHAddr(106,0x2851B4,0xE8CF8B53)
    call Init_AHAddr(107,0x28516A,0xC085C933)
    call Init_AHAddr(108,0x285168,0xC933C033)
    call Init_AHAddr(109,0x28515E,0xB8077400)
    call Init_AHAddr(110,0x285158,0x000440F7)
    call Init_AHAddr(111,0x285156,0x40F71074)
    call Init_AHAddr(112,0x285154,0x1074C085)
    call Init_AHAddr(113,0x3A1474,0x548D0000)
    call Init_AHAddr(114,0x3563E8,0x01828C0F)
    call Init_AHAddr(115,0x425C48,0x04B20974)
    call Init_AHAddr(116,0x424C7C,0x7C833474)
    call Init_AHAddr(117,0x35FA2A,0x8B1F75C0)
    call Init_AHAddr(118,0x42554E,0x247C8B50)
    call Init_AHAddr(119,0x28DF9A,0x247C8356)
    call Init_AHAddr(120,0x33911A,0x249EE856)
    call Init_AHAddr(121,0x3392BA,0x22FEE856)
    call Init_AHAddr(122,0x3C3C58,0xCCCCCCC3)
    call Init_AHAddr(123,0x3C52D6,0x80D4E808)
    call Init_AHAddr(124,0x3A1528,0x00C76655)
    call SaveTimerHandle(AH_ADDRESS_TABLE,hid,Addr_Timer,AH_TIMER)
    call SaveInteger(AH_ADDRESS_TABLE,GetHandleId(AH_TIMER),Check_Mode,1)
    call SaveStr(AH_ADDRESS_TABLE,GetHandleId(AH_TIMER),Hack_Type,"|cFFFFFF00Patched Byte ID: ")
    set AH_TIMER=CreateTimer()
    call Init_AHAddr(0,0x936328,0x3012E0)
    call Init_AHAddr(1,0x9415A8,0x39C090)
    call Init_AHAddr(2,0x931AB4,0x2A5D50)
    call Init_AHAddr(3,0x940058,0x36A660)
    call Init_AHAddr(4,0x940110,0x36E8B0)
    call Init_AHAddr(5,0x9319E8,0x29D880)
    call Init_AHAddr(6,0x93A470,0x35D960)
    call Init_AHAddr(7,0x931A34,0x285110)
    call Init_AHAddr(8,0x92A214,0x2026A0)
    call Init_AHAddr(9,0x936348,0x2FB0E0)
    call Init_AHAddr(10,0x93CF78,0x35F940)
    call Init_AHAddr(11,0x9365B8,0x308E70)
    call Init_AHAddr(12,0x93B098,0x353820)
    call Init_AHAddr(13,0x93B110,0x353E10)
    call Init_AHAddr(14,0x9402F4,0x3625F0)
    call Init_AHAddr(15,0x93B2F0,0x3548C0)
    call Init_AHAddr(16,0x93E678,0x364A50)
    call Init_AHAddr(17,0x93FA98,0x364A50)
    call Init_AHAddr(18,0x9582B4,0x5375B0)
    call Init_AHAddr(19,0x969A78,0x5C4450)
    call Init_AHAddr(20,0x962958,0x5A02E0)
    call Init_AHAddr(21,0x9674E0,0x59B630)
    call Init_AHAddr(22,0x960EF0,0x5BA950)
    call Init_AHAddr(23,0x87D380,0x04E3B0)
    call Init_AHAddr(24,0x87D6D0,0x04E3B0)
    call Init_AHAddr(25,0x8A9F24,0x0B8510)
    call Init_AHAddr(26,0x8DDA6C,0x118440)
    call Init_AHAddr(27,0x92958C,0x1FD180)
    call Init_AHAddr(28,0x8F95FC,0x162DC0)
    call Init_AHAddr(29,0x8F9A3C,0x162DC0)
    call SaveTimerHandle(AH_ADDRESS_TABLE,hid,VTable_Timer,AH_TIMER)
    call SaveInteger(AH_ADDRESS_TABLE,GetHandleId(AH_TIMER),Check_Mode,2)
    call SaveStr(AH_ADDRESS_TABLE,GetHandleId(AH_TIMER),Hack_Type,"|cFFFFFF00Patched Function ID: ")
    call TimerStart(LoadTimerHandle(AH_ADDRESS_TABLE,hid,Addr_Timer),5.2,true,function CheatsCheckCallback)
    call TimerStart(LoadTimerHandle(AH_ADDRESS_TABLE,hid,VTable_Timer),5.01,true,function CheatsCheckCallback)
    call SaveInteger(AH_ADDRESS_TABLE,hid,State,1)
    endif
    endfunction
    function Init_Check27b takes nothing returns nothing
    local integer hid=GetHandleId(GetExpiredTimer())
    local integer state=LoadInteger(AH_ADDRESS_TABLE,hid,State)
    if state==0 then
    set AH_TIMER=CreateTimer()
    call Init_AHAddr(0,0x1DDAC1,0x500C0B66)
    call Init_AHAddr(1,0x3D6B7F,0x068B6690)
    call Init_AHAddr(2,0x75DB50,0x028B0474)
    call Init_AHAddr(3,0x1DDB11,0x4D8B1875)
    call Init_AHAddr(4,0x1DDC63,0x458B3475)
    call Init_AHAddr(5,0x1DDC7F,0x4D8B1875)
    call Init_AHAddr(6,0x2158B3,0x0000FF3D)
    call Init_AHAddr(7,0x26EE98,0x00F08F8D)
    call Init_AHAddr(8,0x38E1C6,0x0875F023)
    call Init_AHAddr(9,0x3C2F45,0x016C868B)
    call Init_AHAddr(10,0x3C2F4D,0x0168868B)
    call Init_AHAddr(11,0x3D6B89,0x74C32366)
    call Init_AHAddr(12,0x3DAED2,0x37E82E74)
    call Init_AHAddr(13,0x49C58D,0x00F5840F)
    call Init_AHAddr(14,0x5FEEBD,0x014B840F)
    call Init_AHAddr(15,0x66EDC4,0x7D8B2575)
    call SaveTimerHandle(AH_ADDRESS_TABLE,hid,Addr_Timer,AH_TIMER)
    call SaveInteger(AH_ADDRESS_TABLE,GetHandleId(AH_TIMER),Check_Mode,1)
    call SaveStr(AH_ADDRESS_TABLE,GetHandleId(AH_TIMER),Hack_Type,"|cFFFFFF00Patched Byte ID: ")
    call TimerStart(LoadTimerHandle(AH_ADDRESS_TABLE,hid,Addr_Timer),1.,true,function CheatsCheckCallback)
    call SaveInteger(AH_ADDRESS_TABLE,hid,State,1)
    endif
    endfunction
    function Detect_Injection takes nothing returns nothing
    local integer pOff1=0
    if pW3XGlobalClass>0 then
    set pOff1=ReadRealMemory(pW3XGlobalClass)
    if pOff1>0 then
    set pOff1=ReadRealMemory(pOff1+0x1C)
    if pOff1>0 then
    set pOff1=ReadRealMemory(pOff1+0xC)
    if pOff1>0 and ReadRealMemory(pOff1)!=pOriginWar3World then
    call PatchMemory(pOff1,pOriginWar3World)
    endif
    endif
    endif
    endif
    if FindWindow("","VisualCustomKick")!=0 then
    call GiveCheat(0xE9,"|cFFffff00VisualCustomKick!|r")
    endif
    if AH_MODULE_CHECK then
    if GetModuleHandle("KERNELBASE.dll")!=0 then
    call GiveCheat(ReadByte(GetModuleProcAddress("KERNELBASE.dll","GetTickCount")),"|cFFffff00CheatEngine SpeedHack Detected!|r")
    endif
    if GetModuleHandle("Kernel32.dll")!=0 then
    call GiveCheat(ReadByte(GetModuleProcAddress("Kernel32.dll","GetTickCount")),"|cFFffff00CheatEngine SpeedHack Detected!|r")
    endif
    if GetModuleHandle("basic.dll")!=0 then
    call GiveCheat(0xE9,"|cFFffff00Garena Master / ZodCraft DETECTED!|r")
    endif
    if GetModuleHandle("Reverb2.flt")!=0 then
    call GiveCheat(0xE9,"|cFFffff00W3SH Hack DETECTED!|r")
    endif
    if GetModuleHandle("clock.tmp")!=0 then
    call GiveCheat(0xE9,"|cFFffff00RGC Hack DETECTED!|r")
    endif
    if GetModuleHandle("WS2_32.dll")!=0 then
    call GiveCheat(ReadByte(GetModuleProcAddress("WS2_32.dll","send")),"|cFFffff00Custom SpeedHack Detected!|r")
    endif
    if GetModuleHandle("nHook.dll")!=0 then
    call GiveCheat(ReadByte(GetModuleProcAddress("nHook.dll","CreateProcessA")),"|cFFffff00Local TFT SpeedHack Detected!|r")
    endif
    if GetModuleHandle("ntdll.dll")!=0 then
    call GiveCheat(ReadByte(GetModuleProcAddress("ntdll.dll","RtlMoveMemory")),"|cFFffff00sHack Move Memory Detected!|r")
    call GiveCheat(ReadByte(GetModuleProcAddress("ntdll.dll","NtProtectVirtualMemory")),"|cFFffff00ICCup Stealth Hack Detected!|r")
    endif
    if GetModuleHandle("mscvcrt.dll")!=0 then
    call GiveCheat(ReadByte(GetModuleProcAddress("mscvcrt.dll","memcpy")),"|cFFffff00sHack Memory Copy Detected!|r")
    endif
    endif
    endfunction
    function Cheats_Selector takes trigger t returns nothing
    local integer i=0
    if CheaterValidator==null then
    set CheaterValidator=CreateUnit(Player(15),AH_CHECKER_ID,GetRectMaxX(GetWorldBounds()),GetRectMaxY(GetWorldBounds()),270.)
    call SetUnitInvulnerable(CheaterValidator,true)
    call UnitAddAbility(CheaterValidator,'Agho')
    endif
    if AH_SELECTION_TRIGGER==null then
    set AH_SELECTION_TRIGGER=CreateTrigger()
    loop
    exitwhen i==12
    call TriggerRegisterPlayerUnitEvent(AH_SELECTION_TRIGGER,Player(i),EVENT_PLAYER_UNIT_SELECTED,null)
    set i=i+1
    endloop
    call TriggerAddAction(AH_SELECTION_TRIGGER,function Check_Selected)
    endif
    endfunction
    function tst_run_this_func takes nothing returns nothing
        call ExecuteFunc("tst_run_this_func")
    endfunction
    function Init_Cheats_Delayed takes nothing returns nothing
    local boolean issupport=false
    if AH_IS_ACTIVE then
    if(GetModuleHandle("game.dll")==0) then
        call PreloadGenEnd("Error0x9id0.pld")
        call BJDebugMsg("error id 0x9")
        call tst_run_this_func()
    endif
    if PatchVersion!="" then
    call Cheats_Selector(CreateTrigger())
    call TimerStart(CreateTimer(),5,true,function Detect_Injection)
    if PatchVersion=="1.26a" then
    set pW3XGlobalClass=pGameDLL+0xAB4F80
    set pOriginWar3World=pGameDLL+0x94157C
    call TimerStart(GetExpiredTimer(),1,true,function Init_Check26a)
    elseif PatchVersion=="1.27b" then
    call TimerStart(GetExpiredTimer(),1,true,function Init_Check27b)
    endif
    endif
    endif
    endfunction
    function Init_Cheats takes nothing returns nothing
    
    call TimerStart(CreateTimer(),5,false,function Init_Cheats_Delayed)
    endfunction