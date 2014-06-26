-- MessageBox class.
-- Represents a message box.

Game.MessageBox = Game.UIObject:extends({
	__name = 'MessageBox',
	text = 'Undefined MessageBox',
	size = {w = 300, h = 120},
	visible = false,
	hasTextInput = false,
	backgroundColor = Game.Color.gray,
	textOffset = {x = 10, y = 10},
	textInput = Game.TextBox:new(10, 30),
	validationButton = Game.Button:new('OK', 10, 60),
	cancelButton = Game.Button:new('Cancel', 80, 60),
	validate = function() end,
	cancel = function() end,
});

function Game.MessageBox:__init(text, x, y, hasTextInput)
	self:setText(text);
	self:setPosition(x, y);
	self:setSize(w, h);
	self.hasTextInput = hasTextInput;
	self.textInput:move(self:getX(), self:getY());
	self.validationButton:move(self:getX(), self:getY());
	self.cancelButton:move(self:getX(), self:getY());
	
	self.validationButton.onClick = function()
		self:onValidationClick();
	end;
	
	self.cancelButton.onClick = function()
		self:onCancelClick();
	end;
end

function Game.MessageBox:draw()
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
		
		if (self.hasTextInput) then
			self.textInput:draw();
		end
		
		self.validationButton:draw();
		self.cancelButton:draw();
	end
end

function Game.MessageBox:keypressed(key, isrepeat)
	if (self.hasTextInput and self.visible) then
		self.textInput:keypressed(key, isrepeat);
	end
	
	self.validationButton:keypressed(key, isrepeat);
	self.cancelButton:keypressed(key, isrepeat);
end

function Game.MessageBox:keyreleased(key)
	
end

function Game.MessageBox:mousepressed(x, y, button)
	if (self.visible) then
		if (button == 'l') then
			if (self:isInside(x, y)) then
				self.focused = true;
			else
				self.focused = false;
			end
		end
		
		self.validationButton:mousepressed(x, y, button);
		self.cancelButton:mousepressed(x, y, button);
		self.textInput:mousepressed(x, y, button);
	end
end

function Game.MessageBox:mousereleased(x, y, button)
	if (self.visible) then
		self.validationButton:mousereleased(x, y, button);
		self.cancelButton:mousereleased(x, y, button);
	end
end

function Game.MessageBox:textinput(text)
	if (self.hasTextInput and self.visible) then
		self.textInput:textinput(text);
	end
end

function Game.MessageBox:show()
	self.visible = true;
	self.focused = true;
end

function Game.MessageBox:hide()
	self.visible = false;
	self.focused = false;
end

function Game.MessageBox:clear()
	self.textInput:setText('');
	self.textInput.focused = false;
	self.validationButton.focused = false;
	self.cancelButton.focused = false;
end

function Game.MessageBox:onValidationClick()
	self.validate(self.textInput:getText());
end

function Game.MessageBox:onCancelClick()
	self:hide();
	self:clear();
	self.cancel();
end
