Game.InGameState = Game.GameState:extends({
	__name = 'InGameState',
});

function Game.InGameState:init()
	self.followMouse = false;
	self.fastMovement = false;
	
	self.camera = Game.Camera:new(
		love.window.getWidth() / 2,
		love.window.getHeight() / 2,
		love.window.getWidth(),
		love.window.getHeight(),
		Game.Color.transparent
	);
	self.camera:setScale(.5);
	
	self.oldMouseX = love.mouse.getX();
	self.oldMouseY = love.mouse.getY();
	self.oldMouseX, self.oldMouseY = self.camera:getCameraCoords(self.oldMouseX, self.oldMouseY);
	
	self.square = Game.Square:new(0, 0, 30, 30, Game.Color.blue);
	self.grid = Game.Grid:new(30, 30, 30, 30, 30, 16, Game.Color.green);
	
	self.square:setPosition(30, 30);
	
	self.testMap = require('app.game.levels.test');
	self.originCellX = 10;
	self.testMapSquares = {};
	
	for index, square in ipairs(self.testMap) do
		local squareCellX, squareCellY = self.grid:getCoordsFromCell(self.originCellX + square.x, square.y);
		table.insert(self.testMapSquares, Game.Square:new(squareCellX, squareCellY, 30, 30, Game.Color.gray));
	end
end
function Game.InGameState:cleanUp() end

function Game.InGameState:pause() end
function Game.InGameState:resume() end

function Game.InGameState:update(dt)
	local newMouseX = love.mouse.getX();
	local newMouseY = love.mouse.getY();
	newMouseX, newMouseY = self.camera:getCameraCoords(newMouseX, newMouseY);
	
	if (newMouseX ~= self.oldMouseX or newMouseY ~= self.oldMouseY) then
		if (self.followMouse) then
			self.camera:lookAt(love.mouse.getX(), love.mouse.getY());
		end
		self.oldMouseX = newMouseX;
		self.oldMouseY = newMouseY;
		if (self.grid:isInside(newMouseX, newMouseY)) then
			
			local selectedCellX, selectedCellY = self.grid:getCellFromCoords(newMouseX, newMouseY);
			self.square:setPosition(self.grid:getCoordsFromCell(selectedCellX, selectedCellY));
		end
	end
end

function Game.InGameState:draw()
	self.camera:push();
	
	for _, mapSquare in ipairs(self.testMapSquares) do
		if (self.grid:isInside(mapSquare:getX() + 1, mapSquare:getY() + 1)) then
			mapSquare:draw();
		end
	end
	self.square:draw();
	self.grid:draw();
	
	self.camera:pop();
	
	love.graphics.setColor(Game.Color.white);
	love.graphics.setFont(Game.Font.large);
	love.graphics.print('[m] - Follow mouse', 10, 10);
	love.graphics.print('[Wheel up/down] - Zoom in/out', 10, 30);
	love.graphics.print('[Shift + action] - Fast movement', 10, 50);
end

function Game.InGameState:keypressed(key, isrepeat)
	if (key == 'm') then
		self.followMouse = not self.followMouse;
	elseif (key == 'lshift') then
		self.fastMovement = true;
	end
end

function Game.InGameState:keyreleased(key)
	if (key == 'lshift') then
		self.fastMovement = false;
	end
end
			

function Game.InGameState:mousepressed(x, y, button)
	if (button == 'l') then
		print(self.grid:getCellFromCoords(self.camera:getCameraCoords(x, y)));
	elseif (button == 'wu') then
		self.camera:setScale(self.camera:getScale() + (self.fastMovement and .3 or .05));
	elseif (button == 'wd') then
		self.camera:setScale(self.camera:getScale() - (self.fastMovement and .3 or .05));
	end
end

