library Waifu
{
    function Condition()->boolean
    {
        return GetSpellAbilityId()=='AILA';
    }
    function Action()
    {
        unit caster = GetTriggerUnit();
        UnitAddAbility(caster,'ANg5');
        UnitMakeAbilityPermanent(caster,true,'ANg5');
    }
    function onInit()
    {
        trigger t = CreateTrigger();
        TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_SPELL_FINISH);
        TriggerAddCondition(t,function Condition);
        TriggerAddAction(t,function Action);
    }
}