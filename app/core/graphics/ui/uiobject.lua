-- UIObject class.
-- Represents a UI element.

Game.UIObject = Game.DrawableObject:extends({
	__name = 'UIObject',
	text = 'Undefined UIObject',
	borderSize = 1,
	font = Game.Font.normal,
	backgroundColor = Game.Color.none,
	borderColor = Game.Color.black,
	focused = false,
});

Game.UIObject:include(Game.Movable);
Game.UIObject:include(Game.Clickable);

function Game.UIObject:getText()
	return self.text;
end

function Game.UIObject:setText(text)
	self.text = text or self.text;
end

function Game.UIObject:getFont()
	return self.font;
end

function Game.UIObject:setFont(font)
	self.font = font or self.font;
end

function Game.UIObject:getTextWidth()
	return self.font:getWidth(self.text);
end

function Game.UIObject:getTextHeight()
	return self.font:getHeight();
end

function Game.UIObject:update(dt)
	
end

function Game.UIObject:draw()
	
end

function Game.UIObject:keypressed(key, isrepeat)
	
end

function Game.UIObject:keyreleased(key)
	
end

function Game.UIObject:mousepressed(x, y, button)
	
end

function Game.UIObject:mousereleased(x, y, button)
	
end

function Game.UIObject:textinput(text)
	
end
