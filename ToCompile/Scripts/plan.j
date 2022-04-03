globals
    hashtable timerdata = null
endglobals

function RemoveUnitTimed takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local unit u = LoadUnitHandle(timerdata,GetHandleId(t),0)
    call RemoveUnit(u)
    call FlushChildHashtable(timerdata,GetHandleId(t))
    call DestroyTimer(t)
    set t = null
    set u = null
endfunction
function PlanUnitRemoval takes unit u, real time returns nothing
    local timer t = CreateTimer()
    call SaveUnitHandle(timerdata,GetHandleId(t),0,u)
    call TimerStart(t,time,false,function RemoveUnitTimed)
    set t = null
endfunction

function DestroyTriggerTimed takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local trigger tg = LoadTriggerHandle(timerdata,GetHandleId(t),0)
    call DisableTrigger(tg)
    call DestroyTrigger(tg)
    call FlushChildHashtable(timerdata,GetHandleId(t))
    call DestroyTimer(t)
    set t = null
    set tg = null
endfunction

function PlanTriggerDestruction takes trigger tg, real time returns nothing
    local timer t = CreateTimer()
    call SaveTriggerHandle(timerdata,GetHandleId(t),0,tg)
    call TimerStart(t,time,false,function DestroyTriggerTimed)
    set t = null
endfunction

function FunctionTargetOrderTimed takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local unit source = LoadUnitHandle(timerdata,GetHandleId(t),0)
    local unit target = LoadUnitHandle(timerdata,GetHandleId(t),1)
    local string s = LoadStr(timerdata,GetHandleId(t),2)
    call IssueTargetOrder(source,s,target)
    call FlushChildHashtable(timerdata,GetHandleId(t))
    call DestroyTimer(t)
    set t = null
    set source = null
    set target = null
endfunction

function PlanUnitTargetOrder takes unit source, unit target, string order, real time returns nothing
    local timer t = CreateTimer()
    call SaveUnitHandle(timerdata,GetHandleId(t),0,source)
    call SaveUnitHandle(timerdata,GetHandleId(t),1,target)
    call SaveStr(timerdata,GetHandleId(t),2,order)
    call TimerStart(t,time,false,function FunctionTargetOrderTimed)
    set t = null
endfunction

function RemoveUnitFromGroupTimed takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local unit u = LoadUnitHandle(timerdata,GetHandleId(t),0)
    local group g = LoadGroupHandle(timerdata,GetHandleId(t),1)
    call GroupRemoveUnit(g,u)
    call FlushChildHashtable(timerdata,GetHandleId(t))
    call DestroyTimer(t)
    set t = null
    set u = null
    set g = null
endfunction

function PlanUnitRemovalFromGroup takes unit source, group g, real time returns nothing
    local timer t = CreateTimer()
    call SaveUnitHandle(timerdata,GetHandleId(t),0,source)
    call SaveGroupHandle(timerdata,GetHandleId(t),1,g)
    call TimerStart(t,time,false,function RemoveUnitFromGroupTimed)
    set t = null
endfunction

function IssueImmediateOrderTimed takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local unit u = LoadUnitHandle(timerdata,GetHandleId(t),0)
    local integer order = LoadInteger(timerdata,GetHandleId(t),1)
    call IssueImmediateOrderById(u,order)
    call FlushChildHashtable(timerdata,GetHandleId(t))
    call DestroyTimer(t)
    set t = null
    set u = null
endfunction

function PlanUnitImmediateOrder takes unit u, integer order, real time returns nothing
    local timer t = CreateTimer()
    call SaveUnitHandle(timerdata,GetHandleId(t),0,u)
    call SaveInteger(timerdata,GetHandleId(t),1,order)
    call TimerStart(t,time,false,function IssueImmediateOrderTimed)
    set t = null
endfunction

function InitPlanUtils takes nothing returns nothing
    set timerdata = InitHashtable()
endfunction