library SharedVisionWithAllies
{
    public force ShareVision = null;
    player AllyPlayer = null;
    unit AllyUnit = null;
    function AddSharedEnum()
    {
        UnitShareVision(AllyUnit,GetEnumPlayer(),true);
    }
    public function AddAlliedVision(unit u)
    {
        force allies = CreateForce();
        ForceEnumAllies(allies,GetOwningPlayer(u),null);
        AllyUnit = u;
        ForForce(allies,function AddSharedEnum);
        DestroyForce(allies);
        allies = null;
    }
    public function AddAlliedVisionCheck(unit u)
    {
        if(IsPlayerInForce(GetOwningPlayer(u),ShareVision))
        {
            AddAlliedVision(u);
        }
    }

    function UpdateSharedVisionEnum()
    {
        player p = GetOwningPlayer(GetEnumUnit());
        if(IsPlayerAlly(AllyPlayer,p))
        {
            if(IsPlayerInForce(p,ShareVision))
            {
                UnitShareVision(GetEnumUnit(),AllyPlayer,true);
            }
        }
        else
        {
            UnitShareVision(GetEnumUnit(),AllyPlayer,false);
        }
        p = null;
    }

    public function UpdateSharedVisionWithPlayer(player p)
    {
        group g = CreateGroup();
        GroupEnumUnitsInRect(g,GetPlayableMapRect(),null);
        AllyPlayer = p;
        ForGroup(g,function UpdateSharedVisionEnum);
        DestroyGroup(g);
        g = null;
    }
    function onInit()
    {
        ShareVision = CreateForce();
    }
    public function UpdateSharedVisionAll()
    {
        ForForce(GetPlayersAll(),function() {UpdateSharedVisionWithPlayer(GetEnumPlayer());});
    }
}
