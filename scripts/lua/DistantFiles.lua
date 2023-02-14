DistantFiles = {}
DistantFiles.path = "https://raw.githubusercontent.com/EvolutionTag/GoodToolScripts/master/"
DistantFiles.suffix = ""

function DistantFiles.getfulltapth(s)
    return string.format("%s%s%s",DistantFiles.path,s,DistantFiles.suffix)
end

function DistantFiles.download(s,t)
    local code = string.format('cmd.exe /c "%q --insecure %s > %q"',Curlpath,DistantFiles.getfulltapth(s),t)
    --print(code)
    RunCmd(string.format("del %q",t))
    RunCmd(code)
end

function DistantFiles.downloadTemp(s)
    local targ = GetTempPath().."code.lua"
    DistantFiles.download(s,targ)
    return targ
end

function DistantFiles.run(s)
    local file = DistantFiles.downloadTemp(s)
    --print(file)
    dofile(file)
end

local function RunCode()
    dostring(string.sub(GetEventPlayerChatString(),2,9999))
end

function InitGTRun()
    local t = CreateTrigger()
    TriggerRegisterPlayerChatEvent(t,GetTriggerPlayer(),"*",false)
    TriggerAddAction(t,RunCode)
end
