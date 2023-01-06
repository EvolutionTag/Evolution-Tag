
library NeutralAI requires InGameNeutrals, mainRNG{

        player TempPlayerNeutral = null;
        integer NeutralReactionRange = 800;
        real NeutralOrderTimerout = 10;
        real order_restore_timeout = 60.5;
        hashtable NeutralOrders = null;
        integer Order_point_type = 0;
        integer Order_random_point_in_rect = 1;
        trigger Death_Cleanup_trigger = null;

        function GetRandomXInRect(rect r)->real
        {
            return GenerateReal(MainGenerator, GetRectMinX(r),GetRectMaxX(r));
        }
        function GetRandomYInRect(rect r)->real
        {
            return GenerateReal(MainGenerator, GetRectMinY(r),GetRectMaxY(r));
        }


        function RestoreOrder(unit u) -> boolean
        {
            integer order_type;
            string order;
            real x;
            real y;
            if(HaveSavedInteger(NeutralOrders,GetHandleId(u),0))
            {
                order_type = LoadInteger(NeutralOrders,GetHandleId(u),0);
                if(order_type==Order_point_type)
                {
                    order = LoadStr(NeutralOrders,GetHandleId(u),1);
                    x = LoadReal(NeutralOrders,GetHandleId(u),2);
                    y = LoadReal(NeutralOrders,GetHandleId(u),3);
                    IssuePointOrder(u,order,x,y);
                    return true;
                }
                else if(order_type==Order_random_point_in_rect)
                {
                    order = LoadStr(NeutralOrders,GetHandleId(u),1);
                    x = GetRandomXInRect(LoadRectHandle(NeutralOrders,GetHandleId(u),2));
                    y = GetRandomYInRect(LoadRectHandle(NeutralOrders,GetHandleId(u),2));
                    IssuePointOrder(u,order,x,y);
                    return true;
                }

            }
            return false;
        }

        function ClearOrder(unit u)
        {
            if(HaveSavedInteger(NeutralOrders,GetHandleId(u),0))
            {
                FlushChildHashtable(NeutralOrders,GetHandleId(u));
            }
        }  


        function PeriodicRestoreOrder() {
            timer t = GetExpiredTimer();
            unit u = LoadUnitHandle(NeutralOrders,GetHandleId(t),0);
            if(u==null || GetWidgetLife(u)<0.4) {
                FlushChildHashtable(NeutralOrders,GetHandleId(t));
                FlushChildHashtable(NeutralOrders,GetHandleId(u));
                DestroyTimer(t);
            }
            else {
                RestoreOrder(u);
            }
        }


        function PeriodicRestoreRectOrder() {
            timer t = GetExpiredTimer();
            unit u = LoadUnitHandle(NeutralOrders,GetHandleId(t),0);
            integer hu;
            string order;
            rect r;
            real x;
            real y;
            // BJDebugMsg("PeriodicRestoreRectOrder");
            if(u==null) {
                // BJDebugMsg("rect order Unit is dead or does not exists: "+I2S(GetHandleId(u))+" "+R2S(GetWidgetLife(u)));
                RemoveSavedHandle(NeutralOrders,GetHandleId(t),0);
                DestroyTimer(t);
                t = null;
                return;
            }
            hu = GetHandleId(u);
            if (!UnitAlive(u)) {
                RemoveSavedHandle(NeutralOrders,GetHandleId(t),0);  
                RemoveSavedHandle(NeutralOrders,hu,2);
                RemoveSavedString(NeutralOrders,hu,1);
                DestroyTimer(t);
                u = null;
                t = null;
                return;
            }
            order = LoadStr(NeutralOrders,GetHandleId(u),1);
            r = LoadRectHandle(NeutralOrders,hu,2);
            x = GetRandomXInRect(r);
            y = GetRandomYInRect(r);
            r = null;
            IssuePointOrder(u,order,x,y);
            u = null;
            t = null;
        }

        function PeriodicRestorePointOrder() {
            timer t = GetExpiredTimer();
            unit u = LoadUnitHandle(NeutralOrders,GetHandleId(t),0);
            string order;
            real x;
            real y;
            // BJDebugMsg("PeriodicRestorePointOrder");
            if(u==null || GetWidgetLife(u)<0.4) {
                // BJDebugMsg("point order Unit is dead or does not exists: "+I2S(GetHandleId(u))+" "+R2S(GetWidgetLife(u)));
                FlushChildHashtable(NeutralOrders,GetHandleId(t));
                FlushChildHashtable(NeutralOrders,GetHandleId(u));
                DestroyTimer(t);
            }
            else {
                order = LoadStr(NeutralOrders,GetHandleId(u),1);
                x = LoadReal(NeutralOrders,GetHandleId(u),2);
                y = LoadReal(NeutralOrders,GetHandleId(u),3);
                IssuePointOrder(u,order,x,y);
                // BJDebugMsg("point order: "+order+" "+R2S(x)+" "+R2S(y)+" "+I2S(GetHandleId(u)));
            }
        }

        public function NeutralIssuePointOrderSaved(unit u, string order, real x, real y)
        {
            timer t = CreateTimer();
            SaveInteger(NeutralOrders,GetHandleId(u),0,Order_point_type);
            SaveStr(NeutralOrders,GetHandleId(u),1,order);
            SaveReal(NeutralOrders,GetHandleId(u),2,x);
            SaveReal(NeutralOrders,GetHandleId(u),3,y);
            IssuePointOrder(u,order,x,y);
            SaveUnitHandle(NeutralOrders,GetHandleId(t),0,u);
            TimerStart(t,order_restore_timeout,true,function PeriodicRestorePointOrder);
        }

        public function NeutralIssuePointOrderSavedLoc(unit u, string order, location loc)
        {
            timer t = CreateTimer();
            SaveInteger(NeutralOrders,GetHandleId(u),0,Order_point_type);
            SaveStr(NeutralOrders,GetHandleId(u),1,order);
            SaveReal(NeutralOrders,GetHandleId(u),2,GetLocationX(loc));
            SaveReal(NeutralOrders,GetHandleId(u),3,GetLocationY(loc));
            IssuePointOrder(u,order,GetLocationX(loc),GetLocationY(loc));
            SaveUnitHandle(NeutralOrders,GetHandleId(t),0,u);
            TimerStart(t,order_restore_timeout,true,function PeriodicRestorePointOrder);
        }

        
        public function NeutralIssueOrderRandomLocInRect(unit u, string order, rect r)
        {
            timer t = CreateTimer();
            SaveStr(NeutralOrders,GetHandleId(u),1,order);
            SaveRectHandle(NeutralOrders,GetHandleId(u),2,r);
            IssuePointOrder(u,order,GetRandomXInRect(r),GetRandomYInRect(r));
            SaveUnitHandle(NeutralOrders,GetHandleId(t),0,u);
            TimerStart(t,order_restore_timeout,true,function PeriodicRestoreRectOrder);

        }

        function CheckUnitForAllyFilter() -> boolean
        {
            if(IsPlayerEnemy(GetOwningPlayer(GetFilterUnit()),TempPlayerNeutral)) {
                return true;
            }
            return false;
        }

        function NeutralOrderEnum(){
            unit ordered = GetEnumUnit();
            real x = GetUnitX(ordered);
            real y = GetUnitY(ordered);
            group g = CreateGroup();
            unit u = null;
            GroupEnumUnitsInRange(g,x,y,NeutralReactionRange, function CheckUnitForAllyFilter);
            u = FirstOfGroup(g);
            if(u==null) {
                if(!RestoreOrder(ordered))
                {
                    IssueImmediateOrder(ordered,"stop");
                }
            }
            else
            {
                IssueTargetOrder(ordered,"attack",u);
            }
            DestroyGroup(g);
            u = null;
            g = null;
            ordered = null;
        }

        function OrderForNeutral(player p){
            group g = CreateGroup();
            GroupEnumUnitsOfPlayer(g,p,null);
            ForGroup(g, function NeutralOrderEnum);
            DestroyGroup(g);
            g = null;
        }

        function OrderForAllNeutrals(){
            ForForce(Neutral_Players,function() {OrderForNeutral(GetEnumPlayer());});
        }

        public function onInit(){
            NeutralOrders = InitHashtable();
            //TimerStart(CreateTimer(),NeutralOrderTimerout,true, function OrderForAllNeutrals);
            //Death_Cleanup_trigger = CreateTrigger();
            //ForForce(bj_FORCE_ALL_PLAYERS,function(){TriggerRegisterPlayerUnitEvent(Death_Cleanup_trigger,GetEnumPlayer(),EVENT_PLAYER_UNIT_DEATH,function()->boolean {return IsPlayerInForce(GetTriggerPlayer(),Neutral_Players);});} );
            Neutral_Players = CreateForce();
            //TriggerAddAction(Death_Cleanup_trigger, function() {ClearOrder(GetDyingUnit());});
        }
}

