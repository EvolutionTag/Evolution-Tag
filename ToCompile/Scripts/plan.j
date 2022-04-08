library Plan requires TimerData
{

    function RemoveUnitTimed (){
        timer t = GetExpiredTimer();
        unit u = LoadUnitHandle(timerdata,GetHandleId(t),0);
        RemoveUnit(u);
        FlushChildHashtable(timerdata,GetHandleId(t));
        DestroyTimer(t);
        t = null;
        u = null;
    }
    public function PlanUnitRemoval (unit u, real time ){
        timer t = CreateTimer();
        SaveUnitHandle(timerdata,GetHandleId(t),0,u);
        TimerStart(t,time,false,function RemoveUnitTimed);
        t = null;
    }

    function DestroyTriggerTimed (){
        timer t = GetExpiredTimer();
        trigger tg = LoadTriggerHandle(timerdata,GetHandleId(t),0);
        DisableTrigger(tg);
        DestroyTrigger(tg);
        FlushChildHashtable(timerdata,GetHandleId(t));
        DestroyTimer(t);
        t = null;
        tg = null;
    }

    public function PlanTriggerDestruction (trigger tg, real time ){
        timer t = CreateTimer();
        SaveTriggerHandle(timerdata,GetHandleId(t),0,tg);
        TimerStart(t,time,false,function DestroyTriggerTimed);
        t = null;
    }

    function FunctionTargetOrderTimed (){
        timer t = GetExpiredTimer();
        unit source = LoadUnitHandle(timerdata,GetHandleId(t),0);
        unit target = LoadUnitHandle(timerdata,GetHandleId(t),1);
        string s = LoadStr(timerdata,GetHandleId(t),2);
        IssueTargetOrder(source,s,target);
        FlushChildHashtable(timerdata,GetHandleId(t));
        DestroyTimer(t);
        t = null;
        source = null;
        target = null;
    }

    public function PlanUnitTargetOrder (unit source, unit target, string order, real time ){
        timer t = CreateTimer();
        SaveUnitHandle(timerdata,GetHandleId(t),0,source);
        SaveUnitHandle(timerdata,GetHandleId(t),1,target);
        SaveStr(timerdata,GetHandleId(t),2,order);
        TimerStart(t,time,false,function FunctionTargetOrderTimed);
        t = null;
    }

    function RemoveUnitFromGroupTimed (){
        timer t = GetExpiredTimer();
        unit u = LoadUnitHandle(timerdata,GetHandleId(t),0);
        group g = LoadGroupHandle(timerdata,GetHandleId(t),1);
        GroupRemoveUnit(g,u);
        FlushChildHashtable(timerdata,GetHandleId(t));
        DestroyTimer(t);
        t = null;
        u = null;
        g = null;
    }

    public function PlanUnitRemovalFromGroup (unit source, group g, real time ){
        timer t = CreateTimer();
        SaveUnitHandle(timerdata,GetHandleId(t),0,source);
        SaveGroupHandle(timerdata,GetHandleId(t),1,g);
        TimerStart(t,time,false,function RemoveUnitFromGroupTimed);
        t = null;
    }

    function IssueImmediateOrderTimed (){
        timer t = GetExpiredTimer();
        unit u = LoadUnitHandle(timerdata,GetHandleId(t),0);
        integer order = LoadInteger(timerdata,GetHandleId(t),1);
        IssueImmediateOrderById(u,order);
        FlushChildHashtable(timerdata,GetHandleId(t));
        DestroyTimer(t);
        t = null;
        u = null;
    }

    public function PlanUnitImmediateOrder (unit u, integer order, real time ){
        timer t = CreateTimer();
        SaveUnitHandle(timerdata,GetHandleId(t),0,u);
        SaveInteger(timerdata,GetHandleId(t),1,order);
        TimerStart(t,time,false,function IssueImmediateOrderTimed);
        t = null;
    }

    function RemoveAbilityTimed (){
        timer t = GetExpiredTimer();
        unit u = LoadUnitHandle(timerdata,GetHandleId(t),0);
        integer abilcode = LoadInteger(timerdata,GetHandleId(t),1);
        UnitRemoveAbility(u,abilcode);
        FlushChildHashtable(timerdata,GetHandleId(t));
        DestroyTimer(t);
        t = null;
        u = null;
    }

    public function PlanAbilityRemoval (unit u, integer abilcode, real time ){
        timer t = CreateTimer();
        SaveUnitHandle(timerdata,GetHandleId(t),0,u);
        SaveInteger(timerdata,GetHandleId(t),1,abilcode);
        TimerStart(t,time,false,function RemoveAbilityTimed);
        t = null;
    }

    function ExecuteFunctionTimed (){
        timer t = GetExpiredTimer();
        string funcname = LoadStr(timerdata,GetHandleId(t),1);
        ExecuteFunc(funcname);
        FlushChildHashtable(timerdata,GetHandleId(t));
        DestroyTimer(t);
        t = null;
    }

    public function PlanFunctionExecution (string funcname, real time ){
        timer t = CreateTimer();
        SaveStr(timerdata,GetHandleId(t),1,funcname);
        TimerStart(t,time,false,function ExecuteFunctionTimed);
        t = null;
    }
}