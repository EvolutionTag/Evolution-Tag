if(not ChatCommands) then
ChatCommands = {}
end

local commands = {}



commands["key"] = function(s) 
	pcall(function ()
		local setting = Settings.get("HotKey")
		if(setting) then
			setting = false
		else
			setting = true
		end
		Settings.set("HotKey",setting)
	end)
end

commands["keyq"] = function(s) 
	pcall(function ()
		local setting = Settings.get("HotKey_QuickCast")
		if(setting) then
			setting = false
		else
			setting = true
		end
		Settings.set("HotKey_QuickCast",setting)
	end)
end

commands["ui"] = function() 
	ImprovedUI.init()
	UpdateGameUI()
end

commands["mouse"] = function()
	pcall(function ()
		Settings.set("LockMouse",true)
	end)
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
	local factor,s = getarg(s)
	local r,factor = pcall(function() return tonumber(factor) end)
	if(not r or not factor) then factor = 0.7 end
	pcall(function ()
		Settings.set("ScreenWidth",factor)
	end)
end
commands["info"] = function(s)
	pcall(function ()
		Settings.set("ShowInfo",true)
	end)
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
	pcall(function ()
		Settings.set("ShowCD",not Settings.get("ShowCD"))
	end)
end

commands["ui2"] = function()
	print("running ui2")
	pcall(function()
		Settings.set("AllyCommands",true)
	end)
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
	pcall(function ()
		Settings.set("HotKey",true)
	end)
	pcall(function ()
		Settings.set("LockMouse",true)
	end)
	pcall(function ()
		Settings.set("ShowCD",true)
	end)
	pcall(function ()
		Settings.set("ShowInfo",true)
	end)
	pcall(function ()
		Settings.set("ScreenWidth",true)
	end)
	pcall(function()
		Settings.set("AllyCommands",true)
	end)
	pcall(function()
		Settings.set("HotKey_QuickCast",true)
	end)
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


