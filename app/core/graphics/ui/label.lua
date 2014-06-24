-- Label class.
-- Represents a text.

Game.Label = Game.UIObject:extends({
	__name = 'Label',
	text = 'Undefined label',
});

function Game.Label:__init(text, x, y, color, font)
	self:setText(text);
	self:setPosition(x, y);
	self:setColor(color);
	self:setFont(font);
end

function Game.Label:setText(text)
	Game.Label.super.setText(self, text);
	self:setSize(self:getTextWidth(), self:getTextHeight());
end

function Game.Label:draw()
	love.graphics.setFont(self.font);
	love.graphics.setColor(self.backgroundColor);
	love.graphics.rectangle('fill', self:getX(), self:getY(), self:getTextWidth(), self:getTextHeight());
	love.graphics.setColor(self.color);
	love.graphics.print(self.text, self:getX(), self:getY());
end
