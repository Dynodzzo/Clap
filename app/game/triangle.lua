-- Triangle object (equilateral).

Game.Triangle = Game.DrawableObject:extends({
	__name = 'Triangle',
});

Game.Triangle:include(Game.Movable);
Game.Triangle:include(Game.Clickable);

function Game.Triangle:__init(x, y, size, color)
	self:setPosition(x, y);
	self:setSize(size, size);
	self:setColor(color);
end

function Game.Triangle:cleanUp()
	Game.Triangle.super.cleanUp(self);
end

function Game.Triangle:draw()
	if (self.visible) then
		love.graphics.setColor(self.color);
		love.graphics.setLineWidth(self.thickness);
		love.graphics.polygon(
			'fill',
			self:getX() + self:getW() / 2,
			self:getY(),
			self:getX() + self:getW(),
			self:getY() + self:getH(),
			self:getX(),
			self:getY() + self:getH()
		);
	end
end
