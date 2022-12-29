Order = {}

Order.GetPresenceTagged = function(a,b)
 return fastcall2(AC.game+0x03fa30,a,b)
end


Order.GetAgentInternal=function(a)
 return thiscall1(AC.game+0x4786b0,a)
end

Order.GetUnitOrder=function(u)
    if(u==0) then return; end
    local pu = ConvertHandle(u)
    if(pu==0) then return; end
    local order = Order.GetAgentInternal(pu+0x19c)
    return order
end


local PBaseTypes = {}
PBaseTypes[0x92FF24] = {
["type"] = "COrder",
["print"] = function(porder)
    local orderid = ReadRealMemory(porder+0x24)
    --local taget = GetOrderTarget(u)

    local s = string.format("COrder: %X, target: ?",orderid);
    print(s)
    gprint(s)
end,
["serialize"] = function()
    local orderid = ReadRealMemory(porder+0x24)
    return {["id"] = orderid,["type"] = "COrder"}
end
}

PBaseTypes[0x9300F4] = {
["type"] = "COrderTarget",
["print"] = function(porder)
    local orderid = ReadRealMemory(porder+0x24)
    --local taget = GetOrderTarget(porder)
    local x = ReadFloat(porder+0x48)
    local y = ReadFloat(porder+0x50)
    local s = string.format("COrderTarget: %X, target: ?  (%f,%f)",orderid,x,y);
    print(s)
    gprint(s)
end,
["serialize"] = function(porder)
    local orderid = ReadRealMemory(porder+0x24)
    local x = ReadFloat(porder+0x48)
    local y = ReadFloat(porder+0x50)
    return {["x"] = x,["y"] = y,["id"] = orderid,["type"] = "COrderTarget"}
end
}

PBaseTypes[0x93006C] = {
["type"] = "CPointOrder2",
["print"] = function(porder)
    local orderid = ReadRealMemory(porder+0x24)
    --local taget = GetOrderTarget(porder)
    local x = ReadFloat(porder+0x48)
    local y = ReadFloat(porder+0x50)
    local s = string.format("CPointOrder2: %X,  (%f,%f)",orderid,x,y);
    print(s)
    gprint(s)
end,
["serialize"] = function(porder)
    local orderid = ReadRealMemory(porder+0x24)
    local x1 = ReadFloat(porder+0x48)
    local y1 = ReadFloat(porder+0x50)
    local x2 = ReadFloat(porder+0x5C)
    local y2 = ReadFloat(porder+0x64)
    return {["x1"] = x1,["y1"] = y1,["x2"] = x2,["y2"] = y2,["id"] = orderid,["type"] = "CPointOrder2"}
end
}

Order.BaseTypes = PBaseTypes

Order.SerializeUnitOrder = function(u)
    local order = Order.GetUnitOrder(u)
    if(order==0) then return end
    local pVFTable = ReadRealMemory(order)
    local type = Order.BaseTypes[pVFTable-AC.game]

    if(not type) then
        return {["VFTable"] = string.format("0x6F%X",pVFTable-AC.game)}
    end
    return type.serialize(order)
end