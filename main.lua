-- New project - Main file
-- Code name Clap
-- by Dynodzzo

Game = {};

function love.load()
	require('app.init');
	
	gsm = Game.GameStateManager:new();
	gsm:pushState(Game.GameState:new());
end

function love.update(dt)
	
end

function love.draw()
	
end

function love.keypressed(key, isrepeat)
	print(key);
end
