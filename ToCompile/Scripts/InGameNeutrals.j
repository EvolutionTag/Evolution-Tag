library InGameNeutrals{
    public force Neutral_Players = null;
    public player Neutral_Pirates = null;
    public player Neutral_Satyrs = null;
    public player Neutral_Bottom = null;
    public player Neutral_Nagas = null;

    function onInit() {

        integer i;
        for(0<=i<bj_MAX_PLAYERS) {
            if((Neutral_Pirates==null) && (GetPlayerSlotState(Player(i))==PLAYER_SLOT_STATE_EMPTY) && (!IsPlayerInForce(Player(i),Neutral_Players))) {
                SetPlayerController(Player(i),MAP_CONTROL_COMPUTER);
                Neutral_Pirates = Player(i);
                Neutral_Satyrs = Neutral_Pirates;
                ForceAddPlayer(Neutral_Players,Player(i));
                SetPlayerColor(Player(i),PLAYER_COLOR_BROWN);
                i = i +1;
                if(i>=bj_MAX_PLAYERS) {break;}
            }
            if(Neutral_Bottom==null && GetPlayerSlotState(Player(i))==PLAYER_SLOT_STATE_EMPTY && (!IsPlayerInForce(Player(i),Neutral_Players))) {
                SetPlayerController(Player(i),MAP_CONTROL_COMPUTER);
                Neutral_Bottom = Player(i);
                ForceAddPlayer(Neutral_Players,Player(i));
                SetPlayerColor(Player(i),PLAYER_COLOR_BROWN);
                i = i +1;
                if(i>=bj_MAX_PLAYERS) {break;}
            }
            if(Neutral_Nagas==null && GetPlayerSlotState(Player(i))==PLAYER_SLOT_STATE_EMPTY && (!IsPlayerInForce(Player(i),Neutral_Players))) {
                SetPlayerController(Player(i),MAP_CONTROL_COMPUTER);
                Neutral_Nagas = Player(i);
                ForceAddPlayer(Neutral_Players,Player(i));
                SetPlayerColor(Player(i),PLAYER_COLOR_BROWN);
                i = i +1;
                if(i>=bj_MAX_PLAYERS) {break;}
            }
          
        }
        if(Neutral_Pirates==null) {
            Neutral_Pirates = Player(13);
            Neutral_Satyrs = Neutral_Pirates;
        }
        
        if(Neutral_Nagas==null) {
            Neutral_Nagas = Player(12);
        }
        
        if(Neutral_Bottom==null) {
            Neutral_Bottom = Player(13);
        }
        
        
        
    }
}