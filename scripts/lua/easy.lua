function mh()
	if(not renderhooked) then
		HookRender(true)
		renderhooked = true
	end
end

function mh0()
	mh()
	RenderStageEnable(0,false)
	RenderStageEnable(3,false)
	RenderStageEnable(4,false)
	RenderStageEnable(6,false)
	RenderStageEnable(14,false)
end

function umh0()
	RenderStageEnable(0,true)
	RenderStageEnable(3,true)
	RenderStageEnable(4,true)
	RenderStageEnable(6,true)
	RenderStageEnable(14,true)
end

function mh1()
	mh0()
	RenderStageEnable(2,false)
end


function umh1()
	umh0()
	RenderStageEnable(2,true)
end

function mh2()
	mh1()
	RenderStageEnable(1,false)
end


function umh2()
	umh1()
	RenderStageEnable(1,true)
end

function CamZF(s)
	local i = getarg(s)
	SetCameraField(CAMERA_FIELD_FARZ,tonumber(i),0)
end

function CamA(s)
	local i = getarg(s)
	SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK,tonumber(i),0)
end
function CamD(s)
	local i = getarg(s)
	SetCameraField(CAMERA_FIELD_TARGET_DISTANCE,tonumber(i),0)
end
function CamFov(s)
	local i = getarg(s)
	SetCameraField(CAMERA_FIELD_FIELD_OF_VIEW,tonumber(i),0)
end
function CamZ(s)
	local i = getarg(s)
	SetCameraField(CAMERA_FIELD_ZOFFSET,tonumber(i),0)
end
function CamRoll(s)
	local i = getarg(s)
	SetCameraField(CAMERA_FIELD_ROLL,tonumber(i),0)
end
function CamRot(s)
	local i = getarg(s)
	SetCameraField(CAMERA_FIELD_ROTATION,tonumber(i),0)
end

function HoldKey(s)
	local i = getarg(s)
	local key = VK[i]
	if(not key) then return end
	PressedKeys[key] = 2
end
function UnHoldKey(s)
	local i = getarg(s)
	local key = VK[i]
	if(not key) then return end
	PressedKeys[key] = nil
end
