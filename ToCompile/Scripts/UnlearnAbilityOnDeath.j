library UnlearnOnDeath
{
    hashtable UnlearnOnDeath = null;

    public function DeathUnlearnCheck(unit u)->integer
    {
        if(HaveSavedInteger(UnlearnOnDeath,0,GetUnitTypeId(u))) 
        {
            return LoadInteger(UnlearnOnDeath,0,GetUnitTypeId(u));
        }
        return 0;


    }
    function onInit()
    {
        UnlearnOnDeath = InitHashtable();
        SaveInteger(UnlearnOnDeath,0,'Nalm','ANcr');//alchemist
        SaveInteger(UnlearnOnDeath,0,'Nal2','ANcr');//alchemist
        SaveInteger(UnlearnOnDeath,0,'Nal3','ANcr');//alchemist
        SaveInteger(UnlearnOnDeath,0,'O009','A0CS');//lightning
        SaveInteger(UnlearnOnDeath,0,'U02N','A0JE');//Earth Lich
        SaveInteger(UnlearnOnDeath,0,'N03L','A0BH');//EFrost golem
    }

}