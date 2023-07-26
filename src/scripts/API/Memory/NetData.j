//! nocjass
library APIMemoryNetData
    globals
        integer pGetEngineDataPointers = 0
    endglobals

    function GetDataHash takes integer pData returns integer
		local integer pVFTable = ReadRealMemory(pData)
		local integer pfunc = ReadRealMemory(pVFTable)
        return this_call_1(pfunc,pData)
    endfunction
    
    function GetEngineDataPointersWithId takes integer id returns integer
        return this_call_1(pGetEngineDataPointers,id)
    endfunction
    
    function GetEngineDataPTRS takes nothing returns integer
        return ReadRealMemory(GetEngineDataPointersWithId(0xd)+0x10)
    endfunction
    
    function GetNetData takes nothing returns integer
        return ReadRealMemory(GetEngineDataPTRS()+0x8)
    endfunction
    
    function GetNetHash takes nothing returns integer
        return GetDataHash(GetNetData())
    endfunction
    
    function GetGameHash takes nothing returns integer
        return GetDataHash(ReadRealMemory(pGameState))
    endfunction
    

    //===========================================

    function Init_APIMemoryNetData takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
            elseif PatchVersion == "1.26a" then
                set pGetEngineDataPointers = pGameDLL + 0x4c34d0
            elseif PatchVersion == "1.27a" then
            elseif PatchVersion == "1.27b" then
            elseif PatchVersion == "1.28f" then
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryNetData takes nothing returns nothing
    //set gg_trg_APIMemoryGameWindow = CreateTrigger(  )
endfunction
//! endnocjass
