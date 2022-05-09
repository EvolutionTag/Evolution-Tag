library BombBlast
{
    trigger blast_on_death = null;
    integer bombtype = 'h06B';
    function Condition()->boolean
    {
        return GetUnitTypeId(GetTriggerUnit())==bombtype;
    }
    function Action()
    {
        unit u=CreateUnit(GetOwningPlayer(GetDyingUnit()),'h06C',GetUnitX(GetDyingUnit()),GetUnitY(GetDyingUnit()),bj_UNIT_FACING);
        IssueImmediateOrderBJ(u,"thunderclap");
        UnitApplyTimedLifeBJ(5.00,'BTLF',u);
        u = null;
    }
    function onInit()
    {
        blast_on_death = CreateTrigger();
        TriggerRegisterAnyUnitEventBJ(blast_on_death,EVENT_PLAYER_UNIT_DEATH);
        TriggerAddAction(blast_on_death, function Action);
        TriggerAddCondition(blast_on_death,function Condition);
    }

}