-- Line object.

Game.Line = Game.DrawableObject:extends({
	__name = 'Line',
});

Game.Line:include(Game.Movable);
Game.Line:include(Game.Clickable);

function Game.Line:__init(x, y, w, h, thickness, color)
	self:setPosition(x, y);
	self:setSize(w, h);
	self:setThickness(thickness);
	self:setColor(color);
end

function Game.Line:cleanUp()
	Game.Line.super.cleanUp(self);
end

function Game.Line:draw()
	if (self.visible) then
		love.graphics.setColor(self.color);
		love.graphics.setLineWidth(self.thickness);
		love.graphics.line(self:getX(), self:getY(), self:getW(), self:getH());
	end
end
