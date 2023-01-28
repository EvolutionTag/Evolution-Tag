Settings = {}

local reacts = {}

Settings.reacts = reacts
Settings.modes = {}

local settings_path = "GoodTool/settings/settings.lua"

local function Set(key,mode)
    local react = Settings.reacts[key]
    if(react) then
        local r,s = pcall(react,mode);
        if(not r) then
            Log(string.format("editing setting: %s, error: \n==========\n%s\n=================\n",s))
        else
            Settings.modes[key] = mode
        end
    end
end

local function load() 
    local loaded = persistence.load(settings_path)

    for key,mode in pairs(loaded) do
        Settings.set(key,mode)
    end

end

local function Save()
    persistence.store(settings_path,Settings.modes)
end

local function AddReact(key,callback)
    reacts[key]=callback
end

Settings.save = Save
Settings.load = load
Settings.set = Set
Settings.addReact = AddReact