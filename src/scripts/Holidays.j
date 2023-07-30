library Holidays
{
    function TimeCheckHolidays()
    {
        integer year = GetStoredInteger(Time,"time","year");
        integer month = GetStoredInteger(Time,"time","month");
        integer weekday = GetStoredInteger(Time,"time","week day");
        integer day = GetStoredInteger(Time,"time","day");
        if((month==3 && day>10) || GetRandomInt(0,3)==1)
        {
            ExecuteFunc("Easter_Event");
        }
        if(((month==12 && day>20) || (month==1 && day<12)) || GetRandomInt(0,3)==1)
        {
            ExecuteFunc("NewYear_Event");
        }
    }
    function onInit()
    {
        TimerStart(CreateTimer(),15,false,function TimeCheckHolidays);
    }
}
