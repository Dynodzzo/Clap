-- Clickable mixin.
-- Allows GameObjects to be clickable.

Game.Clickable = {
	isInside = function(self, x, y)
		return (
			self.position.x < x and
			self.position.x + self.size.w > x and
			self.position.y < y and
			self.position.y + self.size.h > y
		) and true or false;
	end,
};
