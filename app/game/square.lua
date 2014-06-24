-- Square object.

Game.Square = Game.DrawableObject:extends({
	__name = 'Square',
});

Game.Square:include(Game.Movable);
Game.Square:include(Game.Clickable);

function Game.Square:__init(x, y, w, h, color)
	self:setPosition(x, y);
	self:setSize(w, h);
	self:setColor(color);
end

function Game.Square:cleanUp()
	Game.Square.super.cleanUp(self);
end

function Game.Square:draw()
	love.graphics.setColor(self.color);
	love.graphics.rectangle('fill', self:getX(), self:getY(), self:getW(), self:getH());
end
