-- Camera object.

Game.Camera = Game.DrawableObject:extends({
	__name = 'Camera',
});

Game.Camera:include(Game.Movable);

function Game.Camera:__init(x, y, w, h, color)
	self:setPosition(x or love.window.getWidth() / 2, y or love.window.getHeight() / 2);
	self:setSize(w or love.window.getWidth(), h or love.window.getHeight());
	self:setColor(color);
end

function Game.Camera:lookAt(x, y)
	self:setPosition(x, y);
end

function Game.Camera:rotate(angle)
	self.angle = self.angle + angle;
end

function Game.Camera:rotateTo(angle)
	self.angle = angle;
end

function Game.Camera:zoom(multiplier)
	self:setScaleW(self.scale.w + multiplier);
	self:setScaleH(self.scale.h + multiplier);
end

function Game.Camera:zoomTo(multiplier)
	self:setScale(multiplier);
end

function Game.Camera:push()
	local originX = love.window.getWidth() / (2 * self:getScaleW());
	local originY = love.window.getHeight() / (2 * self:getScaleH());
	
	love.graphics.push();
	love.graphics.scale(self:getScaleW(), self:getScaleH());
	love.graphics.translate(originX, originY);
	love.graphics.rotate(self:getAngle());
	love.graphics.translate(-self:getX(), -self:getY());
end

function Game.Camera:pop()
	love.graphics.pop();
end

function Game.Camera:getWindowCoords(mouseX, mouseY)
	local width = love.window.getWidth();
	local height = love.window.getHeight();
	local angleCos = math.cos(self.angle);
	local angleSin = math.sin(self.angle);
	
	-- Position
	mouseX = mouseX - self:getX();
	mouseY = mouseY - self:getY();
	-- Angle
	mouseX = mouseX * angleCos - mouseY * angleSin;
	mouseY = mouseX * angleSin + mouseY * angleCos;
	-- Scale
	return
		mouseX * self:getScaleW() + width / 2,
		mouseY * self:getScaleH() + height / 2;
end

function Game.Camera:getCameraCoords(mouseX, mouseY)
	local width = love.window.getWidth();
	local height = love.window.getHeight();
	local angleCos = math.cos(-self.angle);
	local angleSin = math.sin(-self.angle);
	
	-- Position
	mouseX = (mouseX - width / 2) / self:getScaleW();
	mouseY = (mouseY - height / 2) / self:getScaleH();
	-- Angle
	mouseX = mouseX * angleCos - mouseY * angleSin;
	mouseY = mouseX * angleSin + mouseY * angleCos;
	-- Scale
	return
		mouseX + self:getX(),
		mouseY + self:getY();
end

function Game.Camera:getMouseCoords()
	return self:getCameraCoords(love.mouse.getPosition());
end
