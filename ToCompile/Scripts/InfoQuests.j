library GoodToolInfoQuest{
    string commands = "|cff3399ffGame Commands:|r -gold <playerid> <amount>, -wood <playerid> <count> (send resources), -nre (no random events), -nn (no obstructions), -np (no pirates), -skip (vote to skip to final battle), -stats, -mode|r|nCheats: $key, $ui, $ui2, $screen, $screen <factor>, $mouse, $dmgmode <0/1/2>, $mh0/$umh0, $mh1/$umh1, $mh2/$umh2, $info, $scd, $std|n|nCam: $camz, $camzf, $cama, $camd, $camfov, $camzoff, $camroll, $camrot|n|nUse $clear to clear screen from messages";
    function onInit()
    {
        CreateQuestBJ(bj_QUESTTYPE_OPT_DISCOVERED,"Additional Commands",commands,"ReplaceableTextures\\CommandButtons\\BTNAmbush.blp");
    }
}