-- GameStateManager class.

Game.GameStateManager = Game.Class({
	__name = 'GameStateManager',
	states = {},
});

function Game.GameStateManager:__init() end

function Game.GameStateManager:isGameState(state)
	if (getmetatable(state) == Game.GameState) then
		return true;
	else
		return false;
	end
end

function Game.GameStateManager:cleanUp()
	-- Clean up all states
	while (table.getn(self.states) > 0) do
		local lastStateIndex = table.getn(self.states);
		print(tostring(self.states[lastStateIndex]) .. ' - cleanup');
		
		self.states[lastStateIndex]:cleanUp();
		self.states[lastStateIndex] = nil;
	end
end

function Game.GameStateManager:changeState(state)
	if (self:isGameState(state)) then
		print(tostring(self.states[table.getn(self.states)]) .. ' - init');
		
		-- Clean up the current state
		if (table.getn(self.states) > 0) then
			local lastStateIndex = table.getn(self.states);

			self.states[lastStateIndex]:cleanUp();
			self.states[lastStateIndex] = nil;
		end

		table.insert(self.states, state);
		self.states[table.getn(self.states)]:init();
	end
end

function Game.GameStateManager:pushState(state)
	if (self:isGameState(state)) then
		-- Pauses the current state
		if (table.getn(self.states) > 0) then
			print(tostring(self.states[table.getn(self.states)]) .. ' - pause');
			self.states[table.getn(self.states)]:pause();
		end

		-- Loads the new state
		table.insert(self.states, state);
		self.states[table.getn(self.states)]:init();
	end
end

function Game.GameStateManager:popState()
	-- Clean up the current state
	if (table.getn(self.states) > 0) then
		local lastStateIndex = table.getn(self.states);

		self.states[lastStateIndex]:cleanUp();
		self.states[lastStateIndex] = nil;
	end

	-- Resume the previous state
	if (table.getn(self.states) > 0) then
		print(tostring(self.states[table.getn(self.states)]) .. ' - resume');
		self.states[table.getn(self.states)]:resume();
	end
end

function Game.GameStateManager:update(dt)
	if (table.getn(self.states) > 0) then
		self.states[table.getn(self.states)]:update(dt);
	end
end

function Game.GameStateManager:draw()
	if (table.getn(self.states) > 0) then
		self.states[table.getn(self.states)]:draw();
	end
end

function Game.GameStateManager:keypressed(key, isrepeat)
	if (table.getn(self.states) > 0) then
		self.states[table.getn(self.states)]:keypressed(key, isrepeat);
	end
end

function Game.GameStateManager:mousepressed(x, y, button)
	if (table.getn(self.states) > 0) then
		self.states[table.getn(self.states)]:mousepressed(x, y, button);
	end
end
