library DeathUnitTypeCheckHT
{
    hashtable DeathUnitTypeCheckHT = null;

    public function DeathUnitTypeCheck(unit u)->integer
    {
        if(HaveSavedInteger(DeathUnitTypeCheckHT,0,GetUnitTypeId(u))) 
        {
            return LoadInteger(DeathUnitTypeCheckHT,0,GetUnitTypeId(u));
        }
        return 0;


    }
    function onInit()
    {
        DeathUnitTypeCheckHT = InitHashtable();
        SaveInteger(DeathUnitTypeCheckHT,0,'Nalm','Nalc');//alchemist
        SaveInteger(DeathUnitTypeCheckHT,0,'Nal2','Nalc');//alchemist
        SaveInteger(DeathUnitTypeCheckHT,0,'Nal3','Nalc');//alchemist
        SaveInteger(DeathUnitTypeCheckHT,0,'O009','O008');//lightning
        SaveInteger(DeathUnitTypeCheckHT,0,'U02N','U02M');//Earth Lich
        SaveInteger(DeathUnitTypeCheckHT,0,'N03L','N03K');//EFrost golem
    }

}