-- Frame class.
-- Represents a window.

Game.Frame = Game.UIObject:extends({
	__name = 'Frame',
	text = 'New Frame',
	size = {w = 200, h = 120},
	textOffset = {x = 5, y = 5},
	topBarHeight = 30,
	backgroundColor = Game.Color.darkGray,
	topBarColor = Game.Color.customDarkGray,
	grabbed= false,
	grabOffset = {x = 0, y = 0},
});

function Game.Frame:__init(text, x, y, w, h)
	self:setText(text);
	self:setPosition(x, y);
	self:setSize(w, h);
end

function Game.Frame:update(dt)
	if (self.grabbed) then
		local newFrameX, newFrameY = love.mouse.getPosition();
		newFrameX = newFrameX - self.grabOffset.x;
		newFrameY = newFrameY - self.grabOffset.y;
		
		self:setPosition(newFrameX, newFrameY);
	end
end

function Game.Frame:draw()
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
		love.graphics.setColor(self.topBarColor);
		love.graphics.rectangle('fill', self:getX(), self:getY(), self:getW(), self.topBarHeight);
		love.graphics.setColor(self.color);
		love.graphics.print(self.text, self:getX() + self.textOffset.x, self:getY() + self.textOffset.y);
	end
end

function Game.Frame:keypressed(key, isrepeat)	
	
end

function Game.Frame:mousepressed(x, y, button)
	if (button == 'l') then
		if (self:isInside(x, y)) then
			self.focused = true;
		else
			self.focused = false;
		end
		
		if (self:isInsideTopbar(x, y)) then
			self.grabbed = true;
			self.grabOffset.x = x - self:getX();
			self.grabOffset.y = y - self:getY();
		end
	end
end

function Game.Frame:mousereleased(x, y, button)
	if (button == 'l' and self.focused) then
		if (self:isInside(x, y)) then
			self.grabbed = false;
			self.grabOffset.x = 0;
			self.grabOffset.y = 0;
		end
	end
end

function Game.Frame:isInsideTopbar(x, y)
	return (
		self:getX() < x and
		self:getY() < y and
		self:getX() + self:getW() > x and
		self:getY() + self:getH() > y
	) and true or false;
end
