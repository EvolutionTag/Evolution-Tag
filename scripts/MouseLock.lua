function mouseswap()
	if(not lockmouse) then
		if(not IsInGame() or (ReadRealMemory(GetGameUI(0,0)+0x25C)~=0)) then return end
		lockmouse = event:new(EVENT_ID_SCREEN_UPDATE,function()
		local ui = GetGameUI(0,0)
		if(not ui or ui == 0 ) then UpdateMouseLock(false); event.disconnect(lockmouse); lockmouse = nil return end
		if(ReadRealMemory(ui+0x25C)==0) then
			UpdateMouseLock(true)
		else
			UpdateMouseLock(false)
		end
		end)
	else
		 event.disconnect(lockmouse); lockmouse = nil
	end
end