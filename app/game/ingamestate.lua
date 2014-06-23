Game.InGameState = Game.GameState:extends({
	__name = 'InGame',
});

function Game.InGameState:init() end
function Game.InGameState:cleanUp() end

function Game.InGameState:pause() end
function Game.InGameState:resume() end

function Game.InGameState:update(dt) end
function Game.InGameState:draw()
	love.graphics.print('Hello', 10, 10);
end
