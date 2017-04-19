require "common/tools/Tools"

--字符串分隔
string.split = function (str, splitStr)
	local ret = {}
	for v in string.gmatch(str, "[^"..splitStr.."]+") do
	    ret[#ret+1] = v
	end
	return ret
end

--时间转字符串
string.timeToString = function (ttt)
    if ttt < 0 then 
        return  "00:00:00"
    end
    local h,m,s = 0,0,0
    h = math.floor(ttt/3600)    
    ttt = ttt - h*3600
    m = math.floor(ttt/60)      
    ttt = ttt - m*60
    s = ttt                     
    if h < 10 then h = "0"..h end
    if m < 10 then m = "0"..m end
    if s < 10 then s = "0"..s end
    local str = string.format("%s:%s:%s", h,m,s) 
    return str
end

