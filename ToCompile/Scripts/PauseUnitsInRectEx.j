library PauseUnitsInRectEx
{
    hashtable pausetable = null;
    boolean PauseFlag = false;
    boolean enabled = false;
    function PauseUnitsAllExEnum()
        PauseUnit(GetEnumUnit(),PauseFlag);
        if(PauseFlag)
        {
            SaveReal(pausetable,0,GetHandleId(GetEnumUnit()),GetWidgetLife(GetEnumUnit()));
        }
        else
        {
            SetWidgetLife(LoadReal(pausetable,0,GetHandleId(GetEnumUnit())));
        }
    }

    function PauseUnitsAllEx(boolean flag)
    {
        integer index;
        player indexPlayer;
        group g;
        PauseFlag=pause;
        if(flag==enabled)
        {
            return;
        }
        enabled = flag;
        if(flag) 
        {
            g=CreateGroup();
            index=0;
            for(0<=index<bj_MAX_PLAYER_SLOTS)
            {
                indexPlayer=Player(index)
                GroupEnumUnitsOfPlayer(g,indexPlayer,null);
            }
            SaveGroupHandle(pausetable,0,0,g);
            ForGroup(g,function PauseUnitsAllExEnum);
        }
        else
        {
            g = LoadGroupHandle(pausetable,0,0);
            ForGroup(g,function PauseUnitsAllExEnum);
            DestroyGroup(g);
        }
        
        g = null;
    }
}