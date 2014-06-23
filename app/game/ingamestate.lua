Game.InGameState = Game.GameState:extends({
	__name = 'InGameState',
});

function Game.InGameState:init()
	self.oldMouseX = love.mouse.getX();
	self.oldMouseY = love.mouse.getY();
	
	self.square = Game.Square:new(0, 0, 30, 30, Game.Color.blue);
	self.grid = Game.Grid:new(30, 30, 30, 30, 30, 16, Game.Color.green);
	
	self.square:setPosition(30, 30);
end
function Game.InGameState:cleanUp() end

function Game.InGameState:pause() end
function Game.InGameState:resume() end

function Game.InGameState:update(dt)
	local newMouseX = love.mouse.getX();
	local newMouseY = love.mouse.getY();
	
	if (newMouseX ~= oldMouseX or newMouseY ~= oldMouseY) then
		if (self.grid:isInside(newMouseX, newMouseY)) then
			oldMouseX = newMouseX;
			oldMouseY = newMouseY;
			
			local selectedCellX, selectedCellY = self.grid:getCellFromCoords(newMouseX, newMouseY);
			self.square:setPosition(self.grid:getCoordsFromCell(selectedCellX, selectedCellY));
		end
	end
end

function Game.InGameState:draw()
	self.square:draw();
	self.grid:draw();
end

function Game.InGameState:mousepressed(x, y, button)
	if (button == 'l') then
		print(self.grid:getCoordsFromCell(self.grid:getCellFromCoords(x, y)));
	end
end

