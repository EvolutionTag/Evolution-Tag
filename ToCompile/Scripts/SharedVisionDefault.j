library SharedVisionDefault requires SharedVisionWithAllies
{


    function InitSharedVisionDefault()
    {
        ForceAddPlayer(ShareVision,Player(12));
        ForceAddPlayer(ShareVision,Player(13));
        ForceAddPlayer(ShareVision,Player(14));
        DestroyTimer(GetExpiredTimer());
    }
    function onInit()
    {
        TimerStart(CreateTimer(),0.01,false,function InitSharedVisionDefault);
    }
}