//TESH.scrollpos=94
//TESH.alwaysfold=0
//! nocjass
library APIMemoryGameData
    globals
        integer pGameState          = 0
        integer pGameClass1         = 0
        integer pGetUnitAddress     = 0
        integer pGetHandleId        = 0
        integer pHandleIdToObject   = 0
        integer pObjectToHandleId   = 0
        integer pGetDataNode        = 0
        integer pGetAgentBaseData   = 0
        integer pGetAgentBaseUIData = 0
        integer pToJUnit            = 0

        hashtable htObjectDataPointers = InitHashtable( )
    endglobals

    function SaveCode takes hashtable ht, integer parentKey, integer childKey, code c returns nothing
        if ht != null then
            call SaveInteger( ht, parentKey, childKey, C2I( c ) )
        endif
    endfunction

    function LoadCode takes hashtable ht, integer parentKey, integer childKey returns code
        if ht != null then
            return I2C( LoadInteger( ht, parentKey, childKey ) )
        endif

        return null
    endfunction

	function ConvertHandleId takes integer handleid returns integer
		if handleid > 0 then
            return ReadRealMemory( ReadRealMemory( ReadRealMemory( ReadRealMemory( pGameState ) + 0x1C ) + 0x19C ) + handleid * 0xC - 0x2FFFFF * 4 )
		endif

		return 0
	endfunction
    
	function ConvertHandle takes handle h returns integer
		return ConvertHandleId( GetHandleId( h ) )
	endfunction

    function HandleIdToObject takes integer handleid returns integer
        local integer pData = this_call_1( pGetHandleId, ReadRealMemory( pGameState ) )

        if pData > 0 then
            return this_call_2( pHandleIdToObject, pData, handleid )
        endif
        
        return 0
    endfunction
    
    function ObjectToHandleId takes integer address returns integer
        local integer pData = this_call_1( pGetHandleId, ReadRealMemory( pGameState ) )

        if pData > 0 then
            return this_call_3( pObjectToHandleId, pData, address, 0 )
        endif
        
        return 0
    endfunction

    function GetAgentType takes handle h returns integer
        // returns code of the handle's type
        // +w3u for unit, +tmr for timer, +trg for trigger, +arg for region, etc...
 
        local integer func = ReadRealMemory( ReadRealMemory( ConvertHandle( h ) ) + 0x1C )
        return ReadRealMemory( func ) / 0x100 + ReadRealMemory( func + 0x4 ) * 0x1000000
    endfunction

    function ObjectToAbility takes integer pObject returns ability
        local integer pAbil = 0

        if pObject > 0 then
            set pAbil = ObjectToHandleId( pObject )

            if pAbil > 0 then
                return I2A( pAbil )
            endif
        endif

        return null
    endfunction
    
    function ObjectToUnit takes integer pObject returns unit
        local integer pUnit = 0

        if pObject > 0 then
            set pUnit = fast_call_1( pToJUnit, pObject )

            if pUnit > 0 then
                return I2U( pUnit )
            endif
        endif
        
        return null
    endfunction

    function GetAgentBaseDataById takes integer pAgentDataNode, integer agentId returns integer
        local integer pData = 0

        if agentId > 0 then
            call WriteRealMemory( pReservedIntArg1, agentId )
            set pData = this_call_1( pGetDataNode, pReservedIntArg1 )

            if pData != 0 then
                return this_call_3( pGetAgentBaseData, pAgentDataNode, pData, pReservedIntArg1 )
            endif
        endif

        return 0
    endfunction

    function GetAgentBaseUIDataById takes integer pAgentDataUINode, integer agentId returns integer
        local integer pData = 0

        if agentId > 0 then
            call WriteRealMemory( pReservedIntArg1, agentId )
            set pData = this_call_1( pGetDataNode, pReservedIntArg1 )

            if pData != 0 then
                return this_call_3( pGetAgentBaseUIData, pAgentDataUINode, pData, pReservedIntArg1 )
            endif
        endif

        return 0
    endfunction
    
	function GetUnitAddressFloatsRelated takes integer pConvertedHandle, integer step returns integer
		local integer pOffset1 = pConvertedHandle + step
		local integer pOffset2
        
        if pConvertedHandle > 0 then
            set pOffset2 = ReadRealMemory( pGameClass1 )
            set pOffset1 = ReadRealMemory( pOffset1 )
            set pOffset2 = ReadRealMemory( pOffset2 + 0xC )
            set pOffset2 = ReadRealMemory( ( pOffset1 * 0x8 ) + pOffset2 + 0x4 )
            return pOffset2
        endif

		return 0
	endfunction

	function GetUnitAddress takes unit u returns integer
		return this_call_1( pGetUnitAddress, GetHandleId( u ) )
	endfunction

	function GetSomeAddress takes integer pAddr1, integer pAddr2 returns integer // Alternative for sub_6F4786B0 (126a)
		local integer pOff1 = 0x2C

		if BitwiseAnd( pAddr1, pAddr2 ) == -1 then
            return 0
		endif

		if pAddr1 >= 0 then
            set pOff1 = 0xC
		endif

		set pOff1 = ReadRealMemory( pGameClass1 ) + pOff1
		set pOff1 = ReadRealMemory( pOff1 )
	 
		if pOff1 == 0 then
            return 0
		endif
	 
		set pOff1 = ReadRealMemory( pOff1 + 8 * pAddr1 + 0x4 )

		if pOff1 == 0 or ReadRealMemory( pOff1 + 0x18 ) != pAddr2 then
            return 0
		endif
	 
		return pOff1
	endfunction

	function GetSomeAddressForAbility takes integer pAddr1, integer pAddr2 returns integer
		local integer pOff1 = GetSomeAddress( pAddr1, pAddr2 )

		if pOff1 == 0 or ReadRealMemory( pOff1 + 0x20 ) > 0 then
            return 0
		endif

		return ReadRealMemory( pOff1 + 0x54 )
	endfunction

    function GetAgentTimerCooldown takes integer pTimer returns real
        local integer pData = 0

        if pTimer > 0 then
            set pData = ReadRealMemory( pTimer )

            if pData > 0 then
                call WriteRealMemory( pReservedIntArg1, 0 )
                call this_call_2( ReadRealMemory( pData + 0x18 ), pTimer, pReservedIntArg1 )
                return ReadRealFloat( pReservedIntArg1 )
            endif
        endif

        return -1. // to ensure failure
    endfunction

    function GetAgentTimerExtendedCooldown takes integer pTimerExt returns real
        local integer pData = 0

        if pTimerExt > 0 then
            set pData = ReadRealMemory( pTimerExt )

            if pData > 0 then
                call WriteRealMemory( pReservedIntArg2, 0 )
                call WriteRealMemory( pReservedIntArg3, 0 )
                call this_call_2( ReadRealMemory( pData + 0x10 ), pTimerExt, pReservedIntArg1 )
                call this_call_2( ReadRealMemory( pData + 0x1C ), pTimerExt, pReservedIntArg2 )
                return ReadRealFloat( pReservedIntArg1 ) - ReadRealFloat( pReservedIntArg2 )
            endif
        endif

        return -1. // to ensure failure
    endfunction
    
    function Init_APIMemoryGameData takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pGameState          = pGameDLL + 0xACD44C
                set pGameClass1         = pGameDLL + 0xACE5E0
                set pGetUnitAddress     = pGameDLL + 0x3BE7F0
                set pGetHandleId        = pGameDLL + 0x3A8BA0
                set pHandleIdToObject   = pGameDLL + 0x428B90
                set pObjectToHandleId   = pGameDLL + 0x4317C0
                set pGetDataNode        = pGameDLL + 0x4C9020
                set pGetAgentBaseData   = pGameDLL + 0x29B3E0
                set pGetAgentBaseUIData = pGameDLL + 0x31A350
                set pToJUnit            = pGameDLL + 0x2DD760
        elseif PatchVersion == "1.26a" then
                set pGameState          = pGameDLL + 0xAB65F4
                set pGameClass1         = pGameDLL + 0xAB7788
                set pGetUnitAddress     = pGameDLL + 0x3BDCB0
                set pGetHandleId        = pGameDLL + 0x3A8060
                set pHandleIdToObject   = pGameDLL + 0x428050
                set pObjectToHandleId   = pGameDLL + 0x430C80
                set pGetDataNode        = pGameDLL + 0x4C8520
                set pGetAgentBaseData   = pGameDLL + 0x2B88A0
                set pGetAgentBaseUIData = pGameDLL + 0x319810
                set pToJUnit            = pGameDLL + 0x2DCC40
        elseif PatchVersion == "1.27a" then
                set pGameState          = pGameDLL + 0xBE4238 // Inside ExecuteFunc | under Concurrency::details::ContextBase dword_... = v3
                set pGameClass1         = pGameDLL + 0xBE40A8 // "DispatchUnitSelectionModify Start for player %d" -> & 0x7FFFFFFFu) >= *(_DWORD *)(dword_6F... + 60
                set pGetUnitAddress     = pGameDLL + 0x1D1550 // WaygateSetDestination -> result = (signed int *)
                set pGetHandleId        = pGameDLL + 0x1C3200 // this + 7, 0, 0, 0);
                set pHandleIdToObject   = pGameDLL + 0x268380 // this[103] + 12 * a2 - 12582908);
                set pObjectToHandleId   = pGameDLL + 0x2651D0 // (_DWORD *)(v4[112] + 12 * (v5 & v8));
                set pGetDataNode        = pGameDLL + 0x17A710 // for ( i = -286331154; v1; i += v4 + 32 * i + v2
                set pGetAgentBaseData   = pGameDLL + 0x0352A0 // first while ( *result != a2 || result[5] != *a3 )
                set pGetAgentBaseUIData = pGameDLL + 0x021BD0
                set pToJUnit            = pGameDLL + 0x88F250 // GetCreepCamp -> JUMPOUT(&loc_6F...);
        elseif PatchVersion == "1.27b" then
                set pGameState          = pGameDLL + 0xD687A8
                set pGameClass1         = pGameDLL + 0xD68610
                set pGetUnitAddress     = pGameDLL + 0x1EEF90
                set pGetHandleId        = pGameDLL + 0x1E0D70
                set pHandleIdToObject   = pGameDLL + 0x285FE0
                set pObjectToHandleId   = pGameDLL + 0x282E30
                set pGetDataNode        = pGameDLL + 0x198420
                set pGetAgentBaseData   = pGameDLL + 0x052480
                set pGetAgentBaseUIData = pGameDLL + 0x03ECD0
                set pToJUnit            = pGameDLL + 0x9BA350
        elseif PatchVersion == "1.28f" then
                set pGameState          = pGameDLL + 0xD305E0
                set pGameClass1         = pGameDLL + 0xD30448
                set pGetUnitAddress     = pGameDLL + 0x2217A0
                set pGetHandleId        = pGameDLL + 0x2135F0
                set pHandleIdToObject   = pGameDLL + 0x2B8490
                set pObjectToHandleId   = pGameDLL + 0x2B52E0
                set pGetDataNode        = pGameDLL + 0x1CACC0
                set pGetAgentBaseData   = pGameDLL + 0x07BFE0
                set pGetAgentBaseUIData = pGameDLL + 0x069D60
                set pToJUnit            = pGameDLL + 0x96F2E0
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryGameData takes nothing returns nothing
    //set gg_trg_APIMemoryGameData = CreateTrigger(  )
endfunction
//! endnocjass
