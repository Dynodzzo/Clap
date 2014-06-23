-- Grid object.

Game.Grid = Game.DrawableObject:extends({
	__name = 'Grid',
	length = 0,
	height = 0,
	cellsWidth = 0,
	cellsHeight = 0,
});

Game.Grid:include(Game.Movable);
Game.Grid:include(Game.Clickable);

function Game.Grid:getLength()
	return self.length;
end

function Game.Grid:getHeight()
	return self.height;
end

function Game.Grid:getCellsWidth()
	return self.cellsWidth;
end

function Game.Grid:getCellsHeight()
	return self.cellsHeight;
end


function Game.Grid:setLength(length)
	self.length = length;
end

function Game.Grid:setHeight(height)
	self.height = height;
end

function Game.Grid:setCellsWidth(cellsWidth)
	self.cellsWidth = cellsWidth;
end

function Game.Grid:setCellsHeight(cellsHeight)
	self.cellsHeight = cellsHeight;
end


function Game.Grid:setGridSize(length, height)
	self.length = length;
	self.height = height;
end

function Game.Grid:setCellsSize(cellsWidth, cellsHeight)
	self.cellsWidth = cellsWidth;
	self.cellsHeight = cellsHeight;
end


function Game.Grid:__init(x, y, w, h, length, height, color)
	self:setPosition(x, y);
	self:setSize(w, h);
	self:setCellsSize(w, h);
	self:setGridSize(length, height);
	self:setColor(color);
end

function Game.Grid:draw()
	love.graphics.setColor(self.color);
	
	for easting = 0, self.length do
		love.graphics.line(
			self:getX() + (self.cellsWidth * easting),
			self:getY(),
			self:getX() + (self.cellsWidth * easting),
			self:getY() + (self.cellsHeight * self.length)
		);
	end
	
	for northing = 0, self.height do
		love.graphics.line(
			self:getX(),
			self:getY() + (self.cellsHeight * northing),
			self:getX() + (self.cellsWidth * self.height),
			self:getY() + (self.cellsHeight * northing)
		);
	end
end
