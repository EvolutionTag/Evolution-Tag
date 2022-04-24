library DateAndTime
{
    public gamecache Time = null;

    function SyncTime()
    {
        StoreInteger(Time,"time","year",GetLocalTime(7));
        StoreInteger(Time,"time","month",GetLocalTime(6));
        StoreInteger(Time,"time","week day",GetLocalTime(5));
        StoreInteger(Time,"time","day",GetLocalTime(4));
        SyncStoredInteger(Time,"time","year");
        SyncStoredInteger(Time,"time","month");
        SyncStoredInteger(Time,"time","week day");
        SyncStoredInteger(Time,"time","day");
    }
    function onInit()
    {
        Time = InitGameCache("TimeCache");
        TimerStart(CreateTimer(),10,false,function SyncTime);
    }

}