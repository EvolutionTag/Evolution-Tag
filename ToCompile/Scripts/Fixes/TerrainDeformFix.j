library TerrainDeformFix
{
    function TerrainDeformFix()
    {
        integer oldprotection = VirtualProtect(pGameDLL+0x1608ED,8,0x40);
        WriteRealMemory(pGameDLL+0x1608ED,0x00008AE9);
        WriteRealMemory(pGameDLL+0x1608ED+4,0x90909000);
        VirtualProtect(pGameDLL+0x1608ED , 8 , oldprotection);
        oldprotection = VirtualProtect(pGameDLL+0x080DE0,4,0x40);
        WriteRealMemory(pGameDLL+0x080DE0,0xA19090C3);
        VirtualProtect(pGameDLL+0x080DE0 , 4 , oldprotection);
    }
    function onInit()
    {
        TimerStart(CreateTimer(),5,false,function TerrainDeformFix);
    }
}