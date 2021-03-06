-- New project - Main file
-- Code name Clap
-- by Dynodzzo

Game = {};

function love.load()
	require('app.init');
	
	Game.gsm = Game.GameStateManager:new();
	Game.gsm:pushState(Game.MainMenuState:new(Game.gsm));
end

function love.update(dt)
	Game.gsm:update(dt);
end

function love.draw()
	Game.gsm:draw();
	love.graphics.setFont(Game.Font.normal);
	love.graphics.setColor(Game.Color.black);
	love.graphics.print(love.timer.getFPS(), 10, 510);
end

function love.keypressed(key, isrepeat)
	Game.gsm:keypressed(key, isrepeat);
end

function love.keyreleased(key)
	Game.gsm:keyreleased(key);
end

function love.mousepressed(x, y, button)
	Game.gsm:mousepressed(x, y, button);
end

function love.mousereleased(x, y, button)
	Game.gsm:mousereleased(x, y, button);
end

function love.textinput(text)
	Game.gsm:textinput(text);
end
