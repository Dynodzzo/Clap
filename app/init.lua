-- Initialization

-- OOP library by Roland Yonaba (https://github.com/Yonaba).
-- http://yonaba.github.io/30log/
Game.Class = require('lib.30log');

-- Loading classes
require('app.core.gamestatemanager');
require('app.core.gamestate');
require('app.core.debug');
require('app.core.eventmanager');
require('app.core.graphics.color');
require('app.core.graphics.font');
require('app.core.graphics.gameobject');
require('app.core.graphics.drawableobject');

require('app.core.graphics.mixins.movable');
require('app.core.graphics.mixins.clickable');

require('app.game.ingamestate');
require('app.game.square');
require('app.game.grid');
