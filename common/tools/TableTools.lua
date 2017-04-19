require "common/tools/Tools"

table.find = function (tb, v)
	for tk,tv in pairs(tb) do
		if tv == v then
			return tk
		end
	end
end

table.find = function (tb, v)
	for tk,tv in pairs(tb) do
		if tv == v then
			return tk
		end
	end
end

table.size = function(ttable)
    local size = 0
    if (ttable == nil or type(ttable) ~= "table") then
        return 0
    end
    for k, v in pairs(ttable) do
        size = size + 1
    end
    return size
end

table.isEqual = function(t1, t2)
    if table.size(t1) == table.size(t2) then
        for k, v in pairs(t1) do
            if t2[k] ~= v then
                return false
            end
        end
    end
    return true
end

table.has = function(t, value)
    for k, v in pairs(t) do
        if v == value then
            return true
        end
    end
    return false
end

table.isEmpty = function(t)
    if type(t) ~= "table" then
        return true
    end
    for k, v in pairs(t) do
        return false
    end
    return true
end

table.merge = function(from, to)
    for k, v in pairs(from) do
        to[k] = v
    end
end

table.copy = function (t)
    local t2 = {}
    for k,v in pairs(t) do
        if type(v) == "table" then
            t2[k] = table.copy(v)
        else
            t2[k] = v
        end
    end
    return t2
end


local function tableDump(t, indent, other)
    if not indent and type(t) ~= "table" then return end
    if indent == nil then indent = 0 end --缩进默认值
    if other == nil then other = {} end --other默认值
    if next(t) == nil then
        if next(other) == nil then return end --双空结束
        indent = indent - 4
        return tableDump(table.remove(other), indent, other)
    end 

    --缩进字符串
    local indentStr = string.rep(" ", indent)

    local now = nil
    for k,v in pairs(t) do
        if type(v) ~= "table" then
            if type(v) == "number" then
                print(indentStr.."["..k.."] = "..v)
            elseif type(v) == "string" then
                print(indentStr.."["..k.."] = \""..v.."\"")
            elseif type(v) == "boolean" then
                print(indentStr.."["..k.."] = "..(v and "true" or "false"))
            else
                print(indentStr.."["..k.."] is "..type(v))
            end
        else
            now = v
            table.insert(other,t)
            indent = indent + 4
            print(indentStr.."["..k.."] is "..type(v))
        end
        t[k] = nil
        break
    end

    return tableDump(now or t, indent, other)
end

--缩进风格打印表
table.dump = function (t)
    print("==================  table.dump_Start  ==================")
    if type(t) == "table" then
        tableDump(table.copy(t))
    else
        print("error paramType: "..type(t))
        if t then
            local v = t
            if type(v) == "number" then
                print("[param] = "..v)
            elseif type(v) == "string" then
                print("[param] = \""..v.."\"")
            elseif type(v) == "boolean" then
                print("[param] = "..(v and "true" or "false"))
            end
        end
    end
    print("==================  table.dump_End  ==================\n")
end


--表转为字符串
local function _list_table(tb, level)
    local ret = ""
    local indent = string.rep(" ", level*4)

    for k, v in pairs(tb) do
        local quo = type(k) == "string" and "\"" or ""
        ret = ret .. indent .. "[" .. quo .. tostring(k) .. quo .. "] = "

        if type(v) == "table" then
			ret = ret .. "{\n"
			ret = ret .. _list_table(v, level+1)
			ret = ret .. indent .. "},\n"
        elseif type(v) == "string" then
            ret = ret .. "\"" .. tostring(v) .. "\",\n"
        elseif type(v) == "number" or type(v) == "boolean" then
            ret = ret .. tostring(v) .. ",\n"
		else
			ret = ret .. "\"" .. type(v) .. "\",\n"
        end
    end
	return ret
end

--表转换为字符串 (存储用)
table.toString = function(tb, isFormat)
	isFormat = isFormat or false
    if type(tb) ~= "table" then
        error("Sorry, it's not table, it is " .. type(tb) .. ".")
    end

    local ret = "{\n"
    ret = ret .. _list_table(tb, 1)
    ret = ret .. "}"
	if isFormat == false then
		ret = string.gsub(ret, "[\n ]", "")
	end
    return ret
end

--字符串转换为表 (读取用)
table.parse = function(str)
	return loadstring("return "..str)()
end
