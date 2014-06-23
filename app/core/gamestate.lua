-- GameState class.
-- Base class for all the game states.
-- They must implement these methods.

Game.GameState = Game.Class({
	__name = 'GameState',
	game = {},
});

function Game.GameState:init() end
function Game.GameState:cleanUp() end

function Game.GameState:pause() end
function Game.GameState:resume() end

function Game.GameState:update(dt) end
function Game.GameState:draw() end

function Game.GameState:keypressed(key, isrepeat) end
function Game.GameState:keyreleased(key) end

function Game.GameState:mousepressed(x, y, button) end
function Game.GameState:mousereleased(x, y, button) end

function Game.GameState:changeState(state)
	self.game:changeState(state);
end