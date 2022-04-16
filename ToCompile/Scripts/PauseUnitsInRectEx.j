library PauseUnitsInRectEx
{
    hashtable pausetable = null;
    boolean PauseFlag = false;
    boolean enabled = false;
    function PauseUnitsAllExEnum()
    {
        PauseUnit(GetEnumUnit(),PauseFlag);
        if(PauseFlag)
        {
            SaveReal(pausetable,0,GetHandleId(GetEnumUnit()),GetWidgetLife(GetEnumUnit()));
        }
        else
        {
            SetWidgetLife(GetEnumUnit(),LoadReal(pausetable,0,GetHandleId(GetEnumUnit())));
        }
    }

    public function PauseUnitsAllEx(boolean pause)
    {
        integer index;
        player indexPlayer;
        group g;
        group g0;
        PauseFlag=pause;
        if(pause==enabled)
        {
            return;
        }
        enabled = pause;
        if(pause) 
        {
            g0 = CreateGroup();
            g=CreateGroup();
            for(0<=index<bj_MAX_PLAYER_SLOTS)
            {
                indexPlayer=Player(index);
                GroupEnumUnitsOfPlayer(g0,indexPlayer,null);
               // BJDebugMsg(I2S(CountUnitsInGroup(g)));
                GroupAddGroup(g0,g);
            }
            SaveGroupHandle(pausetable,0,0,g);
            DestroyGroup(g0);
            g0 = null;
            ForGroup(g,function PauseUnitsAllExEnum);
        }
        else
        {
            g = LoadGroupHandle(pausetable,0,0);

            //BJDebugMsg(I2S(CountUnitsInGroup(g))+" "+I2S(GetHandleId(g)));
            ForGroup(g,function PauseUnitsAllExEnum);
            FlushChildHashtable(pausetable,0);
            DestroyGroup(g);
        }
        
        g = null;
    }
    function onInit()
    {
        pausetable = InitHashtable();
    }
}