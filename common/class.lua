class = function(clsName, superCls)
	local cls = {}
	if superCls then
		setmetatable(cls, {__index = superCls})
		cls.super = superCls
	end
	cls.clsName = clsName
	
	function cls.new(...)
		local ret = {}
		setmetatable(ret, {__index = cls})
		ret:init(...)
		return ret
	end
	return cls
end