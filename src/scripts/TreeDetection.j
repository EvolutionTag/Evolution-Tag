library TreeDetection
{
    unit TreeDetector;
    public function IsTree(destructable d)->boolean
    {
        PauseUnit(TreeDetector,false);
        if(IssueTargetOrder(TreeDetector,"harvest",d))
        {
            d = null;
        }
        PauseUnit(TreeDetector,true);
        return d==null;
    }
    function onInit()
    {
        TreeDetector = CreateUnit(Player(15),'dDUM',10000,10000,0);
        UnitAddAbility(TreeDetector,'Ahar');
        PauseUnit(TreeDetector,true);
    }
}