-- UIObject class.
-- Represents a UI element.

Game.UIObject = Game.DrawableObject:extends({
	__name = 'UIObject',
	text = 'Undefined UIObject',
	font = Game.Font.normal,
	backgroundColor = Game.Color.black,
});

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
