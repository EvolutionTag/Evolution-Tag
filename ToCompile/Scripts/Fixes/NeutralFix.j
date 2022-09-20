library NeutralFix
{
    integer offsets[];
    integer data[];
    integer olddata[];
    function FixNeutralsZero()
    {
        //neutrals:
        AddNewOffsetToRestore(pGameDLL + 0xC8B53 , ReadRealMemory(pGameDLL + 0xC8B53 ));
        PatchMemory(pGameDLL + 0xC8B53 , 0x9090006A);
        AddNewOffsetToRestore(pGameDLL + 0xC8B54 , ReadRealMemory(pGameDLL + 0xC8B54 ));
        PatchMemory(pGameDLL + 0xC8B54 , 0x9090006A);
        AddNewOffsetToRestore(pGameDLL + 0xCB4F7 , ReadRealMemory(pGameDLL + 0xCB4F7 ));
        PatchMemory(pGameDLL + 0xCB4F7 , 0x9090006A);
        AddNewOffsetToRestore(pGameDLL + 0xCB4F8 , ReadRealMemory(pGameDLL + 0xCB4F8 ));
        PatchMemory(pGameDLL + 0xCB4F8 , 0x9090006A);
    }
    function OnInit()
    {
        TimerStart(CreateTimer(),10,false,function FixNeutralsZero);
    }
}