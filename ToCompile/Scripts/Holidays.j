library Holidays
{
    function TimeCheckHolidays()
    {
        integer year = GetStoredInteger(Time,"time","year");
        integer month = GetStoredInteger(Time,"time","month");
        integer weekday = GetStoredInteger(Time,"time","week day");
        integer day = GetStoredInteger(Time,"time","day");
        if(year==2022 && month == 4 && day>=24 && day<=30)
        {
            ExecuteFunc("Pasha_Event");
        }
    }
    function onInit()
    {
        TimerStart(CreateTimer(),15,false,function TimeCheckHolidays);
    }
}
