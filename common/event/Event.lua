require "common/class"

Event = class("Event")
function Event:init(name, args)
	self.name = name
	self.args = args
end

EventListener = class("EventListener")
function EventListener:init(name, recvFunc, priority)
	self.name = name
	self.recv = recvFunc
	self.priority = priority or 0
end


