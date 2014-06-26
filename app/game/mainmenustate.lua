Game.MainMenuState = Game.GameState:extends({
	__name = 'MainMenuState',
});

function Game.MainMenuState:__init(gsm)
	Game.MainMenuState.super.__init(self, gsm);
end

function Game.MainMenuState:init()
	self.oldMouseX = love.mouse.getX();
	self.oldMouseY = love.mouse.getY();
	
	self.title = Game.Label:new('Levels :', 10, 10, Game.Color.darkRed, Game.Font.large);
	
	-- self.levelsDirectory = 'app/game/levels';
	self.levelsDirectory = 'levels/';
	self.levels = love.filesystem.getDirectoryItems(self.levelsDirectory);
	self.labels = {};
	self.labelsStartPosition = {x = 25, y = 40};
	self.labelsSpacing = 20;
	
	self:reload();
	
	self.newMapWindow = Game.MessageBox:new('Choose a name for the map', 120, 40, true);
	self.newMapWindow.validate = function(mapName)
		self:onNewMapWindowValidate(mapName)
	end;
	
	Game.EventManager:subscribe('onLevelLabelHover', self.onLevelLabelHover);
	Game.EventManager:subscribe('onLevelLabelStopHover', self.onLevelLabelStopHover);
	Game.EventManager:subscribe('onLevelLabelClick', self.onLevelLabelClick);
	Game.EventManager:subscribe('onNewMapWindowValidate', self.onNewMapWindowValidate);
end

function Game.MainMenuState:cleanUp()
	self.oldMouseX = nil;
	self.oldMouseY = nil;
	self.title:cleanUp();
	self.title = nil;
	self.levelsDirectory = nil;
	self.levels = nil;
	for _, levelLabel in ipairs(self.labels) do
		levelLabel:cleanUp()
		levelLabel = nil;
	end
	self.labels = nil;
	self.labelsStartPosition = nil;
	self.labelsSpacing = nil;
	Game.EventManager:unsubscribe('onLevelLabelHover', self.onLevelLabelHover);
	Game.EventManager:unsubscribe('onLevelLabelStopHover', self.onLevelLabelStopHover);
	Game.EventManager:unsubscribe('onLevelLabelClick', self.onLevelLabelClick);
end

function Game.MainMenuState:pause() end
function Game.MainMenuState:resume() end

function Game.MainMenuState:update(dt)
	local mouseX = love.mouse.getX();
	local mouseY = love.mouse.getY();
	
	if (mouseX ~= self.oldMouseX or mouseY ~= self.oldMouseY) then
		for _, label in ipairs(self.labels) do
			if (label:isInside(mouseX, mouseY)) then
				Game.EventManager:trigger('onLevelLabelHover', label);
			else
				Game.EventManager:trigger('onLevelLabelStopHover', label);
			end
		end
		
		self.oldMouseX = mouseX;
		self.oldMouseY = mouseY;
	end
end

function Game.MainMenuState:draw()
	love.graphics.setBackgroundColor(Game.Color.whiteSmoke);
	self.title:draw();
	
	for _, levelLabel in ipairs(self.labels) do
		levelLabel:draw();
	end
	
	self.newMapWindow:draw();
end

function Game.MainMenuState:keypressed(key, isrepeat)
	self.newMapWindow:keypressed(key, isrepeat);
end

function Game.MainMenuState:keyreleased(key)
	self.newMapWindow:keyreleased(x, y, button);
end
			
function Game.MainMenuState:mousepressed(x, y, button)
	self.newMapWindow:mousepressed(x, y, button);
end

function Game.MainMenuState:mousereleased(x, y, button)
	if (button == 'l') then
		for _, levelLabel in ipairs(self.labels) do
			if (levelLabel:isInside(x, y)) then
				Game.EventManager:trigger('onLevelLabelClick', levelLabel, self);
			end
		end
	end
	
	self.newMapWindow:mousereleased(x, y, button);
end

function Game.MainMenuState:textinput(text)
	self.newMapWindow:textinput(text);
end

function Game.MainMenuState:reload()
	self.labels = {};
	self.levels = love.filesystem.getDirectoryItems(self.levelsDirectory);
	
	table.insert(self.labels, Game.Label:new(
		'New map',
		self.labelsStartPosition.x,
		self.labelsStartPosition.y,
		Game.Color.customDarkGray
	));
	
	for index, levelName in ipairs(self.levels) do
		table.insert(self.labels, Game.Label:new(
			levelName,
			self.labelsStartPosition.x,
			self.labelsStartPosition.y + self.labelsSpacing * index,
			Game.Color.customDarkGray
		));
	end
end

function Game.MainMenuState.onLevelLabelHover(self, event)
	self.backgroundColor = Game.Color.darkGray;
end

function Game.MainMenuState.onLevelLabelStopHover(self, event)
	self.backgroundColor = Game.Color.none;
end

function Game.MainMenuState.onLevelLabelClick(self, currentState)
	if (self.text == 'New map') then
		currentState.newMapWindow:show();
	else
		currentState.game:pushState(Game.EditorState:new(currentState.game), self.text);
	end
end

function Game.MainMenuState:onNewMapWindowValidate(mapName)
	if (mapName ~= '') then
		self.newMapWindow:hide();
		print('Map created to : ' .. self.levelsDirectory .. mapName .. '.lev')
		local fileCreated = love.filesystem.write(self.levelsDirectory .. mapName .. '.lev', '');
		
		if (fileCreated) then
			self:reload();
		end
	end
end
