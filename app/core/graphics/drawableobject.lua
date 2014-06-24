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

function Game.DrawableObject:getX()
	return self.position.x;
end

function Game.DrawableObject:getY()
	return self.position.y;
end

function Game.DrawableObject:getW()
	return self.size.w;
end

function Game.DrawableObject:getH()
	return self.size.h;
end

function Game.DrawableObject:getScaleW()
	return self.scale.w;
end

function Game.DrawableObject:getScaleH()
	return self.scale.h;
end

function Game.DrawableObject:getAngle()
	return self.angle;
end

function Game.DrawableObject:getColor()
	return self.color;
end

function Game.DrawableObject:getPosition()
	return self.position.x, self.position.y;
end

function Game.DrawableObject:getSize()
	return self.size.w, self.size.h;
end

function Game.DrawableObject:getScale()
	return self.scale.w, self.scale.h;
end


function Game.DrawableObject:setX(x)
	self.position.x = x;
end

function Game.DrawableObject:setY(y)
	self.position.y = y;
end

function Game.DrawableObject:setW(w)
	self.size.w = w;
end

function Game.DrawableObject:setH(h)
	self.size.h = h;
end

function Game.DrawableObject:setScaleW(w)
	self.scale.w = w and (w > 0 and w or 0) or 1;
end

function Game.DrawableObject:setScaleH(h)
	self.scale.h = h and (h > 0 and h or 0) or 1;
end

function Game.DrawableObject:setAngle(angle)
	self.angle = angle;
end

function Game.DrawableObject:setColor(color)
	self.color = color;
end

function Game.DrawableObject:setPosition(x, y)
	self.position.x = x;
	self.position.y = y;
end

function Game.DrawableObject:setSize(w, h)
	self.size.w = w;
	self.size.h = h;
end

function Game.DrawableObject:setScale(w, h)
	self.scale.w = w and (w > 0 and w or 0) or 1;
	self.scale.h = h and (h > 0 and h or 0) or self.scale.w;
end

function Game.DrawableObject:draw() end
