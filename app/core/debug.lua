-- Debug class.

Game.Debug = Game.Class({
	__name = 'Debug',
	maxDepth = 5,
});

function Game.Debug:__init() end

function Game.Debug:print(data, level, key)
	local dataType = type(data);
	local offset = '';
	level = level or 0;
	
	if (level <= self.maxDepth) then
		
		for index = 1, level do
			offset = offset .. '    ';
		end
		
		level = level + 1;
		
		if (dataType ~= 'table') then
			if (dataType == 'string') then
				print(offset .. (key and '\'' .. key .. '\' ' or '') .. dataType .. '(' .. string.len(data) .. ')' .. ' - \'' .. data .. '\'');
			else
				print(offset .. (key and '\'' .. key .. '\' ' or '') .. dataType .. ' - ' .. tostring(data));
			end
		else
			print(offset .. dataType .. ' - [');
			if (key) then
				print(offset .. (type(key) == 'string' and '\'' .. key .. '\'' or key) .. ' (' .. table.getn(data) .. ')');
			end
			
			for key, value in pairs(data) do
				self:print(value, level, key);
			end
			
			print(offset .. ']');
		end
	end
end