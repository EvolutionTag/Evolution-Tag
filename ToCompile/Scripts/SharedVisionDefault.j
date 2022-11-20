library SharedVisionDefault requires SharedVisionWithAllies
{


    function InitSharedVisionDefault()
    {


        ForForce(bj_FORCE_ALL_PLAYERS,function(){
            ForceAddPlayer(ShareVision,GetEnumPlayer());
        });
        DestroyTimer(GetExpiredTimer());
    }
    function onInit()
    {
        TimerStart(CreateTimer(),0.01,false,function InitSharedVisionDefault);
    }
}