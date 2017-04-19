require "common/class"
require "common/tools/StringTools"
require "common/tools/TableTools"
require "common/def/EventDef"
EventDispatcher = class("EventDispatcher")
local cls = EventDispatcher

local EventListener = {
	name = "error",
	priority = 0,
	excute = function (event)
		
	end,
}

function cls:init()
	self._listeners = {}
	self._indexs = {}
	self._prioritys = {}
	self._events = {}
	self._maskEvents = {}
end

function cls:addEvent(event)
	self._events[event] = true
end

function cls:maskEvent(eventName)
	self._maskEvents[eventName] = true
end
function cls:cancelMaskEvent(event)
	self._maskEvents[eventName] = nil
end
function cls:cancelAllMaskEvent()
	self._maskEvents = {}
end

function cls:addListener(listener)
	local name = listener.name
	local priority = listener.priority or 0
	
	local _listeners = self._listeners
	local _indexs = self._indexs
	local _prioritys = self._prioritys
	
	_listeners[name] = _listeners[name] or {}
	_listeners[name][priority] = _listeners[name][priority] or {}
	_indexs[name] = _indexs[name] or {}
	_indexs[name][priority] = _indexs[name][priority] or 0
	_prioritys[name] = _prioritys[name] or {}


	local l_list = _listeners[name][priority]
	_indexs[name][priority] = _indexs[name][priority] + 1
	local index = _indexs[name][priority]
	l_list[index] = listener

	if not table.find(_prioritys[name], priority) then
		table.insert(_prioritys[name], priority)
		table.sort(_prioritys[name], function (a, b)
			return a > b
		end)
	end

	return name.."_"..priority.."_"..index
end
	
function cls:removeListener(id)
	local tags = string.split(id, "_")
	local name = tags[1]
	local priority = tonumber(tags[2])
	local index = tonumber(tags[3])
	
	local _listeners = self._listeners
	if _listeners[name] and _listeners[name][priority] then 
		_listeners[name][priority][index] = nil
	end
end

function cls:changeListenerPriority(id, newPriority)
	local tags = string.split(id, "_")
	local name = tags[1]
	local priority = tonumber(tags[2])
	local index = tonumber(tags[3])
	
	local _listeners = self._listeners
	if _listeners[name] and _listeners[name][priority] then 
		local listener = _listeners[name][priority][index] 
		_listeners[name][priority][index] = nil 
		listener.priority = newPriority
		self:addListener(listener)
	end
end

function cls:clear()
	self._listeners = {}
	self._indexs = {}
	self._prioritys = {}
end
	
function cls:broadcast()
	print("broadcast event:")
	for event,_ in pairs(self._events) do
		if not self._maskEvents[event.name] then
			table.dump(event)
			
			local _listeners = self._listeners
			local _prioritys = self._prioritys
			local name = event.name
			local listeners = _listeners[name]
			
			if listeners then
				for i=1, #_prioritys[name] do
					local priority = _prioritys[name][i]
					for k,v in pairs(listeners[priority]) do
						local ret = v.recv(event.args)
						if ret == def.event.ret_break then
							return
						end
					end
				end
			end
		end
	end
end

