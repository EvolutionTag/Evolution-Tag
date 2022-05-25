library UltimateUpgrades
{
    public hashtable UltimateUpgrades = null;
    public unit UltimateUpgradingUnit = null;
    public function GetUltimateUpgradeId(integer id,boolean withfly)->integer
    {
        if(withfly)
        {
            if(HaveSavedInteger(UltimateUpgrades,1,id))
            {
                return LoadInteger(UltimateUpgrades,1,id);
            }
        }
        if(HaveSavedInteger(UltimateUpgrades,0,id))
        {
            return LoadInteger(UltimateUpgrades,0,id);
        }
        return 0;
    }
    public function GetUltimateUpgradeSideEffectFromId(integer id,boolean withfly)->string
    {
        if(withfly)
            {
                if(HaveSavedString(UltimateUpgrades,3,id))
                {
                    return LoadStr(UltimateUpgrades,3,id);
                }
            }
            if(HaveSavedString(UltimateUpgrades,2,id))
            {
                return LoadStr(UltimateUpgrades,2,id);
            }
            return null;
    }
    function onInit()
    {
        UltimateUpgrades = InitHashtable();
        SaveInteger(UltimateUpgrades,0,'O00E','U00M');
        SaveInteger(UltimateUpgrades,0,'O00E','O00F');
        SaveInteger(UltimateUpgrades,0,'Usyl','U01M');
        SaveInteger(UltimateUpgrades,0,'N03B','N03F');
        SaveInteger(UltimateUpgrades,0,'DDW0','DDW1');
        SaveInteger(UltimateUpgrades,0,'Obla','Opgh');
        SaveInteger(UltimateUpgrades,0,'Nfir','N01H');
        SaveInteger(UltimateUpgrades,0,'N033','N01N');
        SaveInteger(UltimateUpgrades,0,'U00W','U00J');
        SaveInteger(UltimateUpgrades,0,'n00P','N01I');
        SaveInteger(UltimateUpgrades,0,'edoc','N01P');
        SaveInteger(UltimateUpgrades,0,'edcm','N01P');
        SaveInteger(UltimateUpgrades,0,'N02J','N03K');
        SaveInteger(UltimateUpgrades,0,'N02I','N03K');
        SaveInteger(UltimateUpgrades,0,'Udea','U00M');
        SaveInteger(UltimateUpgrades,0,'U00U','U01W');
        SaveInteger(UltimateUpgrades,0,'z000','Z009');
        SaveInteger(UltimateUpgrades,0,'O006','O003');
        SaveInteger(UltimateUpgrades,0,'uabo','U00O');
        SaveInteger(UltimateUpgrades,0,'n01D','N04D');
        SaveInteger(UltimateUpgrades,0,'nndr','N04D');
        SaveInteger(UltimateUpgrades,0,'n01B','N01U');
        SaveInteger(UltimateUpgrades,0,'nahy','N01X');
        SaveInteger(UltimateUpgrades,0,'Hvsh','N01X');
        SaveInteger(UltimateUpgrades,0,'h03V','H03W');
        SaveInteger(UltimateUpgrades,0,'Hpal','H028');
        SaveInteger(UltimateUpgrades,0,'H025','H03C');
        SaveInteger(UltimateUpgrades,0,'Emoo','E015');
        SaveInteger(UltimateUpgrades,0,'H03G','H03I');
        SaveInteger(UltimateUpgrades,0,'H04O','H05A');
        SaveInteger(UltimateUpgrades,0,'E013','E014');
        SaveInteger(UltimateUpgrades,0,'H00D','H045');
        SaveInteger(UltimateUpgrades,0,'H03H','H03J');
        SaveInteger(UltimateUpgrades,0,'Hlgr','H029');
        SaveInteger(UltimateUpgrades,0,'E00D','E006');
        SaveInteger(UltimateUpgrades,0,'Hant','Hjai');
        SaveInteger(UltimateUpgrades,0,'H05L','H05N');
        SaveInteger(UltimateUpgrades,0,'Ewar','E007');
        SaveInteger(UltimateUpgrades,0,'H00B','H02A');
        SaveInteger(UltimateUpgrades,0,'E00E','E00B');
        SaveInteger(UltimateUpgrades,0,'Hvwd','H033');
        SaveInteger(UltimateUpgrades,0,'h00R','N07F');
        SaveInteger(UltimateUpgrades,0,'Npbm','N022');
        SaveInteger(UltimateUpgrades,0,'Naka','N021');
        SaveInteger(UltimateUpgrades,0,'Efur','Emns');
        SaveInteger(UltimateUpgrades,0,'Hmkg','H06G');
        SaveInteger(UltimateUpgrades,0,'H06W','H06S');
        SaveInteger(UltimateUpgrades,0,'H07W','H07V');
        SaveInteger(UltimateUpgrades,0,'H079','H07A');
        SaveInteger(UltimateUpgrades,0,'Edem','E017');
        SaveInteger(UltimateUpgrades,0,'H059','H07D');
        SaveInteger(UltimateUpgrades,0,'H06X','H06Y');
        SaveInteger(UltimateUpgrades,0,'H06L','H06K');
        SaveInteger(UltimateUpgrades,0,'N034','N05Q');
        SaveInteger(UltimateUpgrades,0,'U02B','U02G');
        SaveInteger(UltimateUpgrades,0,'U02L','O00N');
        SaveInteger(UltimateUpgrades,0,'U02R','U02Q');
        ////////////////////////////////////////////
        SaveInteger(UltimateUpgrades,1,'Udre','U010');
        SaveInteger(UltimateUpgrades,0,'Udre','U026');
        SaveInteger(UltimateUpgrades,1,'U00X','U00N');
        SaveInteger(UltimateUpgrades,0,'U00X','U028');
        SaveInteger(UltimateUpgrades,1,'u00G','U00P');
        SaveInteger(UltimateUpgrades,0,'u00G','U021');
        SaveInteger(UltimateUpgrades,1,'H031','H027');
        SaveInteger(UltimateUpgrades,1,'H032','H027');
        SaveInteger(UltimateUpgrades,0,'H031','H06J');
        SaveInteger(UltimateUpgrades,0,'H032','H06J');
        SaveInteger(UltimateUpgrades,1,'H01Y','H037');
        SaveInteger(UltimateUpgrades,0,'H01Y','H06O');
        SaveInteger(UltimateUpgrades,1,'Hblm','n02A');
        SaveInteger(UltimateUpgrades,0,'Hblm','H06T');
        //side effects
        SaveStr(UltimateUpgrades,2,'H07V',"GandalfEffect");
        SaveStr(UltimateUpgrades,2,'O003',"TaurenEffect");
        SaveStr(UltimateUpgrades,2,'N01N',"IceGolemEffect");
    }
}