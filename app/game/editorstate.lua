Game.EditorState = Game.GameState:extends({
	__name = 'EditorState',
});

function Game.EditorState:__init(gsm)
	Game.EditorState.super.__init(self, gsm);
end

function Game.EditorState:init(levelName)
	local wWidth = love.window.getWidth();
	local wHeight = love.window.getHeight();
	self.grabbed = false;
	self.followMouse = false;
	self.fastMovement = false;
	
	self.headerHeight = 80;
	self.rightBarWidth = 35;
	self.header = Game.Rectangle:new(0, 0, wWidth, self.headerHeight, Game.Color.customDarkGray);
	self.rightBar = Game.Rectangle:new(
		wWidth - self.rightBarWidth,
		self.headerHeight,
		self.rightBarWidth,
		wHeight,
		Game.Color.customDarkGray
	);
	
	self.shapesSize = 30;
	self.shapesOffset = 20;
	self.gridOffset = {x = 30, y = 40 + self.headerHeight / 2};
	
	self.shapes = {
		square = Game.Rectangle:new(
			self.rightBar:getX() + 10,
			self.rightBar:getY() + 10,
			self.shapesSize / 2,
			self.shapesSize / 2,
			Game.Color.whiteSmoke
		),
		ground = Game.Rectangle:new(
			self.rightBar:getX() + 10,
			self.rightBar:getY() + (10 + self.shapesOffset) * 2,
			self.shapesSize / 2,
			5,
			Game.Color.whiteSmoke
		),
		triangle = Game.Triangle:new(
			self.rightBar:getX() + 10,
			self.rightBar:getY() + (10 + self.shapesOffset) * 3,
			self.shapesSize / 2,
			Game.Color.whiteSmoke
		)
	};
	
	self.selectedShape = 'square';
	self:updateSelectedShape(self.selectedShape);
	
	self.selectionSquare = Game.Rectangle:new(0, 0, self.shapesSize, self.shapesSize, Game.Color.darkStateBlue);
	self.grid = Game.Grid:new(
		self.gridOffset.x,
		self.gridOffset.y,
		self.shapesSize,
		self.shapesSize,
		30,
		16,
		Game.Color.customDarkGray
	);
	
	self.selectionSquare:setPosition(self.gridOffset.x, self.gridOffset.y);
	
	-- levelName = string.sub(levelName, 1, -5);
	-- self.levelsDirectory = 'app/game/levels/';
	self.levelsDirectory = 'levels/';
	self.saveLevelsDirectory = 'levels/';
	self.levelName = levelName;
	self.originCellX = 10;
	self.editedMap = love.filesystem.load(self.levelsDirectory .. self.levelName)() or {};
	self.editedMapShapes = {};
	
	if (table.getn(self.editedMap) > 0) then
		for index, shape in ipairs(self.editedMap) do
			local shapeCellX, shapeCellY = self.grid:getCoordsFromCell(self.originCellX + shape.x, shape.y);
			local newShape = {};
			
			if (shape.t == 1) then
				newShape = Game.Rectangle:new(
					shapeCellX,
					shapeCellY,
					self.shapesSize,
					self.shapesSize,
					Game.Color.darkGray
				);
			elseif (shape.t == 2) then
				newShape = Game.Rectangle:new(
					shapeCellX,
					shapeCellY + (self.shapesSize - 5),
					self.shapesSize,
					5,
					Game.Color.darkGray
				);
			elseif (shape.t == 3) then
				newShape = Game.Triangle:new(
					shapeCellX,
					shapeCellY,
					self.shapesSize,
					Game.Color.darkGray
				);
			end
			
			table.insert(self.editedMapShapes, newShape);
		end
	end
	
	local originLineX = self.grid:getCoordsFromCell(self.originCellX, 1);
	self.originLine = Game.Rectangle:new(originLineX, self.gridOffset.y, 2, self.grid:getH(), Game.Color.red);
	self.grabOffsetX = 0;
	
	self.camera = Game.Camera:new(
		wWidth / 2,
		wHeight / 2,
		wWidth,
		wHeight,
		Game.Color.transparent
	);
	self.camera:setScale(.7);
	
	self.oldMouseX = love.mouse.getX();
	self.oldMouseY = love.mouse.getY();
	self.oldMouseX, self.oldMouseY = self.camera:getCameraCoords(self.oldMouseX, self.oldMouseY);
	
	Game.EventManager:subscribe('onGridCellClick', self.onGridCellClick);
	Game.EventManager:subscribe('onSaveMapData', self.onSaveMapData);
	Game.EventManager:subscribe('onShapeClick', self.onShapeClick);
end

function Game.EditorState:cleanUp()
	self.followMouse = nil;
	self.fastMovement = nil;
	self.headerHeight = nil;
	self.rightBarWidth = nil;
	self.camera = nil;
	self.oldMouseX = nil;
	self.oldMouseY = nil;
	self.selectionSquare:cleanUp();
	self.selectionSquare = nil;
	self.grid:cleanUp();
	self.grid = nil;
	self.levelsDirectory = nil;
	self.saveLevelsDirectory = nil;
	self.levelName = nil;
	self.editedMap = nil;
	self.originCellX = nil;
	for _, mapSquare in ipairs(self.editedMapShapes) do
		mapSquare:cleanUp();
		mapSquare = nil;
	end
	self.editedMapShapes = nil;
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
			if (math.abs(self.grabOffsetX) >= self.shapesSize) then
				self:updateCellsOriginX(newMouseX, newMouseY);
				self.grabOffsetX = 0;
			end
		end
		
		if (self.grid:isInside(newMouseX, newMouseY)) then
			local selectedCellX, selectedCellY = self.grid:getCellFromCoords(newMouseX, newMouseY);
			self.selectionSquare:setPosition(self.grid:getCoordsFromCell(selectedCellX, selectedCellY));
		end
		
		self.oldMouseX = newMouseX;
		self.oldMouseY = newMouseY;
	end
end

function Game.EditorState:draw()
	love.graphics.setBackgroundColor(Game.Color.whiteSmoke);
	
	self.camera:push();
	
	for _, mapShape in ipairs(self.editedMapShapes) do
		if (self.grid:isInside(mapShape:getX() + 1, mapShape:getY() + 1)) then
			mapShape:draw();
		end
	end
	self.selectionSquare:draw();
	self.grid:draw();
	
	if (self.grid:isInside(self.originLine:getX() + 1, self.originLine:getY() + 1)) then
		self.originLine:draw();
	end
	
	self.camera:pop();
	
	self.header:draw();
	self.rightBar:draw();
	
	for _, shape in pairs(self.shapes) do
		shape:draw();
	end
	
	love.graphics.setColor(Game.Color.whiteSmoke);
	love.graphics.setFont(Game.Font.large);
	love.graphics.print('[m] - Follow mouse', 10, 10);
	love.graphics.print('[s] - Save the map', 10, 30);
	love.graphics.print('[Shift + action] - Fast movement', 320, 10);
	love.graphics.print('[Echap] - Close editor', 320, 30);
	love.graphics.print('[Wheel up/down] - Zoom in/out', 640, 10);
	love.graphics.print('[Left click] - Add/remove object', 640, 30);
	love.graphics.print('[Right click] - Grab the scene', 640, 50);
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
		
	elseif (button == 'r') then
		self.grabbed = true;
	elseif (button == 'wu') then
		self.camera:setScale(self.camera:getScale() + (self.fastMovement and .3 or .05));
	elseif (button == 'wd') then
		self.camera:setScale(self.camera:getScale() - (self.fastMovement and .3 or .05));
	end
end

function Game.EditorState:mousereleased(x, y, button)
	if (button == 'l') then
		local cameraX, cameraY = self.camera:getCameraCoords(x, y);
		
		if (self.grid:isInside(cameraX, cameraY)) then
			Game.EventManager:trigger('onGridCellClick', self, {x = cameraX, y = cameraY});
			-- print(self.grid:getCellFromCoords(self.camera:getCameraCoords(x, y)));	
		else
			for shapeName, shape in pairs(self.shapes) do
				if (shape:isInside(x, y)) then
					Game.EventManager:trigger('onShapeClick', self, shapeName);
				end
			end
		end
	elseif (button == 'r') then
		self.grabbed = false;
	end
end

function Game.EditorState:updateCellsOriginX(newMouseX, newMouseY)
	local offset = (self.fastMovement and self.shapesSize * 3 or self.shapesSize);
	
	if (newMouseX < self.oldMouseX) then
		offset = -offset;
	end
	
	for _, mapShape in ipairs(self.editedMapShapes) do
		mapShape:moveX(offset);
	end
	
	self.originLine:moveX(offset);
	self.originCellX = self.originCellX + offset / self.shapesSize;
end

function Game.EditorState:updateSelectedShape(shape)
	self.shapes[self.selectedShape]:setColor(Game.Color.whiteSmoke);
	self.selectedShape = shape;
	self.shapes[self.selectedShape]:setColor(Game.Color.slateGray);
end

function Game.EditorState.onGridCellClick(self, event)
	local gridCellX, gridCellY = self.grid:getCellFromCoords(event.x, event.y);
	gridCellX = gridCellX - self.originCellX;
	local shapeCellX, shapeCellY = self.grid:getCoordsFromCell(self.originCellX + gridCellX, gridCellY);
	local shapeIndex = 0;
	local isAlreadyShape = false;
	local shapeType = 0;
	
	if (self.selectedShape == 'square') then
		shapeType = 1;
	elseif (self.selectedShape == 'ground') then
		shapeType = 2;
	elseif (self.selectedShape == 'triangle') then
		shapeType = 3;
	end
	
	for index, shape in ipairs(self.editedMap) do
		if (shape.x == gridCellX and shape.y == gridCellY) then
			isAlreadyShape = true;
			shapeIndex = index;
		end
	end
	
	if (isAlreadyShape) then
		table.remove(self.editedMap, shapeIndex);
		self.editedMapShapes[shapeIndex]:cleanUp();
		table.remove(self.editedMapShapes, shapeIndex);
	else
		-- Map data
		table.insert(self.editedMap, {t = shapeType, x = gridCellX, y = gridCellY});
		
		-- Display data
		local newShape = {};
		
		if (shapeType == 1) then
			newShape = Game.Rectangle:new(
				shapeCellX,
				shapeCellY,
				self.shapesSize,
				self.shapesSize,
				Game.Color.darkGray
			);
		elseif (shapeType == 2) then
			newShape = Game.Rectangle:new(
				shapeCellX,
				shapeCellY + (self.shapesSize - 5),
				self.shapesSize,
				5,
				Game.Color.darkGray
			);
		elseif (shapeType == 3) then
			newShape = Game.Triangle:new(
				shapeCellX,
				shapeCellY,
				self.shapesSize,
				Game.Color.darkGray
			);
		end
		
		table.insert(self.editedMapShapes, newShape);
	end
end

function Game.EditorState.onSaveMapData(self, event)
	Game.Debug:print('Map saved to : ' .. self.saveLevelsDirectory .. self.levelName);
	love.filesystem.write(self.saveLevelsDirectory .. self.levelName, Game.Serialize(self.editedMap));
end

function Game.EditorState.onShapeClick(self, shape)
	self:updateSelectedShape(shape);
end
