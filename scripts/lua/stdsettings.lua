STDSettings = {}

local infomode = function(mode)
    HookSpeedText(true)
end

local function CommandBar()
	ShowAllyPanel(true)
end

local EnableWidescreenOnce_flag = false
function EnableWidescreenOnce()
    if(EnableWidescreenOnce_flag) then return end
    EnableWidescreenOnce_flag = true
    EnableWidescreen(true)
end

local function Widescreen(factor)
    if(not factor) then
        return
    end
    EnableWidescreenOnce()
    if(type(factor)=="number") then
        SetCustomFovFix(factor)
        return
    end
end

STDSettings.infomode = infomode
STDSettings.commandbar = CommandBar
STDSettings.Widescreen = Widescreen

Settings.addReact("ShowInfo",function(mode) STDSettings.infomode(mode) end)
Settings.addReact("AllyCommands",function(mode) STDSettings.commandbar() end)
Settings.addReact("ScreenWidth",function(mode) STDSettings.Widescreen(mode) end)