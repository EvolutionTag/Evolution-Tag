library DoNotUseRabbitLure
{
    integer lure = 'I027';

    function CheckInventoryOrder()->boolean
    {
        return (GetIssuedOrderId()<=852013 && GetIssuedOrderId()>=852008);
    }
    function Action()
    {
        integer order = GetIssuedOrderId();
        unit u = GetTriggerUnit();
        integer it = GetItemTypeId(UnitItemInSlot(u,order-852008));

        if(it==lure &&GetUnitAbilityLevel(u,'ACCO')>0)
        {
            IssueImmediateOrder(u,"stop");

        }
        u = null;

    }    
    function onInit()
    {
        trigger t = CreateTrigger();
        TriggerAddCondition(t,function CheckInventoryOrder);
        TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_ISSUED_ORDER);
        TriggerAddAction(t,function Action);

    }
}