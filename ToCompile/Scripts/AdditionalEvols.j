library AdditionalEvols
{
    public hashtable AdditionalEvolutions = null;
    public function UnitApplyAdditionalEvolutions(unit u)
    {
        integer i = 0;
        integer utype = GetUnitTypeId(u);
        while(HaveSavedInteger(AdditionalEvolutions,utype,i))
        {
            AddUnitToStock(u,LoadInteger(AdditionalEvolutions,utype,i),0,1);
            i = i + 1;
        }
    }



    function onInit()
    {
        AdditionalEvolutions = InitHashtable();
    }
}