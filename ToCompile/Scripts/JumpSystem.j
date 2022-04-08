library JumpSystem requires TimerData, Plan
    {
        real period = 0.05;
        real globalheightfactor = 0.3;
        function RemoveDestructableEnum(){
            KillDestructable(GetEnumDestructable());
        }  
        function JumpCallback()
        {
            timer t = GetExpiredTimer();
            unit u = LoadUnitHandle(timerdata,GetHandleId(t),0);
            integer remained  = LoadInteger(timerdata,GetHandleId(t),1);
            real angle = LoadReal(timerdata,GetHandleId(t),2);
            real step = LoadReal(timerdata,GetHandleId(t),3);
            integer count = LoadInteger(timerdata,GetHandleId(t),4);
            real heightplus = LoadReal(timerdata,GetHandleId(t),5);
            real jumpstep = LoadReal(timerdata,GetHandleId(t),6);
            boolean pause = LoadBoolean(timerdata,GetHandleId(t),7);
            boolean TreesDestroy = LoadBoolean(timerdata,GetHandleId(t),8);
            string animation = LoadStr(timerdata,GetHandleId(t),9);
            real dx;
            real dy;
            real x;
            real y;
            real h;
            location temploc = null;
            if((GetUnitTypeId(u)==0) || (GetWidgetLife(u)<0.1)) {
                DestroyTimer(t);
                remained = -1;
            }
            else
            {
                dx = Cos(angle)*step;
                dy = Sin(angle)*step;
                h = GetUnitFlyHeight(u);
                remained = remained - 1;
                if(remained>count/2)
                {
                    h = h + jumpstep;
                    heightplus = heightplus + jumpstep;
                }
                else if(remained>0) {
                    
                    h = h - jumpstep;
                    heightplus = heightplus - jumpstep;
                }
                else{
                    h = h - jumpstep;
                }
                x = GetUnitX(u)+dx;
                y = GetUnitY(u)+dy;
                SetUnitX(u,x);
                SetUnitY(u,y);
                UnitAddAbility(u,'Arav');
                SetUnitFlyHeight(u,h,0);
                UnitRemoveAbility(u,'Arav');
                if(TreesDestroy)
                {
                    temploc = Location(x,y);
                    EnumDestructablesInCircleBJ(150.00,temploc,function RemoveDestructableEnum);
                    RemoveLocation(temploc);
                    temploc = null;
                }
                SaveReal(timerdata,GetHandleId(t),5,heightplus);
                SaveInteger(timerdata,GetHandleId(t),1,remained);
            }
            if(remained>0)
            {
                TimerStart(t,period,false,function JumpCallback);
            }
            else
            {
                if(pause)
                {
                    PauseUnit(u,false);
                }
                else
                {
    
                    if(GetUnitCurrentOrder(u)==0)
                    {
                        IssueImmediateOrder(u,"stop");
                    }
                }
                SetUnitPathing(u,true);
                FlushChildHashtable(timerdata,GetHandleId(t));
                DestroyTimer(t);
                //BJDebugMsg("Jump Ended");
            }
            u = null;
            t = null;
        }
        public function JumpUnitDirection(unit u, real distance, real speed, real angle, real heightfactor,boolean TreesDestroy, string animation)
        {
        timer t = null;
        integer count;
        integer remained;
        real jumpstep;
        real step;
        real heightplus;
        boolean pause;
        //BJDebugMsg("Jump Beginned");
            if(GetUnitTypeId(u)==0 || GetWidgetLife(u)<0.1)
            {
                return;
            }
            else
            {
                t = CreateTimer();
                count = R2I(distance/(speed*period))+1;
                remained = count;
                step = speed*period;
                jumpstep = step*heightfactor;
                //real angle = GetUnitFacing(u);
                heightplus = 0;
                pause = false;
                //BJDebugMsg("Remaied: "+I2S(remained));
                //BJDebugMsg("Step: "+R2S(step));
                SaveUnitHandle(timerdata,GetHandleId(t),0,u);
                SaveInteger(timerdata,GetHandleId(t),1,remained);
                SaveReal(timerdata,GetHandleId(t),2,angle);
                SaveReal(timerdata,GetHandleId(t),3,step);
                SaveInteger(timerdata,GetHandleId(t),4,count);
                SaveReal(timerdata,GetHandleId(t),5,heightplus);
                SaveReal(timerdata,GetHandleId(t),6,jumpstep);
                SaveBoolean(timerdata,GetHandleId(t),7,false);
                SaveBoolean(timerdata,GetHandleId(t),8,TreesDestroy);
                SaveStr(timerdata,GetHandleId(t),9,animation);
                SetUnitPathing(u,false);
                PlanUnitImmediateOrder(u,OrderId("holdposition"),0.01);
                QueueUnitAnimationBJ(u,animation);
                TimerStart(t,period,false,function JumpCallback);
            }
            t = null;
            u = null;
            return;
        }
        public function JumpUnitPoint(unit u, real x, real y, real speed, real heightfactor, boolean TreesDestroy, string animation)
        {
            real dx = x - GetUnitX(u);
            real dy = y - GetUnitY(u);
            real distance = SquareRoot(Pow(dx,2)+Pow(dy,2));
            real angle = Atan2(dy,dx);
            
            JumpUnitDirection(u,distance, speed, angle, heightfactor, TreesDestroy,animation);
        }
        public function JumpUnitDistance(unit u, real distance, real speed, real heightfactor, boolean TreesDestroy, string animation)
        {
            real angle = GetUnitFacing(u)*bj_PI/180;
            //BJDebugMsg("Facing: "+R2S(angle));
            JumpUnitDirection(u,distance, speed, angle, heightfactor, TreesDestroy,animation);
        }
    }