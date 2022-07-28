library NeutralFix
{
    integer offsets[];
    integer data[];
    integer olddata[];
    public function FixNeutralsA()
    {
        DestroyTimer(GetExpiredTimer());
        PatchMemory(pGameDLL+offsets[1],data[1]);
        PatchMemory(pGameDLL+offsets[2],data[2]);
        PatchMemory(pGameDLL+offsets[3],data[3]);
        PatchMemory(pGameDLL+offsets[4],data[4]);
        PatchMemory(pGameDLL+offsets[5],data[5]);
        BJDebugMsg("FixNeutralsA");
        TimerStart(CreateTimer(),30,false,function() { ExecuteFunc("FixNeutralsB"); });
    }
    function FixNeutralsZero()
    {
        DestroyTimer(GetExpiredTimer());
        olddata[1] = ReadRealMemory(pGameDLL+offsets[1]);
        olddata[2] = ReadRealMemory(pGameDLL+offsets[2]);
        olddata[3] = ReadRealMemory(pGameDLL+offsets[3]);
        olddata[4] = ReadRealMemory(pGameDLL+offsets[4]);
        olddata[5] = ReadRealMemory(pGameDLL+offsets[5]);
        FixNeutralsA();
    }

    public function FixNeutralsB()
    {
        DestroyTimer(GetExpiredTimer());
        PatchMemory(pGameDLL+offsets[1],olddata[1]);
        PatchMemory(pGameDLL+offsets[2],olddata[2]);
        PatchMemory(pGameDLL+offsets[3],olddata[3]);
        PatchMemory(pGameDLL+offsets[4],olddata[4]);
        PatchMemory(pGameDLL+offsets[5],olddata[5]);
        BJDebugMsg("FixNeutralsB");

        TimerStart(CreateTimer(),30,false,function() {ExecuteFunc("FixNeutralsA"); });
    }
    function OnInit()
    {
        offsets[1] = 0x0C6780; 
        offsets[2] = 0x0C6784; 
        offsets[3] = 0xC8B20 ; 
        offsets[4] = 0xC8B24 ; 
        offsets[5] = 0xC8B28 ; 
        data[1] = 0x000000B8;
        data[2] = 0x8B90C300;
        data[3] = 0x72D61CB9;
        data[4] = 0x746BBA4E;
        data[5] = 0x57C34161;
        TimerStart(CreateTimer(),10,false,function FixNeutralsZero);
        DisplayTextToPlayer(GetLocalPlayer(),0,0,"fuck");
    }
}