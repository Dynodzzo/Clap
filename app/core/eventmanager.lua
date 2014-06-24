-- EventManager class.

Game.EventManager = Game.Class({
	__name = 'EventManager',
	events = {},
});

function Game.EventManager:subscribe(name, ...)
	if (not self.events[name]) then
		self.events[name] = {};
	end
	
	for _, action in ipairs({...}) do
		if (type(action) == 'function') then
			table.insert(self.events[name], action);
		end
	end
end

function Game.EventManager:unsubscribe(name, ...)
	if (self.events[name]) then
		for indexA, actionA in ipairs(self.events[name]) do
			for _, actionB in ipairs({...}) do
				if (actionA == actionB) then
					table.remove(self.events[name], indexA);
				end
			end
		end
	end
end

function Game.EventManager:trigger(name, context, ...)
	if (self.events[name]) then
		for _, action in ipairs(self.events[name]) do
			action(context, ...); 
		end
	end
end
