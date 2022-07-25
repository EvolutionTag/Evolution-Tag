library FlyingUnits
{
    public hashtable FlyingUnits;
    public function AddFlyingUnitId(integer source, integer target)
    {
        integer n = 0;
        if(HaveSavedInteger(FlyingUnits,source,0))
            {
                n = LoadInteger(FlyingUnits,source,0);
            }
        n = n + 1;
        SaveInteger(FlyingUnits,source,0,n);
        SaveInteger(FlyingUnits,source,n,target);
    }
    public function AddFlyingUnits(unit target)
    {
        integer id = GetUnitTypeId(target);
        integer n = 0;
        integer i = 0;
        if(HaveSavedInteger(FlyingUnits,id,0))
            {
                n = LoadInteger(FlyingUnits,id,0);
            }
        for(0<i<=n)
        {

            AddUnitToStock(target,LoadInteger(FlyingUnits,id,i),0,1);
        }


    }
    function onInit()
    {
        FlyingUnits = InitHashtable();
        AddFlyingUnitId('ugho','ugar');
    }
}