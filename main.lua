require "common/class"
require "common/event/Event"
require "common/event/EventDispatcher"
require "common/def/EventDef"

function main()
	local dispatcher = EventDispatcher.new()
	local event = Event.new(def.event.TestOne, {tab = "this is event One"})
	
	local listener = EventListener.new(def.event.TestOne, function(evt)
		print("recv: "..evt.tab)
	end, 1)
	
	local listener2 = EventListener.new(def.event.TestOne, function(evt)
		print("recv_2: "..evt.tab)
		-- return def.event.ret_break
	end, 2)
	
	local lsr_id = dispatcher:addListener(listener)
	local lsr_id_2 = dispatcher:addListener(listener2)
	
	dispatcher:addEvent(event)
	
	-- dispatcher:maskEvent(def.event.TestOne)
	-- dispatcher:cancelAllMaskEvent()
	-- dispatcher:removeListener(lsr_id_2)
	-- dispatcher:changeListenerPriority(lsr_id_2, 0)
	-- print(listener2.priority)
	dispatcher:broadcast()
end

main()


-- local test = {a = function(a,b) end, b = {a = "bbb", c = "ddd"}, d = {ww = "233"}}
-- local aaa = table.toString(test)
-- print(aaa)
-- table.dump(table.parse(aaa))