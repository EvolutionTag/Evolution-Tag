library OpLimitEX
{
    public function DisableOPLimitStupid ()
    {
            integer oldprotection = 0;
            integer OpLimitAddress = pGameDLL + 0x45F7A8;
            oldprotection = ChangeOffsetProtection(OpLimitAddress,4,0x40);
            WriteRealMemory(OpLimitAddress,0xFFF282E9);
            ChangeOffsetProtection(OpLimitAddress,4,oldprotection);
    }
}