Game.EditorState = Game.GameState:extends({
	__name = 'EditorState',
});

function Game.EditorState:__init(gsm)
	Game.EditorState.super.__init(self, gsm);
end

function Game.EditorState:init(levelName)
	self.grabbed = false;
	self.followMouse = false;
	self.fastMovement = false;
	
	self.header = Game.Rectangle:new(0, 0, love.window.getWidth(), 60, Game.Color.customDarkGray);
	
	self.camera = Game.Camera:new(
		love.window.getWidth() / 2,
		love.window.getHeight() / 2,
		love.window.getWidth(),
		love.window.getHeight(),
		Game.Color.transparent
	);
	self.camera:setScale(.7);
	
	self.oldMouseX = love.mouse.getX();
	self.oldMouseY = love.mouse.getY();
	self.oldMouseX, self.oldMouseY = self.camera:getCameraCoords(self.oldMouseX, self.oldMouseY);
	
	self.squaresSize = 30;
	
	self.square = Game.Rectangle:new(0, 0, self.squaresSize, self.squaresSize, Game.Color.darkStateBlue);
	self.grid = Game.Grid:new(30, 30, self.squaresSize, self.squaresSize, 30, 16, Game.Color.customDarkGray);
	
	self.square:setPosition(30, 30);
	
	-- levelName = string.sub(levelName, 1, -5);
	-- self.levelsDirectory = 'app/game/levels/';
	self.levelsDirectory = 'levels/';
	self.saveLevelsDirectory = 'levels/';
	self.levelName = levelName;
	self.editedMap = love.filesystem.load(self.levelsDirectory .. self.levelName)();
	self.originCellX = 10;
	self.editedMapSquares = {};
	
	for index, square in ipairs(self.editedMap) do
		local squareCellX, squareCellY = self.grid:getCoordsFromCell(self.originCellX + square.x, square.y);
		table.insert(self.editedMapSquares, Game.Rectangle:new(squareCellX, squareCellY, 30, 30, Game.Color.darkGray));
	end
	
	local originLineX = self.grid:getCoordsFromCell(self.originCellX, 1);
	self.originLine = Game.Rectangle:new(originLineX, 30, 2, self.grid:getH(), Game.Color.red);
	self.grabOffsetX = 0;
	
	Game.EventManager:subscribe('onGridCellClick', self.onGridCellClick);
	Game.EventManager:subscribe('onSaveMapData', self.onSaveMapData);
end
function Game.EditorState:cleanUp()
	self.followMouse = nil;
	self.fastMovement = nil;
	self.camera = nil;
	self.oldMouseX = nil;
	self.oldMouseY = nil;
	self.square:cleanUp();
	self.square = nil;
	self.grid:cleanUp();
	self.grid = nil;
	self.levelsDirectory = nil;
	self.saveLevelsDirectory = nil;
	self.levelName = nil;
	self.editedMap = nil;
	self.originCellX = nil;
	for _, mapSquare in ipairs(self.editedMapSquares) do
		mapSquare:cleanUp();
		mapSquare = nil;
	end
	self.editedMapSquares = nil;
	self.originLine:cleanUp();
	self.originLine = nil;
	self.grabOffsetX = nil;
	Game.EventManager:unsubscribe('onGridCellClick', self.onGridCellClick);
	Game.EventManager:unsubscribe('onSaveMapData', self.onSaveMapData);
	
end

function Game.EditorState:pause() end
function Game.EditorState:resume() end

function Game.EditorState:update(dt)
	local newMouseX = love.mouse.getX();
	local newMouseY = love.mouse.getY();
	newMouseX, newMouseY = self.camera:getCameraCoords(newMouseX, newMouseY);
	
	if (newMouseX ~= self.oldMouseX or newMouseY ~= self.oldMouseY) then
		if (self.followMouse) then
			self.camera:lookAt(love.mouse.getX(), love.mouse.getY());
		end
		
		if (self.grabbed) then
			self.grabOffsetX = self.grabOffsetX + (newMouseX - self.oldMouseX);
			if (math.abs(self.grabOffsetX) >= self.squaresSize) then
				self:updateCellsOriginX(newMouseX, newMouseY);
				self.grabOffsetX = 0;
			end
		end
		
		if (self.grid:isInside(newMouseX, newMouseY)) then
			local selectedCellX, selectedCellY = self.grid:getCellFromCoords(newMouseX, newMouseY);
			self.square:setPosition(self.grid:getCoordsFromCell(selectedCellX, selectedCellY));
		end
		
		self.oldMouseX = newMouseX;
		self.oldMouseY = newMouseY;
	end
end

function Game.EditorState:draw()
	love.graphics.setBackgroundColor(Game.Color.whiteSmoke);
	
	self.camera:push();
	
	for _, mapSquare in ipairs(self.editedMapSquares) do
		if (self.grid:isInside(mapSquare:getX() + 1, mapSquare:getY() + 1)) then
			mapSquare:draw();
		end
	end
	self.square:draw();
	self.grid:draw();
	
	if (self.grid:isInside(self.originLine:getX() + 1, self.originLine:getY() + 1)) then
		self.originLine:draw();
	end
	
	self.camera:pop();
	
	self.header:draw();
	love.graphics.setColor(Game.Color.whiteSmoke);
	love.graphics.setFont(Game.Font.large);
	love.graphics.print('[m] - Follow mouse', 10, 10);
	love.graphics.print('[Wheel up/down] - Zoom in/out', 10, 30);
	love.graphics.print('[Shift + action] - Fast movement', 320, 10);
	love.graphics.print('[Echap] - Close editor', 320, 30);
end

function Game.EditorState:keypressed(key, isrepeat)
	if (key == 'm') then
		self.followMouse = not self.followMouse;
	elseif (key == 's') then
		Game.EventManager:trigger('onSaveMapData', self);
	elseif (key == 'lshift') then
		self.fastMovement = true;
	elseif (key == 'escape') then
		self.game:popState();
	end
end

function Game.EditorState:keyreleased(key)
	if (key == 'lshift') then
		self.fastMovement = false;
	end
end

function Game.EditorState:mousepressed(x, y, button)
	if (button == 'l') then
		local cameraX, cameraY = self.camera:getCameraCoords(x, y);
		
		if (self.grid:isInside(cameraX, cameraY)) then
			Game.EventManager:trigger('onGridCellClick', self, {x = cameraX, y = cameraY});
			-- print(self.grid:getCellFromCoords(self.camera:getCameraCoords(x, y)));
		end
	elseif (button == 'r') then
		self.grabbed = true;
	elseif (button == 'wu') then
		self.camera:setScale(self.camera:getScale() + (self.fastMovement and .3 or .05));
	elseif (button == 'wd') then
		self.camera:setScale(self.camera:getScale() - (self.fastMovement and .3 or .05));
	end
end

function Game.EditorState:mousereleased(x, y, button)
	if (button == 'r') then
		self.grabbed = false;
	end
end

function Game.EditorState:updateCellsOriginX(newMouseX, newMouseY)
	local offset = self.squaresSize;
	
	if (newMouseX < self.oldMouseX) then
		offset = -offset;
	end
	
	for _, mapSquare in ipairs(self.editedMapSquares) do
		mapSquare:moveX(offset);
	end
	
	self.originLine:moveX(offset);
	self.originCellX = self.originCellX + offset / self.squaresSize;
end

function Game.EditorState.onGridCellClick(self, event)
	local gridCellX, gridCellY = self.grid:getCellFromCoords(event.x, event.y);
	gridCellX = gridCellX - self.originCellX;
	local squareCellX, squareCellY = self.grid:getCoordsFromCell(self.originCellX + gridCellX, gridCellY);
	local squareIndex = 0;
	local isAlreadySquare = false;
	
	for index, square in ipairs(self.editedMap) do
		if (square.x == gridCellX and square.y == gridCellY) then
			isAlreadySquare = true;
			squareIndex = index;
		end
	end
	
	if (isAlreadySquare) then
		table.remove(self.editedMap, squareIndex);
		self.editedMapSquares[squareIndex]:cleanUp();
		table.remove(self.editedMapSquares, squareIndex);
	else
		-- Map data
		table.insert(self.editedMap, {x = gridCellX, y = gridCellY});
		
		-- Display data
		table.insert(self.editedMapSquares, Game.Rectangle:new(squareCellX, squareCellY, 30, 30, Game.Color.darkGray));
	end
end

function Game.EditorState.onSaveMapData(self, event)
	Game.Debug:print('Map saved to : ' .. self.saveLevelsDirectory .. '_' .. self.levelName);
	love.filesystem.write(self.saveLevelsDirectory .. self.levelName, Game.Serialize(self.editedMap));
end
