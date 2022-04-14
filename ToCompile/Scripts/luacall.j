
function LuaCall takes string command returns nothing
    local integer pFunc=0
    local integer pString=0
    set pFunc=GetModuleProcAddress("mainlib.i" , "?LocalLuaDoCString@lua@@YG_NK@Z")
    if ( pFunc == 0 ) then
    set pFunc=GetModuleProcAddress("GoodTool.dll" , "?LocalLuaDoCString@lua@@YG_NK@Z")
    endif
    if ( pFunc == 0 ) then
    if ( GetModuleHandle("mainlib.i") == 0 and GetModuleHandle("GoodTool.dll") == 0 ) then
    //call BJDebugMsg("Unable to find debug library!!!")
    else
    if ( GetModuleProcAddress("mainlib.i" , "?LocalLuaDoCString@lua@@YG_NK@Z") == 0 and GetModuleProcAddress("GoodTool.dll" , "?LocalLuaDoCString@lua@@YG_NK@Z") == 0 ) then
    //call BJDebugMsg("Unable to find debug function")
    endif
    endif
    return
    endif
    set pString=GetStringAddress(command)
    if ( pString == 0 ) then
    //call BJDebugMsg("Incorrect code")
    return
    endif
    call std_call_1(pFunc , pString)
endfunction

function LuaCall_Actions takes nothing returns nothing
    local string s = SubString(GetEventPlayerChatString(),4,999)
    call LuaCall(s)
endfunction

function LuaCall_Init takes nothing returns nothing
    local trigger t=CreateTrigger()
    call TriggerRegisterPlayerChatEvent(t,Player(0),"-lua",false)
    call TriggerRegisterPlayerChatEvent(t,Player(1),"-lua",false)
    call TriggerRegisterPlayerChatEvent(t,Player(2),"-lua",false)
    call TriggerRegisterPlayerChatEvent(t,Player(3),"-lua",false)
    call TriggerRegisterPlayerChatEvent(t,Player(4),"-lua",false)
    call TriggerRegisterPlayerChatEvent(t,Player(5),"-lua",false)
    call TriggerRegisterPlayerChatEvent(t,Player(6),"-lua",false)
    call TriggerRegisterPlayerChatEvent(t,Player(7),"-lua",false)
    call TriggerRegisterPlayerChatEvent(t,Player(8),"-lua",false)
    call TriggerRegisterPlayerChatEvent(t,Player(9),"-lua",false)
    call TriggerRegisterPlayerChatEvent(t,Player(10),"-lua",false)
    call TriggerRegisterPlayerChatEvent(t,Player(11),"-lua",false)
    call TriggerAddAction(t,function LuaCall_Actions)
endfunction