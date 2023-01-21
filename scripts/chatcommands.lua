if(not ChatCommands) then
ChatCommands = {}
end

local commands = {}


local function RunKey(e)
	return SmartCast.OnKey(e)
end


local function ReRunKey()
	return SmartCast.ProcessKeys()
end
commands["key"] = function() 
	if(not ChatCommands.keyevent) then
		--gprint('registring keys')
		ChatCommands.keyevent = event:new(EVENT_ID_KEY_INPUT, ChatCommands.RunKey)
		ChatCommands.periodickey = event:new(EVENT_ID_SCREEN_UPDATE,ChatCommands.ReRunKey)
	else
		--gprint('unregistring keys')
		event.disconnect(ChatCommands.keyevent)
		event.disconnect(ChatCommands.periodickey)
		ChatCommands.keyevent = nil
		ChatCommands.periodickey = nil
	end
end

commands["ui"] = function() 
	initui()
end

commands["mouse"] = function()
	mouseswap()
end

commands["mh0"] = function()
	mh0()
end
commands["mh1"] = function()
	mh1()
end
commands["mh2"] = function()
	mh2()
end
commands["umh0"] = function()
	umh0()
end
commands["umh1"] = function()
	umh1()
end
commands["umh2"] = function()
	umh2()
end
commands["screen"] = function(s)
	Widescreen(s)
end
commands["info"] = function(s)
	Info(s)
end

commands["camz"] = function(s)
	CamZ(s)
end
commands["camzf"] = function(s)
	CamZF(s)
end
commands["cama"] = function(s)
	CamA(s)
end
commands["camd"] = function(s)
	CamD(s)
end
commands["camfov"] = function(s)
	CamFov(s)
end
commands["camzoff"] = function(s)
	CamZoff(s)
end
commands["camroll"] = function(s)
	CamRoll(s)
end
commands["camrot"] = function(s)
	CamRot(s)
end
commands["scd"] = function(s)
	testcd(s)
end

commands["ui2"] = function(s)
	CommandBar()
end

commands["h"] = function(s)
	HoldKey(s)
end
commands["uh"] = function(s)
	UnHoldKey(s)
end
commands["clear"] = function(s)
	ClearScreen()
end

commands["std"] = function(s)
	pcall(commands["key"])
	pcall(commands["mouse"])
	pcall(commands["scd"])
	pcall(commands["info"])
	pcall(commands["screen"])
end

ChatCommands.RunKey = RunKey
ChatCommands.ReRunKey = ReRunKey

ChatCommands.commands = commands
if(ChatCommands.event) then
	event.disconnect(ChatCommands.event);
	ChatCommands.event = nil
end

ChatCommands.event = event:new(EVENT_ID_CHAT_COMMAND,function(e)
	local s,r = pcall(function()
	local s = e:getData(EVENT_DATA_ID_INPUTED_STRING)
	local id = getarg(s)
	local func = ChatCommands.commands[id]
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


