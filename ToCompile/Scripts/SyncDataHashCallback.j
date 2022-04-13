library SyncData requires APIMemoryBitwise
{
    public hashtable SyncHashTable = null;
    public gamecache PlayerDataCache = null;
    public integer previousgroups[];
    public integer prevpreviousgroups[];
    public integer no_data_marker=0;


    public constant integer si__Sync=1;
    public integer si__Sync_F=0;
    public integer si__Sync_I=0;
    public integer si__Sync_V[];
    public integer s__Sync_sync_offset=8192;

    function s__Sync_deallocate(integer this)
    {
        if (this==null)
        {
            DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Attempt to destroy a null struct of type: Sync");
            return;
        }
        else if (si__Sync_V[this]!=-1) 
        {
            DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,1000.,"Double free of type: Sync");
            return;
        }
        si__Sync_V[this]=si__Sync_F;
        si__Sync_F=this;
    }
    public function s__Sync_SyncPlayersInfoCallback ()
    {
        integer this=LoadInteger(SyncHashTable, GetHandleId(GetExpiredTimer()), 0);
        integer playerid=0;
        integer playerdata[];
        integer playergroup[];
        integer i;
        integer j;
        boolean b=true;
        trigger t;
        string datakey;
        for(0<=playerid<=11)
        {
            datakey=I2S(this + s__Sync_sync_offset    * playerid);
            playerdata[playerid]=GetStoredInteger(PlayerDataCache, "0", datakey);
            if ( GetPlayerSlotState(Player(playerid)) == PLAYER_SLOT_STATE_PLAYING ) {
                if ( playerdata[playerid] == no_data_marker ) {
                    b=false;
                }
            }
            playerid=playerid + 1;
        }
        if ( b ) 
        {
            b=false;
            for(0<=i<=11)
            {
                playergroup[i]=0;
                if ( GetPlayerSlotState(Player(i)) != PLAYER_SLOT_STATE_PLAYING ) {
                    previousgroups[i]=0;
                }
                for(0<=j<=11)
                {
                    if (  (GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING) && (playerdata[i] == playerdata[j]) ) {
                        playergroup[i]= playergroup[i] + PowI(2,j);
                    }
                }
                for(0<=j<=11)
                {
                    if( previousgroups[i]==0) {
                        previousgroups[i] = playergroup[i];
                    }
                    LeaderboardSetPlayerItemValueBJ(Player(i),SyncGroups,playergroup[i]);
                    if ( (previousgroups[i] != playergroup[i]) && (GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING )&& (playergroup[i]!=0)) {
                        //BJDebugMsg("Found difference: Player(" + I2S(i) + "): "+ GetPlayerName(Player(i))+", current group: " + IntToHex(playergroup[i]) + " previous: " + IntToHex(previousgroups[i]))
                        b=true;
                    }
                }
            }
            for(0<=i<=11)
            {
                if ( GetPlayerSlotState(Player(i)) != PLAYER_SLOT_STATE_PLAYING ) {
                    playergroup[i]=0;
                    previousgroups[i]=0;
                }
            }
            if ( b ) 
            {
                BJDebugMsg("|cfffc0707Desync Warning!|r");
                for(0<=i<=11)
                {
                    previousgroups[i]=playergroup[i];
                }
                ExecuteFunc("TryDump");
            }
            for(0<=playerid<=11)
            {
                datakey=I2S(this + s__Sync_sync_offset    * playerid);
                FlushStoredInteger(PlayerDataCache, "0", datakey);
            }
            FlushChildHashtable(SyncHashTable, GetHandleId(GetExpiredTimer()));
            DestroyTimer(GetExpiredTimer());
            s__Sync_deallocate(this);
        }
    }
    function OnInit()
    {
        integer i;
        PlayerDataCache=InitGameCache("Sync");
        SyncHashTable=InitHashtable();
        for(0<=i<=11)
        {
            previousgroups[i] = 0;
            prevpreviousgroups[i] = 0;
            i=i + 1;
        }
    }
}