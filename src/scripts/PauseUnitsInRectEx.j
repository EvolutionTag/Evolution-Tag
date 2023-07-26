library PauseUnitsInRectEx requires MemoryHackUnitNormalAPI
{
    hashtable pausetable = null;
    group activegroup = null;
    boolean PauseFlag = false;
    boolean enabled = false;
    function PauseEnum()
    {
        //BJDebugMsg("1000--w8489489749874789");
        PauseUnit(GetEnumUnit(),PauseFlag);
        
        if(PauseFlag)
        {
            if(GetHandleId(GetEnumUnit())!=0){
                SaveReal(pausetable,0,GetHandleId(GetEnumUnit()),GetWidgetLife(GetEnumUnit()));
                if(IsUnitInvulnerable(GetEnumUnit()))
                {
                    SaveBoolean(pausetable,1,GetHandleId(GetEnumUnit()),false);
                }
                else
                {
                    SetUnitInvulnerable(GetEnumUnit(),true);
                    SaveBoolean(pausetable,1,GetHandleId(GetEnumUnit()),true);
                }
            }
        }
        else
        {
            SetWidgetLife(GetEnumUnit(),LoadReal(pausetable,0,GetHandleId(GetEnumUnit())));
            if(LoadBoolean(pausetable,1,GetHandleId(GetEnumUnit()))) {
                SetUnitInvulnerable(GetEnumUnit(),false);
            }
        }
    }

    public function PauseUnitsAllEx(boolean pause)
    {
        integer index;
        PauseFlag=pause;
        if(pause==enabled)
        {
            //BJDebugMsg("return!!!");
            return;
        }
        enabled = pause;
        if(pause) 
        {
            activegroup=CreateGroup();
            GroupEnumUnitsInRect(activegroup,GetPlayableMapRect(),null);
            //BJDebugMsg(I2S(CountUnitsInGroup(activegroup))+" "+I2S(GetHandleId(activegroup)));
            ForGroup(activegroup,function PauseEnum);
            //BJDebugMsg(I2S(CountUnitsInGroup(activegroup))+" "+I2S(GetHandleId(activegroup)));
        }
    else
        {
            //BJDebugMsg(I2S(GetHandleId(activegroup)));
            //BJDebugMsg(I2S(CountUnitsInGroup(activegroup))+" "+I2S(GetHandleId(activegroup)));
            ForGroup(activegroup,function PauseEnum);
            FlushChildHashtable(pausetable,0);
            DestroyGroup(activegroup);
            activegroup = null;
        }
    
    }
    function onInit()
    {
        pausetable = InitHashtable();
    }
}