-- Initialization

-- OOP library by Roland Yonaba (https://github.com/Yonaba).
-- http://yonaba.github.io/30log/
Game.Class = require('lib.30log');

-- Serialization library by Robin Wellner (https://github.com/gvx).
-- https://github.com/gvx/Ser
Game.Serialize = require('lib.ser');

-- Loading classes
require('app.core.gamestatemanager');
require('app.core.gamestate');
require('app.core.debug');
require('app.core.eventmanager');

require('app.core.graphics.mixins.movable');
require('app.core.graphics.mixins.clickable');

require('app.core.graphics.color');
require('app.core.graphics.font');
require('app.core.graphics.gameobject');
require('app.core.graphics.drawableobject');
require('app.core.graphics.camera');

require('app.core.graphics.ui.uiobject');
require('app.core.graphics.ui.label');
require('app.core.graphics.ui.textbox');
require('app.core.graphics.ui.button');
require('app.core.graphics.ui.messagebox');


require('app.game.mainmenustate');
require('app.game.editorstate');
require('app.game.rectangle');
require('app.game.line');
require('app.game.grid');
