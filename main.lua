-- New project - Main file
-- Code name Clap
-- by Dynodzzo

Game = {};

function love.load()
	require('app.init');
	
	Game.gsm = Game.GameStateManager:new();
	Game.gsm:pushState(Game.InGameState:new());
end

function love.update(dt)
	Game.gsm:update(dt);
end

function love.draw()
	Game.gsm:draw();
end

function love.keypressed(key, isrepeat)
	Gam.gsm:keypressed(key, isrepeat);
end
