Settings = {}

local reacts = {}

Settings.reacts = reacts
Settings.modes = {}
Settings.registry = {}


local settings_path = "GoodTool/settings/settings.lua"
Settings.path = settings_path

local function rawset(key,mode)
    --print("rawset",key,mode)
    if(mode==Settings.get(key)) then
        --print("key: ",key," == ",mode)
        return
    end
    local r,react = pcall(function() return Settings.reacts[key] end)
    --print("rawset after getting react")
    if(react) then
        --print("react finded",react)
        local r,s = pcall(react,mode);
        if(not r) then
            --print("error",s)
            Log(string.format("editing setting: %s, error: \n==========\n%s\n=================\n",s))
        else
            --print("unk result")
        end
    end
    Settings.modes[key] = mode
end

local function Set(key,mode)
    --print(string.format("calling set for %s",key))
    rawset(key,mode)
    --print("saving settings")
    Settings.save()
end

local function load() 
    local loaded = persistence.load(settings_path)
    if(not loaded) then
        return;
    end
    --print("loading data")
    for key,mode in pairs(loaded) do

        --print(string.format("loadding value: "))
        rawset(key,mode)
    end

end

local function Save()
    --print("saving settings")
    os.execute(string.format("mkdir %q","GoodTool"))
    os.execute(string.format("mkdir %q","GoodTool\\settings\\"))
    persistence.store(settings_path,Settings.modes)
end

local function AddReact(key,callback)
    --print("added react: ",key," ",callback)
    Settings.reacts[key]=callback
end

local function get(key)
    return Settings.modes[key]
end

Settings.save = Save
Settings.load = load
Settings.set = Set
Settings.get = get
Settings.addReact = AddReact