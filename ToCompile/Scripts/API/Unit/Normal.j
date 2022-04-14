//TESH.scrollpos=30
//TESH.alwaysfold=0
//! nocjass
library MemoryHackUnitNormalAPI
    globals
        integer pUnitData                   = 0
        integer pRedrawUnit                 = 0
        integer pCommonSilence              = 0
        integer pPauseUnitDisabler          = 0
        integer pSetStunToUnit              = 0
        integer pUnsetStunToUnit            = 0
        integer pSetUnitTexture             = 0
        integer pGetHeroNeededXP            = 0

        integer pMorphUnitToTypeId          = 0
        integer pUpdateHeroBar              = 0
        integer pRefreshPortraitIfSelected  = 0
        integer pRefreshInfoBarIfSelected   = 0
    endglobals

    function GetUnitTypeIdReal takes unit u returns integer
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return ReadRealMemory( pData + 0x30 )
        endif

        return 0
    endfunction

    function SetUnitTypeId takes unit u, integer i returns nothing
        // Note: This is simply change for portrait and some cosmetic stuff!
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            call WriteRealMemory( pData + 0x30, i )
        endif
    endfunction

    function MorphUnitToTypeId takes unit u, integer id returns integer
        // This function imitates spells like Metamorphosis etc, but without additional leaks.
        local integer pUnit = ConvertHandle( u )

        if pUnit > 0 then
            if ReadRealMemory( pUnit + 0x30 ) != id then
                if pMorphUnitToTypeId > 0 and pUpdateHeroBar > 0 and pRefreshPortraitIfSelected > 0 and pRefreshInfoBarIfSelected > 0 then
                    call this_call_11( pMorphUnitToTypeId, pUnit, id, 1282, 0, 0, 2, 2, 1, 0, 0, 0 )
                    call this_call_2( pUpdateHeroBar, pUnit, 0 )
                    call this_call_2( pRefreshPortraitIfSelected, pUnit, 1 )
                    return this_call_1( pRefreshInfoBarIfSelected, pUnit )
                endif
            endif
        endif

        return 0
    endfunction

    function GetHeroNeededXPForLevel takes unit u, integer level returns integer
        local integer pUnit = ConvertHandle( u )

        if pUnit > 0 then
            if IsUnitType( u, UNIT_TYPE_HERO ) then
                if pGetHeroNeededXP > 0 then
                    return this_call_2( pGetHeroNeededXP, pUnit, level )
                endif
            endif
        endif

        return 0
    endfunction

    function GetHeroNeededXP takes unit u returns integer
        return GetHeroNeededXPForLevel( u, GetUnitLevel( u ) )
    endfunction

    function GetUnitVertexColour takes unit u returns integer
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return ReadRealMemory( pData + 0x2D4 )
        endif

        return 0
    endfunction

	function GetUnitVertexColourA takes unit u returns integer
        return GetByteFromInteger( GetUnitVertexColour( u ), 1 )
	endfunction

	function GetUnitVertexColourR takes unit u returns integer
        return GetByteFromInteger( GetUnitVertexColour( u ), 2 )
	endfunction

	function GetUnitVertexColourG takes unit u returns integer
        return GetByteFromInteger( GetUnitVertexColour( u ), 3 )
	endfunction

	function GetUnitVertexColourB takes unit u returns integer
        return GetByteFromInteger( GetUnitVertexColour( u ), 4 )
	endfunction

    function SetUnitModel takes unit u, string model returns nothing
        call SetObjectModel( ConvertHandle( u ), model )
    endfunction

    function SetUnitTexture takes unit u, string texturepath, integer textureId returns integer
        local integer pUnit = ConvertHandle( u )
        local integer pTexture = 0

        if pUnit > 0 then
            if texturepath != "" then
                set pTexture = LoadCBackDropFrameTexture( texturepath, false )

                if pTexture > 0 and textureId > 0 then
                    return fast_call_3( pSetUnitTexture, ReadRealMemory( pUnit + 0x28 ), pTexture, textureId )
                endif
            endif
        endif

        return 0
    endfunction
    
    function GetUnitImpactZ takes unit u returns real
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return GetRealFromMemory( ReadRealMemory( pData + 0x228 ) )
        endif

        return 0.
    endfunction

    function SetUnitImpactZ takes unit u, real impactZ returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            call WriteRealMemory( pData + 0x228, SetRealIntoMemory( impactZ ) )
        endif
    endfunction

    function RedrawUnit takes unit u returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            call this_call_1( pRedrawUnit, pData )
        endif
    endfunction

    function IsAttackDisabled takes unit u returns boolean
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1E8 )

            if pData > 0 then
                return ReadRealMemory( pData + 0x40 ) > 0
            endif
        endif

        return false
    endfunction

    function UnitDisableAttack takes unit u returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1E8 )

            if pData > 0 then
                call WriteRealMemory( pData + 0x40, 0 )
            endif
        endif
    endfunction
    
    function UnitEnableAttack takes unit u returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1E8 )

            if pData > 0 then
                call WriteRealMemory( pData + 0x40, 1 )
            endif
        endif
    endfunction

    function GetUnitCritterFlag takes unit u returns integer
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            // 0 - normal | 1 - critter
            return ReadRealMemory( pData + 0x60 )
        endif

        return -1
    endfunction

    function SetUnitCritterFlag takes unit u, integer id returns nothing
        // Acts similar to 'Amec', meaning if unit has flag equal to 1
        // then he is considered a creep and will be ignored by autoattacks.
        // However, an attack may still be forced with 'A' key or rightclick
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            if id >= 0 and id <= 1 then
                call WriteRealMemory( pData + 0x60, id )
            endif
        endif
    endfunction
    
    function GetUnitTimedLife takes unit u returns real
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = GetUnitAbility( u, 'BTLF' )

            if pData > 0 then
                set pData = ReadRealMemory( pData + 0x90 )

                if pData > 0 then
                    return GetRealFromMemory( ReadRealMemory( pData + 0x4 ) )
                endif
            endif
        endif

        return 0.
    endfunction

    function SetUnitTimedLife takes unit u, real dur returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = GetUnitAbility( u, 'BTLF' )

            if pData > 0 then
                set pData = ReadRealMemory( pData + 0x90 )

                if pData > 0 then
                    call WriteRealMemory( pData + 0x4, SetRealIntoMemory( dur ) )
                endif
            endif
        endif
    endfunction

    function SetUnitPhased takes unit u returns nothing
        // Must be used with a slight delay AFTER cast, the minimum is one frame after successful cast!
        local integer data  = GetUnitBaseDataById( GetUnitTypeId( u ) ) + 0x1AC
        local integer p1    = ReadRealMemory( data )
        local integer p2    = ReadRealMemory( data + 0x4 )

        call WriteRealMemory( data, 0x8 )
        call WriteRealMemory( data + 0x4, 0x10 )
        call SetUnitPathing( u, true )
        call WriteRealMemory( data, p1 )
        call WriteRealMemory( data + 0x4, p2 )
    endfunction

    function UnitApplySilence takes unit u, boolean flag returns nothing
        local integer pUnit = ConvertHandle( u )

        if pUnit > 0 then
            call this_call_2( pCommonSilence, pUnit, B2I( flag ) )
        endif
    endfunction

    function UnitDisableAbilities takes unit u, boolean flag returns nothing
        // Visually equal to pause: all skills are hidden and silenced
        local integer pUnit = ConvertHandle( u )

        if pUnit > 0 then
            call this_call_5( pPauseUnitDisabler, pUnit, 1, B2I( flag ), 0, 0 )
        endif
    endfunction
    
	function UnitSetStunFlag takes unit u, boolean add returns nothing
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            if add then						 
                call this_call_2( pSetStunToUnit, ConvertHandle( u ), ConvertHandle( u ) )
            else
                call this_call_1( pUnsetStunToUnit, ConvertHandle( u ) )
            endif
        endif
	endfunction

	function IsUnitStunned takes unit u returns boolean
        local integer pHandle = ConvertHandle( u )
        
        if pHandle > 0 then
            return ReadRealMemory( pHandle + 0x198 ) > 0
        endif

		return false
	endfunction

	function UnitApplyStun takes unit u returns nothing //unsafe, do not use unless you tested it through
        local integer pHandle = ConvertHandle( u )

        if pHandle > 0 then
            call WriteRealMemory( pHandle + 0x198, 0 )
        endif
	endfunction

	function IsUnitMovementDisabled takes unit u returns boolean
		local integer pdata = GetHandleId( u )

		if pdata > 0 then
			set pdata = ConvertHandle( u )

			if pdata > 0 then
                set pdata = ReadRealMemory( pdata + 0x1EC )

				if pdata > 0 then
                    return ReadRealMemory( pdata + 0x7C ) > 0
                endif
            endif
        endif

        return false
	endfunction

    function SetUnitControl takes unit u, integer flagval, integer moveval, integer atackval, integer invval returns nothing
		local integer pUnit = ConvertHandle( u )
		local integer flags
		local integer Amov
		local integer Aatk
        local integer AInv 

        if pUnit > 0 then
            set flags = ReadRealMemory( pUnit + 0x248 )
            set Aatk  = ReadRealMemory( pUnit + 0x1E8 )
            set Amov  = ReadRealMemory( pUnit + 0x1EC )
            set AInv  = ReadRealMemory( pUnit + 0x1F8 )
            
            if not IsFlagBitSet( flags, 512 ) then
                call WriteRealMemory( pUnit + 0x248, flags + flagval )
            endif

            if Amov > 0 then
                call WriteRealMemory( Amov + 0x40, ReadRealMemory( Amov + 0x40 ) + moveval )
            endif

            if Aatk > 0 then
                call WriteRealMemory( Aatk + 0x40, ReadRealMemory( Aatk + 0x40 ) + atackval )
            endif

            if AInv > 0 then
                call WriteRealMemory( AInv + 0x3C, ReadRealMemory( AInv + 0x3C ) + invval )
            endif
        endif
    endfunction

	function UnitDisableControl takes unit u returns nothing
		//Hides all command buttons and sets the Ward flag. Unit will keep its current order, and player can’t give new orders
		//Notice the the unit can’t be ordered with triggers as well. To issue an order you need to temporarily reenable control
        call SetUnitControl( u, 512, 1, 1, 1 )
	endfunction

	function UnitEnableControl takes unit u returns nothing
		//Removes the Ward flag and reenables Amov and Aatk
        call SetUnitControl( u, -512, -1, -1, -1 )
	endfunction

	function UnitRemoveMovementDisables takes unit u returns nothing
		local integer pData = ConvertHandle( u )

		if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1EC )

            if pData > 0 then
                call WriteRealMemory( ReadRealMemory( pData + 0x1EC ) + 0x7C, 0 )
            endif
		endif
	endfunction

	function SetUnitMovement takes integer pData, boolean flag returns nothing
        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1EC )

            if pData > 0 then
                call WriteRealMemory( pData + 0x7C, B2I( not flag ) ) //  ReadRealMemory( pdata ) + d
            endif
        endif
	endfunction

	function UnitEnableMovement takes unit u returns nothing
		if u == null then
			return
		endif

		call SetUnitMovement( ConvertHandle( u ), false )
	endfunction

	function UnitDisableMovement takes unit u returns nothing
		if u == null then
			return
		endif

		call SetUnitMovement( ConvertHandle( u ), true )
	endfunction

	function UnitDisableMovementEx takes unit u, boolean disable returns nothing
		local integer i = 2
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            if not disable then
                set i = 1
            endif

            call PauseUnit( u, true )
            set pData = ReadRealMemory( pData + 0x1EC )
            
            if pData > 0 then
                call SetAddressAbilityDisabled( pData, i ) //pointer to 'Amov' is located at offset 123 of unit object, Aatk is at offset 122, and AInv is offset 124
            endif

            call PauseUnit( u, false )
        endif
	endfunction

    function IsUnitInventoryDisabled takes unit u returns boolean
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1F8 )

            if pData > 0 then
                return I2B( ReadRealMemory( pData + 0x3C ) )
            endif
        endif
    
        return false
    endfunction
    
	function UnitEnableInventory takes unit u, boolean flag returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1F8 )

            if pData > 0 then
                set pData = pData + 0x3C
                call WriteRealMemory( pData, B2I( not flag ) )
            endif
        endif
	endfunction

	function GetAddressLocustFlags takes integer pAddr1, integer pAddr2 returns integer
		local integer i = GetSomeAddress( pAddr1, pAddr2 )

		return ReadRealMemory( i + 0x94 )
	endfunction

	function SetLocustFlags takes unit u, integer i returns nothing //These flags can make unit immune to truesight
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            set pData = pData + 0x16C
            set pData = GetAddressLocustFlags( ReadRealMemory( pData ), ReadRealMemory( pData + 4 ) )

            if pData > 0 then
                call WriteRealMemory( pData + 0x34, i )
            endif
        endif
	endfunction

	function UnitEnableTruesightImmunity takes unit u returns nothing
		call SetLocustFlags( u, 0x08000000 ) //I don’t really know what other side effects may be caused by this, at least GroupEnum is not affected
	endfunction

	function UnitDisableTruesightImmunity takes unit u returns nothing
		call SetLocustFlags( u, 0 )
	endfunction

	function GetUnitFlags takes unit u returns integer
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            return ReadRealMemory( pData + 0x20 )
        endif

        return 0
	endfunction

	function SetUnitFlags takes unit u, integer i returns nothing
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            call WriteRealMemory( pData + 0x20, i )
        endif
	endfunction

    function AddUnitFlags takes unit u, integer i returns nothing
        call SetUnitFlags( u, GetUnitFlags( u ) + i )
    endfunction
    
	function GetUnitFlags_2 takes unit u returns integer
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            return ReadRealMemory( pData + 0x5C )
        endif

        return 0
	endfunction

	function SetUnitFlags_2 takes unit u, integer i returns nothing
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            call WriteRealMemory( pData + 0x5C, i )
        endif
	endfunction

    function AddUnitFlags_2 takes unit u, integer i returns nothing
        call SetUnitFlags_2( u, GetUnitFlags_2( u ) + i )
    endfunction

	function GetUnitVisibilityClass takes unit u returns integer
		local integer a = ConvertHandle( u )
		local integer res = 0

		if a > 0 then
			set res = ReadRealMemory( a + 0x130 )

			if res > 0 then
				set res = GetSomeAddressForAbility( res, ReadRealMemory( a + 0x134 ) )
			endif
		endif

		return res
	endfunction

	function SetUnitVisibleByPlayer takes unit u, player p, integer c returns nothing
		local integer a = GetUnitVisibilityClass( u )

		if a > 0 then
			call WriteRealMemory( a + 0x2C + 4 * GetPlayerId( p ), c )
			if c > 0 and not IsFlagBitSet( ReadRealMemory( a + 0x24 ), Player2Flag( p ) ) then
				call WriteRealMemory( a + 0x24, ReadRealMemory( a + 0x24 ) + Player2Flag( p ) )
			elseif c==0 and IsFlagBitSet( ReadRealMemory( a + 0x24 ), Player2Flag( p ) ) then
				call WriteRealMemory( a + 0x24, ReadRealMemory( a + 0x24 ) - Player2Flag( p ) )
			endif
		endif
	endfunction

	function IsUnitInvulnerable takes unit u returns boolean
		local integer pData = ConvertHandle( u )

		if pData > 0 then
			return IsFlagBitSet( ReadRealMemory( pData + 0x20 ), 8 )
		endif

        return false
	endfunction

    function GetUnitInvulnerableCounter takes unit u returns integer
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return ReadRealMemory( pData + 0xE8 )
        endif

        return 0
    endfunction

    function SetUnitInvulnerableCounter takes unit u, integer i returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            call WriteRealMemory( pData + 0xE8, i )
        endif
    endfunction

    function ModifyInvulnerableCounter takes unit u, integer diff returns nothing
        if u != null then
            call SetUnitInvulnerableCounter( u, GetUnitInvulnerableCounter( u ) + diff )
        endif
    endfunction

    function IsUnitInvulnerable2 takes unit u returns boolean
        return GetUnitInvulnerableCounter( u ) > 0
    endfunction

	function SetUnitFacingInstant takes unit u, real a returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = GetUnitAddressFloatsRelated( pData, 0xA0 )

            if pData > 0 then
                set pData = ReadRealMemory( pData + 0x28 )
                
                if pData > 0 then
                    call SetUnitFacing( u, a )
                    call WriteRealMemory( pData + 0xA4, SetRealIntoMemory( Deg2Rad( a ) ) )
                endif
            endif
        endif
	endfunction

	function GetUnitMoveType takes unit u returns integer
		local integer pData = ConvertHandle( u )

		if pData > 0 then
			set pData = GetUnitAddressFloatsRelated( pData, 0x16C )

            if pData > 0 then
                set pData = ReadRealMemory( pData + 0xA8 )

                if pData > 0 then
                    return ReadRealMemory( pData + 0x9C )
                endif
            endif
		endif

		return 0
	endfunction

	function SetUnitMoveType takes unit u, integer m_type returns nothing
		// foot = 33554434 | fly = 67108868 | amph = -2147483520
		// This method only properly works if unit has FLY movement as default, els.
		// Meaning only a unit with default move type of flying can lose flying pathing and gain it back.
		local integer pData = ConvertHandle( u )

		if pData > 0 then
            set pData = GetUnitAddressFloatsRelated( pData, 0x16C )
            
            if pData > 0 then
                set pData = ReadRealMemory( pData + 0xA8 )

                if pData > 0 then
                    call WriteRealMemory( pData + 0x9C, m_type )
                endif
            endif
		endif
	endfunction

	function GetHeroPrimaryAttribute takes unit u returns integer //1 = str, 2 = int, 3 = agi
		local integer a = ConvertHandle( u )

		if a > 0 then
			set a = ReadRealMemory( a + 0x1F0 )

			if a > 0 then
				return ReadRealMemory( a + 0xCC )
			endif
		endif

		return 0
	endfunction

	function SetHeroPrimaryAttribute takes unit u, integer i returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            if IsUnitIdType( GetUnitTypeId( u ), UNIT_TYPE_HERO ) then
                set pData = ReadRealMemory( pData + 0x1F0 )

                if pData > 0 then
                    call WriteRealMemory( pData + 0xCC, i )
                endif
            endif
        endif
	endfunction

	function GetUnitAttackAbility takes unit u returns integer
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            return ReadRealMemory( pData + 0x1E8 )
        endif
        
        return 0
	endfunction

    function SetUnitAttackAbility takes unit u, integer pAddr returns nothing
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            call WriteRealMemory( pData + 0x1E8, pAddr )
        endif
    endfunction
    
    function GetUnitAttackOffsetValue takes unit u, integer pOff returns integer
        local integer pData = GetUnitAttackAbility( u )

        if pData > 0 then
            return ReadRealMemory( pData + pOff )
        endif

        return 0
    endfunction

	function GetUnitNextAttackTimestamp takes unit u returns real
        local integer pData = GetUnitAttackAbility( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1E4 )

            if pData > 0 then
                return GetRealFromMemory( ReadRealMemory( pData + 0x4 ) )
            endif
        endif

        return -1.
	endfunction

	function UnitResetAttackCooldown takes unit u returns boolean
        local integer pData = GetUnitAttackAbility( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1E4 )

            if pData > 0 then
                call WriteRealMemory( pData + 0x1E4, 0 )
                return true
            endif
        endif

		return false
	endfunction

	function UnitNullifyCurrentAttack takes unit u returns string
        local integer pData = GetUnitAttackAbility( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1F4 )

            if pData > 0 then
                call WriteRealMemory( pData + 0x1F4, 0 )
                return "nulled"
            else
                return "already empty"
            endif
        else
            return "cannot attack"
        endif

		return "no attack has been found"
	endfunction

	function AddUnitExtraAttack takes unit u returns boolean
		local integer pData = GetUnitAttackAbility( u )
		local real attackdelay

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1E4 )

            if pData > 0 then
                set attackdelay = CleanReal( IndexToReal( ReadRealMemory( pData + 0x8 )  ) )

                if attackdelay > 0 then
                    call WriteRealMemory( pData + 0x4, CleanInt( RealToIndex( GetUnitNextAttackTimestamp( u ) - attackdelay ) ) )
                    return true
                endif
            endif
        endif

		return false
	endfunction

	function GetUnitAttackTypeByIndex takes unit u, integer index returns integer
        if index == 0 or index == 1 then
            return GetUnitAttackOffsetValue( u, 0xF4 + 4 * index )
        endif

        return -1
	endfunction

	function GetUnitAttackType1 takes unit u returns integer
		return GetUnitAttackTypeByIndex( u, 0 )
	endfunction

	function GetUnitAttackType2 takes unit u returns integer
		return GetUnitAttackTypeByIndex( u, 1 )
	endfunction

    function SetUnitAttackOffsetValue takes unit u, integer offset, integer val returns nothing
        local integer pData = GetUnitAttackAbility( u )

        if pData > 0 then
            call WriteRealMemory( pData + offset, val )
        endif
    endfunction
    
	function SetUnitAttackTypeByIndex takes unit u, integer i, integer attacknum returns nothing
        //6 = hero, 5 = chaos, 4 = magic, 3 = siege, 2 = piercing, 1 = normal, 0 = spell?
        //values over 6 takes incorrect multipliers from nearby memory, do not use them
        call SetUnitAttackOffsetValue( u, 0xF4 + 4 * attacknum, i )
	endfunction

	function SetUnitAttackType1 takes unit u, integer i returns nothing
		call SetUnitAttackTypeByIndex( u, i, 0 )
	endfunction

	function SetUnitAttackType2 takes unit u, integer i returns nothing
		call SetUnitAttackTypeByIndex( u, i, 1 )
	endfunction

    function GetUnitWeaponSound takes unit u returns integer
        return GetUnitAttackOffsetValue( u, 0xE8 )
    endfunction

    function SetUnitWeaponSound takes unit u, integer i returns nothing
        call SetUnitAttackOffsetValue( u, 0xE8, i )
    endfunction
    
	function GetUnitWeaponType takes unit u returns integer
        return GetUnitAttackOffsetValue( u, 0xDC )
	endfunction
    
	function SetUnitWeaponType takes unit u, integer i returns nothing
        // unit's weapon type is melee, ranged, splash, artillery, etc -> 0 = melee, 1 = instant, 2 = ranger, 5 = splash, 6 = mbounce | up to 8
		call SetUnitAttackOffsetValue( u, 0xDC, i )
	endfunction

	function GetUnitBaseDamage takes unit u returns integer
		return GetUnitAttackOffsetValue( u, 0xA0 )
	endfunction

	function SetUnitBaseDamage takes unit u, integer i returns nothing
		call SetUnitAttackOffsetValue( u, 0xA0, i )
	endfunction

	function AddUnitBaseDamage takes unit u, integer bonus returns nothing
		call SetUnitBaseDamage( u, GetUnitBaseDamage( u ) + bonus )
	endfunction

	function GetUnitBonusDamage takes unit u returns integer
		return GetUnitAttackOffsetValue( u, 0xAC )
	endfunction

	function SetUnitBonusDamage takes unit u, integer i returns nothing
        //setting green bonus automatically adjusts base damage to fit
		call SetUnitAttackOffsetValue( u, 0xAC, i )
	endfunction

	function AddUnitBonusDamage takes unit u, integer i returns nothing
		call SetUnitBonusDamage( u, GetUnitBonusDamage( u ) + i )
	endfunction

	function GetUnitTotalDamage takes unit u returns integer
		return GetUnitBaseDamage( u ) + GetUnitBonusDamage( u )
	endfunction

	function GetUnitBaseAttributeDamage takes unit u returns integer
		return GetUnitAttackOffsetValue( u, 0xA4 )
	endfunction

	function SetUnitBaseAttributeDamage takes unit u, integer i returns nothing
		call SetUnitAttackOffsetValue( u, 0xA4, i )
	endfunction

	function GetUnitDamageDicesSideCount takes unit u returns integer
		return GetUnitAttackOffsetValue( u, 0x94 )
	endfunction

	function SetUnitDamageDicesSideCount takes unit u, integer i returns nothing
		call SetUnitAttackOffsetValue( u, 0x94, i )
	endfunction

	function GetUnitDamageDicesCount takes unit u returns integer
		return GetUnitAttackOffsetValue( u, 0x88 )
	endfunction
    
	function SetUnitDamageDicesCount takes unit u, integer i returns nothing
		call SetUnitAttackOffsetValue( u, 0x88, i )
	endfunction

    function GetUnitAttackRangeByIndex takes unit u, integer index returns real
        if index == 0 or index == 1 then
            return GetRealFromMemory( GetUnitAttackOffsetValue( u, 0x258 + 0x24 * index ) )
        endif

        return 0.
    endfunction

    function SetUnitAttackRangeByIndex takes unit u, integer index, real r returns nothing
        if index == 0 or index == 1 then
            call SetUnitAttackOffsetValue( u, 0x258 + 0x24 * index, SetRealIntoMemory( r ) )
        endif
    endfunction
    
    function GetUnitAttackRange1 takes unit u returns real
        return GetUnitAttackRangeByIndex( u, 0 )
    endfunction 

	function SetUnitAttackRange1 takes unit u, real r returns nothing
        call SetUnitAttackRangeByIndex( u, 0, r )
	endfunction

	function GetUnitAttackRange2 takes unit u returns real
		return GetUnitAttackRangeByIndex( u, 1 )
	endfunction

	function SetUnitAttackRange2 takes unit u, real r returns nothing
       call SetUnitAttackRangeByIndex( u, 1, r )
	endfunction

    function GetUnitBATByIndex takes unit u, integer index returns real
        if index == 0 or index == 1 then
            return GetRealFromMemory( GetUnitAttackOffsetValue( u, 0x158 + 0x8 * index ) )
        endif

        return 0.
    endfunction

    function SetUnitBATByIndex takes unit u, integer index, real r returns nothing
        if index == 0 or index == 1 then
            call SetUnitAttackOffsetValue( u, 0x158 + 0x8 * index, SetRealIntoMemory( r ) )
        endif
    endfunction

	function GetUnitBAT1 takes unit u returns real
        return GetUnitBATByIndex( u, 0 )
	endfunction

	function SetUnitBAT1 takes unit u, real r returns nothing
        call SetUnitBATByIndex( u, 0, r )
	endfunction

	function GetUnitBAT2 takes unit u returns real
        return GetUnitBATByIndex( u, 1 )
	endfunction
    
	function SetUnitBAT2 takes unit u, real r returns nothing
        call SetUnitBATByIndex( u, 1, r )
	endfunction

    function GetUnitAttackPointByIndex takes unit u, integer index returns real
        if index == 0 or index == 1 then
            return GetRealFromMemory( GetUnitAttackOffsetValue( u, 0x16C + 0x10 * index ) )
        endif

        return 0.
    endfunction

    function SetUnitAttackPointByIndex takes unit u, integer index, real r returns nothing
        if index == 0 or index == 1 then
            call SetUnitAttackOffsetValue( u, 0x16C + 0x10 * index, SetRealIntoMemory( r ) )
        endif
    endfunction
    
	function GetUnitAttackPoint1 takes unit u returns real
        return GetUnitAttackPointByIndex( u, 0 )
	endfunction
    
	function SetUnitAttackPoint1 takes unit u, real r returns nothing
        call SetUnitAttackPointByIndex( u, 0, r )
	endfunction

	function GetUnitAttackPoint2 takes unit u returns real
        return GetUnitAttackPointByIndex( u, 1 )
	endfunction

	function SetUnitAttackPoint2 takes unit u, real r returns nothing
        call SetUnitAttackPointByIndex( u, 1, r )
	endfunction

	function GetUnitAttackEnabledIndex takes unit u returns integer
        return GetUnitAttackOffsetValue( u, 0x104 )
	endfunction

	function GetUnitAttackBackswing takes unit u returns real
        return GetRealFromMemory( GetUnitAttackOffsetValue( u, 0x190 ) )
	endfunction 

	function SetUnitAttackBackswing takes unit u, real r returns nothing
        call SetUnitAttackOffsetValue( u, 0x190, SetRealIntoMemory( r ) )
	endfunction

	function GetUnitAttackSpeed takes unit u returns real
        return GetRealFromMemory( GetUnitAttackOffsetValue( u, 0x1B0 ) )
	endfunction
    
	function SetUnitAttackSpeed takes unit u, real r returns nothing
        call SetUnitAttackOffsetValue( u, 0x1B0, SetRealIntoMemory( r ) )
	endfunction

	function AddUnitAttackSpeed takes unit u, real r returns nothing
		call SetUnitAttackSpeed( u, GetUnitAttackSpeed( u ) + r )
	endfunction

    function GetUnitAttackDamage takes unit u returns real
        local integer dmg = GetUnitDamageDicesCount( u )
        local integer spread = GetRandomInt( dmg, dmg * GetUnitDamageDicesSideCount( u ) )

        return I2R( GetUnitBaseDamage( u ) + GetUnitBonusDamage( u ) + spread )
    endfunction
    
	function GetUnitArmourType takes unit u returns integer
        //armor types: 0 - Light; 1 - Medium; 2 - Heavy; 3 - Fortified; 4 - Normal; 5 - Hero; 6 - Divine; 7 - unarmored; | rest seems to have Light properties
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return ReadRealMemory( pData + 0xE4 )
        endif

		return 0
	endfunction

	function SetUnitArmourType takes unit u, integer id returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            call WriteRealMemory( pData + 0xE4, id )
        endif
	endfunction

	function GetUnitArmour takes unit u returns real
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return GetRealFromMemory( ReadRealMemory( pData + 0xE0 ) )
        endif
		
        return 0.
	endfunction

	function SetUnitArmour takes unit u, real r returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            call WriteRealMemory( pData + 0xE0, SetRealIntoMemory( r ) )
        endif
	endfunction

	function AddUnitArmour takes unit u, real value returns nothing
		call SetUnitArmour( u, GetUnitArmour( u ) + value )
	endfunction

	function GetUnitTimeScale takes unit u returns real
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return GetRealFromMemory( ReadRealMemory( pData + 0x300 ) )
        endif

        return 0.
	endfunction

	function GetUnitBaseMoveSpeed takes unit u returns real
		local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1EC ) //Amov
            
            if pData > 0 then
                return GetRealFromMemory( ReadRealMemory( pData + 0x70 ) )
            endif
        endif

		return 0.
	endfunction

	function GetUnitBonusMoveSpeed takes unit u returns real
		local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1EC ) //Amov
            
            if pData > 0 then
                return GetRealFromMemory( ReadRealMemory( pData + 0x78 ) )
            endif
        endif

		return -1000. // To ensure we failed to get Bonus MoveSpeed.
	endfunction

	function SetUnitBonusMoveSpeed takes unit u, real r returns boolean
		local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1EC ) //Amov
            
            if pData > 0 then
                call WriteRealMemory( pData + 0x78, SetRealIntoMemory( r ) )
                call SetUnitMoveSpeed( u, GetRealFromMemory( ReadRealMemory( pData + 0x70 ) ) ) //required to update ms instantly
                return true
            endif
		endif

		return false
	endfunction

	function AddUnitBonusMovespeed takes unit u, real r returns nothing
		call SetUnitBonusMoveSpeed( u, GetUnitBonusMoveSpeed( u ) + r )
	endfunction

	function SetUnitMaxLife takes unit u, real newhp returns nothing
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            set pData = GetUnitAddressFloatsRelated( pData, 0xA0 )
            
            if pData > 0 then
                call WriteRealMemory( pData + 0x84, SetRealIntoMemory( newhp ) )
            endif
        endif
	endfunction

	function AddUnitMaxLife takes unit u, real value returns nothing
		call SetUnitMaxLife( u, GetUnitState( u, UNIT_STATE_MAX_LIFE ) + value )
	endfunction

	function SetUnitMaxMana takes unit u, real newmp returns nothing
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            set pData = GetUnitAddressFloatsRelated( pData, 0xC0 )
            
            if pData > 0 then
                call WriteRealMemory( pData + 0x84, SetRealIntoMemory( newmp ) )
            endif
        endif
	endfunction

	function AddUnitMaxMana takes unit u, real value returns nothing
		call SetUnitMaxMana( u, GetUnitState( u, UNIT_STATE_MAX_MANA ) + value )
	endfunction

	function GetWidgetLifeRegen takes widget u returns real
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            set pData = GetUnitAddressFloatsRelated( pData, 0xA0 )
            
            if pData > 0 then
                return GetRealFromMemory( ReadRealMemory( pData + 0x7C ) )
            endif
        endif

		return 0.
	endfunction

	function GetUnitLifeRegen takes unit u returns real
		return GetWidgetLifeRegen( u )
	endfunction

	function SetUnitLifeRegen takes unit u, real r returns nothing
        local integer pData = ConvertHandle( u )
		local real curhp    = GetWidgetLife( u )

        if pData > 0 then
            if curhp > 0 then
                set pData = GetUnitAddressFloatsRelated( pData, 0xA0 )
                
                if pData > 0 then
                    call WriteRealMemory( pData + 0x7C, SetRealIntoMemory( r ) )
                    call SetWidgetLife( u, curhp )
                endif
            endif
        endif
	endfunction

	function AddUnitLifeRegen takes unit u, real r returns nothing
		call SetUnitLifeRegen( u, GetUnitLifeRegen( u ) + r )
	endfunction

	function GetUnitManaRegen takes unit u returns real
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            set pData = GetUnitAddressFloatsRelated( pData, 0xC0 )
            
            if pData > 0 then
                return GetRealFromMemory( ReadRealMemory( pData + 0x7C ) )
            endif
        endif

		return 0.
	endfunction

	function SetUnitManaRegen takes unit u, real r returns nothing
        local integer pData = ConvertHandle( u )
		local real curmp = GetUnitState( u, UNIT_STATE_MANA )

        if pData > 0 then
            if curmp > 0 then
                set pData = GetUnitAddressFloatsRelated( pData, 0xC0 )
                
                if pData > 0 then
                    call WriteRealMemory( pData + 0x7C, SetRealIntoMemory( r ) )
                    call SetUnitState( u, UNIT_STATE_MANA, curmp )
                endif
            endif
        endif
	endfunction

    function MorphUnitToTypeIdNotSaveAbils takes unit u,integer id returns integer
        local integer pUnit=ConvertHandle(u)
        if pUnit>0 then
        if ReadRealMemory(pUnit+0x30)!=id then
        if pMorphUnitToTypeId>0 and pUpdateHeroBar>0 and pRefreshPortraitIfSelected>0 and pRefreshInfoBarIfSelected>0 then
        call this_call_11(pMorphUnitToTypeId,pUnit,id,1282,1,1,2,2,1,1,0,0)
        call this_call_2(pUpdateHeroBar,pUnit,0)
        call this_call_2(pRefreshPortraitIfSelected,pUnit,1)
        return this_call_1(pRefreshInfoBarIfSelected,pUnit)
        endif
        endif
        endif
        return 0
    endfunction

	function AddUnitManaRegen takes unit u, real r returns nothing
		call SetUnitManaRegen( u, GetUnitManaRegen( u ) + r )
	endfunction

    function Init_MemHackUnitNormalAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pUnitData                   = pGameDLL + 0xACB2B4
                set pRedrawUnit                 = pGameDLL + 0x285350
                set pCommonSilence              = pGameDLL + 0x0773A0
                set pPauseUnitDisabler          = pGameDLL + 0x077420
                set pSetStunToUnit              = pGameDLL + 0x270420
                set pUnsetStunToUnit            = pGameDLL + 0x283650
                set pSetUnitTexture             = pGameDLL + 0x4D3DE0
                set pGetHeroNeededXP            = pGameDLL + 0x208270
                set pMorphUnitToTypeId          = pGameDLL + 0x2A2A40
                set pUpdateHeroBar              = pGameDLL + 0x270970
                set pRefreshPortraitIfSelected  = pGameDLL + 0x270930
                set pRefreshInfoBarIfSelected   = pGameDLL + 0x270940
        elseif PatchVersion == "1.26a" then
                set pUnitData                   = pGameDLL + 0xAB445C
                set pRedrawUnit                 = pGameDLL + 0x284830
                set pCommonSilence              = pGameDLL + 0x076770
                set pPauseUnitDisabler          = pGameDLL + 0x0767F0
                set pSetStunToUnit              = pGameDLL + 0x2A6440
                set pUnsetStunToUnit            = pGameDLL + 0x282B30
                set pSetUnitTexture             = pGameDLL + 0x4D32E0
                set pGetHeroNeededXP            = pGameDLL + 0x26EB50
                set pMorphUnitToTypeId          = pGameDLL + 0x2A1F20
                set pUpdateHeroBar              = pGameDLL + 0x26FE50
                set pRefreshPortraitIfSelected  = pGameDLL + 0x26FE10
                set pRefreshInfoBarIfSelected   = pGameDLL + 0x26FE20
        elseif PatchVersion == "1.27a" then
                set pUnitData                   = pGameDLL + 0xBEC48C // "Unit '%s' missing required UI data - not valid in game.", -> v4 = dword_6F...
                set pRedrawUnit                 = pGameDLL + 0x67FB00
                set pCommonSilence              = pGameDLL + 0x471C40
                set pPauseUnitDisabler          = pGameDLL + 0x46F180
                set pSetStunToUnit              = pGameDLL + 0x66B600
                set	pUnsetStunToUnit            = pGameDLL + 0x65AE60
                set pSetUnitTexture             = pGameDLL + 0x186F40
                set pGetHeroNeededXP            = pGameDLL + 0x668050
                set pMorphUnitToTypeId          = pGameDLL + 0x653220
                set pUpdateHeroBar              = pGameDLL + 0x67FA80
                set pRefreshPortraitIfSelected  = pGameDLL + 0x676610
                set pRefreshInfoBarIfSelected   = pGameDLL + 0x676600
        elseif PatchVersion == "1.27b" then
                set pUnitData                   = pGameDLL + 0xD709F4
                set pRedrawUnit                 = pGameDLL + 0x69D240
                set pCommonSilence              = pGameDLL + 0x48F380
                set pPauseUnitDisabler          = pGameDLL + 0x48C8C0
                set pSetStunToUnit              = pGameDLL + 0x688D30
                set	pUnsetStunToUnit            = pGameDLL + 0x678590
                set pSetUnitTexture             = pGameDLL + 0x1A4C60
                set pGetHeroNeededXP            = pGameDLL + 0x685780
                set pMorphUnitToTypeId          = pGameDLL + 0x670950
                set pUpdateHeroBar              = pGameDLL + 0x69D1C0
                set pRefreshPortraitIfSelected  = pGameDLL + 0x693D40
                set pRefreshInfoBarIfSelected   = pGameDLL + 0x693D30
        elseif PatchVersion == "1.28f" then
                set pUnitData                   = pGameDLL + 0xD3882C
                set pRedrawUnit                 = pGameDLL + 0x6D13F0
                set pCommonSilence              = pGameDLL + 0x4C3490
                set pPauseUnitDisabler          = pGameDLL + 0x4C09D0
                set pSetStunToUnit              = pGameDLL + 0x6BCEC0
                set	pUnsetStunToUnit            = pGameDLL + 0x6AC6C0
                set pSetUnitTexture             = pGameDLL + 0x1D74F0
                set pGetHeroNeededXP            = pGameDLL + 0x6B9910
                set pMorphUnitToTypeId          = pGameDLL + 0x6A4A80
                set pUpdateHeroBar              = pGameDLL + 0x6D1370
                set pRefreshPortraitIfSelected  = pGameDLL + 0x6C7F00
                set pRefreshInfoBarIfSelected   = pGameDLL + 0x6C7EF0
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_MemHackUnitNormalAPI takes nothing returns nothing
    //set gg_trg_MemHackUnitNormalAPI = CreateTrigger(  )
endfunction
//! endnocjass
