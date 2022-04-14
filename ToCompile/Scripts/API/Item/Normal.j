//TESH.scrollpos=84
//TESH.alwaysfold=0
//! nocjass
library MemoryHackItemNormalAPI
    globals
        integer pStartItemCD = 0
        integer pUnitAddItemVirtual=0
    endglobals

	function StartAddressItemCooldown takes integer pUnit, integer pItem, real cd returns nothing
		local integer pInv  = 0

		if pUnit > 0 and pItem > 0 then
			set pInv = ReadRealMemory( pUnit + 0x1F8 )

			if pInv > 0 then
				call WriteRealMemory( pReservedWritableMemory, SetRealIntoMemory( cd ) )
				call this_call_4( pStartItemCD, pInv, pItem, pReservedWritableMemory, pReservedWritableMemory )
			endif
		endif
	endfunction

    function SetAddressItemIdType takes integer pItem, integer id returns nothing
        local integer oldId   = 0

        if pItem > 0 then
            set oldId = ReadRealMemory( pItem + 0x30 )

            if oldId > 0 then
                call WriteRealMemory( pItem + 0x30, id )
            endif
        endif
    endfunction
    
    function SetAddressItemModel takes integer pItem, string model returns nothing
        call SetObjectModel( pItem, model )
    endfunction
    
    function GetAddressItemLife takes integer pItem returns real
        if pItem > 0 then
            return GetRealFromMemory( ReadRealMemory( pItem + 0x58 ) )
        endif
        
        return 0.
    endfunction

    function SetAddressItemLife takes integer pItem, real life returns nothing
        if pItem > 0 then
            call WriteRealMemory( pItem + 0x58, SetRealIntoMemory( life ) )
        endif
    endfunction

    function GetAddressItemMaxLife takes integer pItem returns real
        if pItem > 0 then
            return GetRealFromMemory( ReadRealMemory( pItem + 0x60 ) )
        endif
        
        return 0.
    endfunction

    function SetAddressItemMaxLife takes integer pItem, real life returns nothing
        if pItem > 0 then
            call WriteRealMemory( pItem + 0x60, SetRealIntoMemory( life ) )
        endif
    endfunction

    function StartItemCooldown takes unit u, item it, real cd returns nothing
		call StartAddressItemCooldown( ConvertHandle( u ), ConvertHandle( it ), cd )
	endfunction

    function SetItemIdType takes item it, integer id returns nothing
        call SetAddressItemIdType( ConvertHandle( it ), id )
    endfunction
    
    function SetItemModel takes item it, string model returns nothing
        call SetAddressItemModel( ConvertHandle( it ), model )
    endfunction
    
    function GetItemLife takes item it returns real
        return GetAddressItemLife( ConvertHandle( it ) )
    endfunction

    function SetItemLife takes item it, real life returns nothing
        call SetAddressItemLife( ConvertHandle( it ), life )
    endfunction

    function GetItemMaxLife takes item it returns real
        return GetAddressItemMaxLife( ConvertHandle( it ) )
    endfunction

    function SetItemMaxLife takes item it, real life returns nothing
        call SetAddressItemMaxLife( ConvertHandle( it ), life )
    endfunction

    function UnitAddItemVirtual takes unit u,item i returns nothing
    if(u==null)then
    return
    endif
    if(i==null)then
    return
    endif
    call UnitAddItem(u,i)
    call this_call_6(pUnitAddItemVirtual,ConvertHandle(i),GetUnitAddress(u),0,0,1,0)
    endfunction
    function UnitAddItemVirtualbyId takes unit u,integer iid returns nothing
    local item titem=CreateItem(iid,GetUnitX(u),GetUnitY(u))
    if(u==null)then
    return
    endif
    if(titem!=null)then
    call UnitAddItem(u,titem)
    call UnitAddItemVirtual(u,titem)
    call RemoveItem(titem)
    endif
    set titem=null
    endfunction

    function Init_MemHackItemNormalAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pStartItemCD    = pGameDLL + 0x0E4B50
                set pUnitAddItemVirtual = pGameDLL+0x2B9600
        elseif PatchVersion == "1.26a" then
                set pStartItemCD    = pGameDLL + 0x0E3F30
        elseif PatchVersion == "1.27a" then
                set pStartItemCD    = pGameDLL + 0x54C2E0
        elseif PatchVersion == "1.27b" then
                set pStartItemCD    = pGameDLL + 0x569A40
        elseif PatchVersion == "1.28f" then
                set pStartItemCD    = pGameDLL + 0x59DB70
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackItemNormalAPI takes nothing returns nothing
    //set gg_trg_MemHackItemNormalAPI = CreateTrigger(  )
endfunction
//! endnocjass