if(not chatcommands) then

if(not Chatcommands) then
Chatcommands = {}
end

local function RunKey(e)
	return SmartCast.OnKey(e)
end


local function ReRunKey()
	return SmartCast.ProcessKeys()
end
Chatcommands["key"] = function() 
	if(not keyevent) then
		--gprint('registring keys')
		keyevent = event:new(EVENT_ID_KEY_INPUT, RunKey)
		periodickey = event:new(EVENT_ID_SCREEN_UPDATE,ReRunKey)
	else
		--gprint('unregistring keys')
		event.disconnect(keyevent)
		event.disconnect(periodickey)
		keyevent = nil
		periodickey = nil
	end
end

Chatcommands["ui"] = function() 
	initui()
end

Chatcommands["mouse"] = function()
	mouseswap()
end

Chatcommands["mh0"] = function()
	mh0()
end
Chatcommands["mh1"] = function()
	mh1()
end
Chatcommands["mh2"] = function()
	mh2()
end
Chatcommands["umh0"] = function()
	umh0()
end
Chatcommands["umh1"] = function()
	umh1()
end
Chatcommands["umh2"] = function()
	umh2()
end
Chatcommands["screen"] = function(s)
	Widescreen(s)
end
Chatcommands["info"] = function(s)
	Info(s)
end
Chatcommands["camz"] = function(s)
	CamZ(s)
end
Chatcommands["camzf"] = function(s)
	CamZF(s)
end
Chatcommands["cama"] = function(s)
	CamA(s)
end
Chatcommands["camd"] = function(s)
	CamD(s)
end
Chatcommands["camfov"] = function(s)
	CamFov(s)
end
Chatcommands["camzoff"] = function(s)
	CamZoff(s)
end
Chatcommands["camroll"] = function(s)
	CamRoll(s)
end
Chatcommands["camrot"] = function(s)
	CamRot(s)
end
Chatcommands["scd"] = function(s)
	testcd(s)
end

Chatcommands["ui2"] = function(s)
	CommandBar()
end

Chatcommands["h"] = function(s)
	HoldKey(s)
end
Chatcommands["uh"] = function(s)
	UnHoldKey(s)
end
Chatcommands["clear"] = function(s)
	ClearScreen()
end

Chatcommands["std"] = function(s)
	pcall(Chatcommands["key"])
	pcall(Chatcommands["mouse"])
	pcall(Chatcommands["scd"])
end


chatcommands = event:new(EVENT_ID_CHAT_COMMAND,function(e)
	local s,r = pcall(function()
	local s = e:getData(EVENT_DATA_ID_INPUTED_STRING)
	local id = getarg(s)
	local func = Chatcommands[id]
	--gprint(s)
	local s = cuttoargs(s)
	--gprint(s)
	if(not func) then return end
	e:cancel()
	TextPrint("running: ",id)
	func(s)
	TextPrint("success")
	end)
	if(not s) then TextPrint(r) end
end)
end