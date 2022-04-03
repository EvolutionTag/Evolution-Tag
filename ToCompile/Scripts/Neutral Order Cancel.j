

globals
    player TempPlayerNeutral = null
    integer NeutralReactionRange = 800
    real NeutralOrderTimerout = 10
endglobals

function CheckUnitForAllyFilter takes nothing returns boolean
    if(IsPlayerEnemy(GetOwningPlayer(GetFilterUnit()),TempPlayerNeutral)) then
        return true
    endif
    return false
endfunction

function NeutralOrderEnum takes nothing returns nothing
    local real x = GetUnitX(GetEnumUnit())
    local real y = GetUnitY(GetEnumUnit())
    local group g = CreateGroup()
    local unit u = null
    call GroupEnumUnitsInRange(g,x,y,NeutralReactionRange, function CheckUnitForAllyFilter)
    set u = GetRandomUnitFromGroup(g)
    if(u==null) then
        call IssueImmediateOrder(GetEnumUnit(),"stop")
    else
        call IssueTargetOrder(GetEnumUnit(),"attack",u)
    endif
    call DestroyGroup(g)
    set u = null
    set g = null
endfunction

function OrderForNeutral takes player p returns nothing
    local group g = CreateGroup()
    call GroupEnumUnitsOfPlayer(g,p,null)
    call ForGroup(g, function NeutralOrderEnum)
    call DestroyGroup(g)
    set g = null
endfunction

function OrderForAllNeutrals takes nothing returns nothing
    call OrderForNeutral(Player(12))
    call OrderForNeutral(Player(13))
    call OrderForNeutral(Player(14))
endfunction

function InitOrderForNeutrals takes nothing returns nothing
    call TimerStart(CreateTimer(),NeutralOrderTimerout,true, function OrderForAllNeutrals)
endfunction

