
library JumpSystem requires TimerData
{

    function JumpCallback()
    {
        timer t = GetExpiredTimer();
        unit u = LoadUnitHandle(timerdata,GetHandleId(t),0);
        if(GetWidgetLife(u)<0.1 or )
    }
}