Game.InGameState = Game.GameState:extends({
	__name = 'InGameState',
});

function Game.InGameState:init()
	self.grid = Game.Grid:new(10, 10, 50, 50, 5, 5, Game.Color.green);
end
function Game.InGameState:cleanUp() end

function Game.InGameState:pause() end
function Game.InGameState:resume() end

function Game.InGameState:update(dt)
	
end

function Game.InGameState:draw()
	self.grid:draw();
end

function Game.InGameState:mousepressed(x, y, button)
	
end

