-- Movable mixin.
-- Allows GameObjects to be moved.

Game.Movable = {
	moveX = function(self, dx)
		self.position.x = self.position.x + dx;
	end,

	moveY = function(self, dy)
		self.position.y = self.position.y + dy;
	end,
	
	move = function(self, dx, dy)
		self.position.x = self.position.x + dx;
		self.position.y = self.position.y + dy;
	end
};
