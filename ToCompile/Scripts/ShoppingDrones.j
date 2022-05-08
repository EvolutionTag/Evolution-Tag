library ShoppingDrones
{

    function UnitHideMovement(unit u)
    {
        integer pData;
        if(GetHandleId(u)==0)
        {
            return;
        }
        pData = GetUnitAbility(u,'Amov');
        if(pData==0)
        {
            return;
        }
        WriteRealMemory(pData+0x40,1);
        WriteRealMemory(pData+0x3C,1);
    }
    function Condition()->boolean
    {
        return GetSpellAbilityId()=='ANg4';
    }
    function Action()
    {
        unit caster = GetTriggerUnit();
        player p = GetOwningPlayer(caster);
        real x = GetUnitX(caster);
        real y = GetUnitY(caster);
        unit u = CreateUnit(p,'o00v',x,y,0);
        UnitApplyTimedLife(u,'BTLF',60);
        UnitHideMovement(u);
        AddItemToStock(u,'I01P',5,5);
        AddItemToStock(u,'I01U',5,5);
        AddItemToStock(u,'I01V',5,5);
        AddItemToStock(u,'I01O',5,5);
        AddItemToStock(u,'I01S',5,5);
        AddItemToStock(u,'I01T',5,5);
        u = CreateUnit(p,'o00v',x,y,0);
        UnitApplyTimedLife(u,'BTLF',60);
        UnitHideMovement(u);
        AddItemToStock(u,'rnec',5,5);
        AddItemToStock(u,'skul',5,5);
        AddItemToStock(u,'pghe',5,5);
        AddItemToStock(u,'AS30',5,5);
        AddItemToStock(u,'rde3',5,5);
        AddItemToStock(u,'gcel',5,5);
        AddItemToStock(u,'crys',5,5);
        AddItemToStock(u,'shas',5,5);
        AddItemToStock(u,'whwd',5,5);
        AddItemToStock(u,'penr',5,5);
        AddItemToStock(u,'dI07',5,5);
        u = CreateUnit(p,'o00v',x,y,0);
        UnitApplyTimedLife(u,'BTLF',60);
        UnitHideMovement(u);
        AddItemToStock(u,'dI06',5,5);
        AddItemToStock(u,'dI07',5,5);
        u = CreateUnit(p,'o00v',x,y,0);
        UnitApplyTimedLife(u,'BTLF',60);
        UnitHideMovement(u);
        AddItemToStock(u,'I008',5,5);
        AddItemToStock(u,'I009',5,5);
        AddItemToStock(u,'I00E',5,5);
        AddItemToStock(u,'I016',5,5);
        AddItemToStock(u,'belv',5,5);
        AddItemToStock(u,'I03D',5,5);
        AddItemToStock(u,'I03C',5,5);
        AddItemToStock(u,'I03S',5,5);
        u = CreateUnit(p,'o00v',x,y,0);
        UnitApplyTimedLife(u,'BTLF',60);
        UnitHideMovement(u);
        AddItemToStock(u,'I023',5,5);
        AddItemToStock(u,'I01A',5,5);
        AddItemToStock(u,'I03O',5,5);
        AddItemToStock(u,'moon',5,5);
        AddItemToStock(u,'I01Y',5,5);
        u = CreateUnit(p,'o00v',x,y,0);
        UnitApplyTimedLife(u,'BTLF',60);
        UnitHideMovement(u);
        AddItemToStock(u,'I03I',5,5);
        AddItemToStock(u,'I03J',5,5);
        AddItemToStock(u,'I03K',5,5);
        AddItemToStock(u,'I03U',5,5);
        AddItemToStock(u,'I03M',5,5);
        AddItemToStock(u,'I03V',5,5);
        AddItemToStock(u,'I02D',5,5);
        AddItemToStock(u,'I03R',5,5);
        AddItemToStock(u,'I03X',5,5);
        AddItemToStock(u,'I027',5,5);
        AddItemToStock(u,'I04B',5,5);
        u = CreateUnit(p,'o00v',x,y,0);
        UnitApplyTimedLife(u,'BTLF',60);
        UnitHideMovement(u);
        AddItemToStock(u,'gemt',5,5);
        AddItemToStock(u,'I001',5,5);
        AddItemToStock(u,'I02Q',5,5);
        AddItemToStock(u,'I02P',5,5);
        AddItemToStock(u,'I038',5,5);
        AddItemToStock(u,'I03D',5,5);
        AddItemToStock(u,'I03C',5,5);
        AddItemToStock(u,'I03F',5,5);
        AddItemToStock(u,'I03H',5,5);
        AddItemToStock(u,'mcou',5,5);
        AddItemToStock(u,'hcun',5,5);
        u = CreateUnit(p,'o00v',x,y,0);
        UnitApplyTimedLife(u,'BTLF',60);
        UnitHideMovement(u);
        AddItemToStock(u,'I02G',5,5);
        AddItemToStock(u,'I02E',5,5);
        AddItemToStock(u,'I02H',5,5);
        AddItemToStock(u,'I034',5,5);
        AddItemToStock(u,'penr',5,5);
        AddItemToStock(u,'pmna',5,5);
        AddItemToStock(u,'stel',5,5);
        AddItemToStock(u,'kpin',5,5);
        AddItemToStock(u,'rin1',5,5);
        AddItemToStock(u,'I028',5,5);
        u = CreateUnit(p,'o00v',x,y,0);
        UnitApplyTimedLife(u,'BTLF',60);
        UnitHideMovement(u);
        AddItemToStock(u,'I02B',5,5);
        AddItemToStock(u,'I025',5,5);
        AddItemToStock(u,'I024',5,5);
        AddItemToStock(u,'I023',5,5);
        AddItemToStock(u,'wswd',5,5);
        AddItemToStock(u,'I027',5,5);
        AddItemToStock(u,'I02D',5,5);
        AddUnitToStock(u,'h07Z',5,5);
        AddUnitToStock(u,'h07Y',5,5);
        u = CreateUnit(p,'o00v',x,y,0);
        UnitApplyTimedLife(u,'BTLF',60);
        UnitHideMovement(u);
        AddItemToStock(u,'ciri',5,5);
        AddItemToStock(u,'belv',5,5);
        AddItemToStock(u,'bgst',5,5);
        AddItemToStock(u,'rlif',5,5);
        AddItemToStock(u,'I012',5,5);
        AddItemToStock(u,'I00Z',5,5);
        AddItemToStock(u,'I014',5,5);
        AddItemToStock(u,'I016',5,5);
        AddItemToStock(u,'I01X',5,5);
        AddItemToStock(u,'I01Z',5,5);
        AddItemToStock(u,'I04A',5,5);
        u = CreateUnit(p,'o00v',x,y,0);
        UnitApplyTimedLife(u,'BTLF',60);
        UnitHideMovement(u);
        AddItemToStock(u,'clfm',5,5);
        AddItemToStock(u,'I008',5,5);
        AddItemToStock(u,'I009',5,5);
        AddItemToStock(u,'I00E',5,5);
        AddItemToStock(u,'I004',5,5);
        AddItemToStock(u,'I00G',5,5);
        AddItemToStock(u,'I00C',5,5);
        AddItemToStock(u,'I00F',5,5);
        AddItemToStock(u,'bspd',5,5);
        AddItemToStock(u,'I00J',5,5);
        AddItemToStock(u,'I00L',5,5);
        u = CreateUnit(p,'o00v',x,y,0);
        UnitApplyTimedLife(u,'BTLF',60);
        UnitHideMovement(u);
        AddItemToStock(u,'I003',5,5);
        AddItemToStock(u,'I002',5,5);
        AddItemToStock(u,'I00B',5,5);
        AddItemToStock(u,'I00D',5,5);
        AddItemToStock(u,'I00I',5,5);
        AddItemToStock(u,'I02T',5,5);
        AddItemToStock(u,'I02U',5,5);
        u = CreateUnit(p,'o00v',x,y,0);
        UnitApplyTimedLife(u,'BTLF',60);
        UnitHideMovement(u);
        AddItemToStock(u,'AS30',5,5);
        AddItemToStock(u,'manh',5,5);
        AddItemToStock(u,'bspd',5,5);
        AddItemToStock(u,'I00J',5,5);
        AddItemToStock(u,'brac',5,5);
        AddItemToStock(u,'rlif',5,5);
        AddItemToStock(u,'I01X',5,5);
        u = CreateUnit(p,'o00v',x,y,0);
        UnitApplyTimedLife(u,'BTLF',60);
        UnitHideMovement(u);
        AddItemToStock(u,'I04E',5,5);
        AddItemToStock(u,'I04D',5,5);
    }
    function onInit()
    {
        trigger t = CreateTrigger();
        TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_FINISH);
        TriggerAddCondition(t,function Condition);
        TriggerAddAction(t,function Action);
    }
}