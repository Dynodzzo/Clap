-- DrawableObject class.
-- Represents a drawable game entity.

Game.DrawableObject = Game.GameObject:extends({
	__name = 'DrawableObject',
	position = {x = 0, y = 0},
	size = {w = 0, h = 0},
	scale = {w = 1, h = 1},
	angle = 0,
	color = Game.Color.white,
});

function Game.GameObject:getX()
	return self.position.x;
end

function Game.GameObject:getY()
	return self.position.y;
end

function Game.GameObject:getW()
	return self.size.w;
end

function Game.GameObject:getH()
	return self.size.h;
end

function Game.GameObject:getScaleW()
	return self.scale.w;
end

function Game.GameObject:getScaleH()
	return self.scale.h;
end

function Game.GameObject:getAngle()
	return self.angle;
end

function Game.GameObject:getColor()
	return self.color;
end

function Game.GameObject:getPosition()
	return self.position.x, self.position.y;
end

function Game.GameObject:getSize()
	return self.size.w, self.size.h;
end

function Game.GameObject:getScale()
	return self.scale.w, self.scale.h;
end


function Game.GameObject:setX(x)
	self.position.x = x;
end

function Game.GameObject:setY(y)
	self.position.y = y;
end

function Game.GameObject:setW(w)
	self.size.w = w;
end

function Game.GameObject:setH(h)
	self.size.h = h;
end

function Game.GameObject:setScaleW(w)
	self.scale.w = w;
end

function Game.GameObject:setScaleH(h)
	self.scale.h = h;
end

function Game.GameObject:setAngle(angle)
	self.angle = angle;
end

function Game.GameObject:setColor(color)
	self.color = color;
end

function Game.GameObject:setPosition(x, y)
	self.position.x = x;
	self.position.y = y;
end

function Game.GameObject:setSize(w, h)
	self.size.w = w;
	self.size.h = h;
end

function Game.GameObject:setScale(w, h)
	self.scale.w = w;
	self.scale.h = h;
end
