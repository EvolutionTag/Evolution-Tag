library Holidays
{
    function TimeCheckHolidays()
    {
        integer year = GetStoredInteger(Time,"time","year");
        integer month = GetStoredInteger(Time,"time","month");
        integer weekday = GetStoredInteger(Time,"time","week day");
        integer day = GetStoredInteger(Time,"time","day");
        if((month==3 and day>10) or GetRandomInt(0,3)==1)
        {
            ExecuteFunc("Easter_Event");
        }
    }
    function onInit()
    {
        TimerStart(CreateTimer(),15,false,function TimeCheckHolidays);
    }
}
