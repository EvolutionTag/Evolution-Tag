library JumpSystem requires TimerData, Plan
    {
        public key kOwner;
        public key kRemained;
        public key kAngle;
        public key kStep;
        public key kCount;
        public key kHeightplus;
        public key kJumpStep;
        public key kPause;
        public key kTreesDestroy;
        public key kAnimation;
        public key kTarget;
        public key kCallback;
        public key kFlush;
        timer RetTimer;
        real period = 0.05;
        real period_hk = 0.02;
        real globalheightfactor = 0.3;
        function RemoveDestructableEnum(){
            if(IsTree(GetEnumDestructable()))
            {
                KillDestructable(GetEnumDestructable());
            }
        }  
        function JumpCallback()
        {
            timer t = GetExpiredTimer();
            unit u = LoadUnitHandle(timerdata,GetHandleId(t),kOwner);
            integer remained  = LoadInteger(timerdata,GetHandleId(t),kRemained);
            real angle = LoadReal(timerdata,GetHandleId(t),kAngle);
            real step = LoadReal(timerdata,GetHandleId(t),kStep);
            integer count = LoadInteger(timerdata,GetHandleId(t),kCount);
            real heightplus = LoadReal(timerdata,GetHandleId(t),kHeightplus);
            real jumpstep = LoadReal(timerdata,GetHandleId(t),kJumpStep);
            boolean pause = LoadBoolean(timerdata,GetHandleId(t),kPause);
            boolean TreesDestroy = LoadBoolean(timerdata,GetHandleId(t),kTreesDestroy);
            string animation = LoadStr(timerdata,GetHandleId(t),kAnimation);
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
                if(h<0) {h=0;} 
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
                SaveReal(timerdata,GetHandleId(t),kHeightplus,heightplus);
                SaveInteger(timerdata,GetHandleId(t),kRemained,remained);
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
                SaveUnitHandle(timerdata,GetHandleId(t),kOwner,u);
                SaveInteger(timerdata,GetHandleId(t),kRemained,remained);
                SaveReal(timerdata,GetHandleId(t),kAngle,angle);
                SaveReal(timerdata,GetHandleId(t),kStep,step);
                SaveInteger(timerdata,GetHandleId(t),kCount,count);
                SaveReal(timerdata,GetHandleId(t),kHeightplus,heightplus);
                SaveReal(timerdata,GetHandleId(t),kJumpStep,jumpstep);
                SaveBoolean(timerdata,GetHandleId(t),kPause,false);
                SaveBoolean(timerdata,GetHandleId(t),kTreesDestroy,TreesDestroy);
                SaveStr(timerdata,GetHandleId(t),kAnimation,animation);
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
            JumpUnitDirection(u,distance, speed, angle, heightfactor, TreesDestroy,animation);
        }




        ////////////////////////////////////////////////
        ////////////////////////////////////////////////
        ////////////////////////////////////////////////
        ////////////////////////////////////////////////
        ////////////////////////////////////////////////
        ////////////////////////////////////////////////
        ////////////////////////////////////////////////
        ////////////////////////////////////////////////

        function JumpCallbackUnit()
        {
            timer t = GetExpiredTimer();
            unit u = LoadUnitHandle(timerdata,GetHandleId(t),kOwner);
            unit target = LoadUnitHandle(timerdata,GetHandleId(t),kTarget);
            boolean pause = LoadBoolean(timerdata,GetHandleId(t),kPause);
            boolean TreesDestroy = LoadBoolean(timerdata,GetHandleId(t),kTreesDestroy);
            string animation = LoadStr(timerdata,GetHandleId(t),kAnimation);
            string callback = LoadStr(timerdata,GetHandleId(t),kCallback);
            real step = LoadReal(timerdata,GetHandleId(t),kStep);
            boolean ended = false;
            real dx;
            real dy;
            real x;
            real y;
            real h;
            real tmp;
            real anglex = 0;
            real angley = 0;
            real xtarget;
            real ytarget;
            real facing;
            location temploc = null;
            if((GetUnitTypeId(u)==0) || (GetWidgetLife(u)<0.1) && (GetUnitTypeId(target)==0) || (GetWidgetLife(target)<0.1)) {
                DestroyTimer(t);
                ended = true;
            }
            else
            {
                x = GetUnitX(u);
                y = GetUnitY(u);
                xtarget = GetUnitX(target);
                ytarget = GetUnitY(target);
                dx = xtarget-x;
                dy = ytarget-y;
                tmp = Pow(dx*dx+dy*dy,0.5);
                dx = dx*step/tmp;
                dy = dy*step/tmp;
                if((tmp)<(step*1.2)) {
                    x = xtarget;
                    y = ytarget;
                    ended = true;
                }
                else
                {
                    x = x+dx;
                    y = y+dy;
                }
                SetUnitFacing(u,Atan2(dx,dy));
                SetUnitX(u,x);
                SetUnitY(u,y);
                if(TreesDestroy)
                {
                    temploc = Location(x,y);
                    EnumDestructablesInCircleBJ(150.00,temploc,function RemoveDestructableEnum);
                    RemoveLocation(temploc);
                    temploc = null;
                }
            }
            if(ended == false)
            {
                TimerStart(t,period,false,function JumpCallbackUnit);
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
                ExecuteFunc(callback);
                SetUnitPathing(u,true);
                //SetUnitPosition(u,GetUnitX(u),GetUnitY(u));
                FlushChildHashtable(timerdata,GetHandleId(t));
                DestroyTimer(t);
            }
            u = null;
            t = null;
        }



        public function JumpUnitUnitEx(unit u,  unit target, real speed, boolean TreesDestroy, string animation, string callback)->timer
        {
            timer t = null;
            real jumpstep;
            real step;
            boolean pause;
            if(GetUnitTypeId(u)==0 || GetWidgetLife(u)<0.1)
            {
                return null;
            }
            else
            {
                t = CreateTimer();
                step = speed*period;
                pause = false;
                SaveUnitHandle(timerdata,GetHandleId(t),kOwner,u);
                SaveBoolean(timerdata,GetHandleId(t),kPause,pause);
                SaveBoolean(timerdata,GetHandleId(t),kTreesDestroy,TreesDestroy);
                SaveStr(timerdata,GetHandleId(t),kAnimation,animation);
                SaveStr(timerdata,GetHandleId(t),kCallback,callback);
                SaveUnitHandle(timerdata,GetHandleId(t),kTarget,target);
                SaveReal(timerdata,GetHandleId(t),kStep,step);
                SetUnitPathing(u,false);
                PlanUnitImmediateOrder(u,OrderId("holdposition"),0.01);
                QueueUnitAnimationBJ(u,animation);
                TimerStart(t,period_hk,false,function JumpCallbackUnit);
            }
            RetTimer = t;
            t = null;
            u = null;
            return RetTimer;
        }
    }