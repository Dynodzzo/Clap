-- TextBox class.
-- Represents a text input box.

Game.TextBox = Game.UIObject:extends({
	__name = 'TextBox',
	text = '',
	size = {w = 200, h = 24},
	textOffset = {x = 5, y = 5},
	backgroundColor = Game.Color.darkGray,
});

function Game.TextBox:__init(x, y)
	self:setPosition(x, y);
end

function Game.TextBox:draw()
	if (self.visible) then
		love.graphics.setFont(self.font);
		if (self.focused) then
			love.graphics.setColor(self.borderColor);
			love.graphics.rectangle(
				'fill',
				self:getX() - self.borderSize,
				self:getY() - self.borderSize,
				self:getW() + self.borderSize * 2,
				self:getH() + self.borderSize * 2
			);
		end
		love.graphics.setColor(self.backgroundColor);
		love.graphics.rectangle('fill', self:getX(), self:getY(), self:getW(), self:getH());
		love.graphics.setColor(self.color);
		love.graphics.print(self.text, self:getX() + self.textOffset.x, self:getY() + self.textOffset.y);
	end
end

function Game.TextBox:keypressed(key, isrepeat)
	if (self.focused) then
		if (key == 'backspace') then
			self:pop();
		end
	end
end

function Game.TextBox:mousepressed(x, y, button)
	if (button == 'l') then
		if (self:isInside(x, y)) then
			self.focused = true;
		else
			self.focused = false;
		end
	end
end

function Game.TextBox:textinput(text)
	if (self.focused) then
		self:push(text);
	end
end

function Game.TextBox:push(text)
	self.text = self.text .. text;
end

function Game.TextBox:pop()
	local textLength = string.len(self.text);
	self.text = string.sub(self.text, 1, textLength - 1);
end
