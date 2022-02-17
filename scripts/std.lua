local function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function cuttoargs(s)
	local pos = s:find(" ")
	if(not pos) then return nil end
	return s:sub(pos+1)
end

function getarg(s)
	if(not s) then return s end
	local pos = s:find(" ")
	if(not pos) then return s end
	return s:sub(0,pos-1),s:sub(pos+1) 
end