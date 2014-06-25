-- Rectangle object.

Game.Rectangle = Game.DrawableObject:extends({
	__name = 'Rectangle',
});

Game.Rectangle:include(Game.Movable);
Game.Rectangle:include(Game.Clickable);

function Game.Rectangle:__init(x, y, w, h, color)
	self:setPosition(x, y);
	self:setSize(w, h);
	self:setColor(color);
end

function Game.Rectangle:cleanUp()
	Game.Rectangle.super.cleanUp(self);
end

function Game.Rectangle:draw()
	if (self.visible) then
		love.graphics.setColor(self.color);
		love.graphics.setLineWidth(self.thickness);
		love.graphics.rectangle('fill', self:getX(), self:getY(), self:getW(), self:getH());
	end
end
