library SharedVisionDefault requires SharedVisionWithAllies
{


    function InitSharedVisionDefault()
    {

        integer idx = 0;
        for(0<=idx<=14) {// bj_PLAYERS_MAX
            ForceAddPlayer(ShareVision,Player(idx));
        }
        DestroyTimer(GetExpiredTimer());
    }
    function onInit()
    {
        TimerStart(CreateTimer(),0.01,false,function InitSharedVisionDefault);
    }
}