-- Button class.
-- Represents a button.

Game.Button = Game.UIObject:extends({
	__name = 'Button',
	text = 'New button',
	size = {w = 60, h = 24},
	textOffset = {x = 5, y = 5},
	backgroundColor = Game.Color.darkGray,
	onClick = function() end,
});

function Game.Button:__init(text, x, y)
	self:setText(text);
	self:setPosition(x, y);
end

function Game.Button:draw()
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

function Game.Button:keypressed(key, isrepeat)	
	if (self.focused) then
		if (key == 'return') then
			self.onClick();
		end
	end
end

function Game.Button:mousepressed(x, y, button)
	if (button == 'l') then
		if (self:isInside(x, y)) then
			self.focused = true;
		else
			self.focused = false;
		end
	end
end

function Game.Button:mousereleased(x, y, button)
	if (button == 'l' and self.focused) then
		if (self:isInside(x, y)) then
			self.onClick();
		end
	end
end
