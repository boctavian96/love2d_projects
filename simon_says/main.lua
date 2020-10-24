--Screens

require 'ui.ui_button'
require 'screen.mainmenu_screen'
require 'screen.gameplay_screen'
require 'screen.gameover_screen'
require 'button'

DEBUG_MODE = false

--Game state 
-- 0 - mainmenu
-- 1 - play
-- 2 - lose
STATE = 0

--Buttons color (r, g, b, a)
COLOR_RED = {0.8, 0, 0, 1}
COLOR_YELLOW = {0.8, 0.8, 0, 1}
COLOR_GREEN = {0, 0.8, 0, 1}
COLOR_BLUE = {0, 0, 0.8, 1}
COLOR_WHITE = {1, 1, 1, 1}
COLOR_BLACK = {0, 0, 0, 1}

SCREEN_SIZE = {WIDTH = love.graphics.getWidth(), HEIGHT = love.graphics.getHeight(), WORLD_UNITS = 60}

--Game sounds
sounds = {}

table.insert(sounds, love.audio.newSource('sounds/1.wav', 'static'))
table.insert(sounds, love.audio.newSource('sounds/2.wav', 'static'))
table.insert(sounds, love.audio.newSource('sounds/3.wav', 'static'))
table.insert(sounds, love.audio.newSource('sounds/4.wav', 'static'))

Timer = require "library.hump.timer"
Utils = require "util"

function love.load()
    oldMouseDown = nil

    math.randomseed(os.time())

    mainmenu = MainMenuScreen:new()
    game = GamePlayScreen:new()
    gameover = nil

end

function love.update(dt)
    Timer.update(dt)

    if(STATE == 0) then 
        mainmenu:update(dt)
    end

    if(STATE == 1) then 
        game:update(dt)
    end

    if(STATE == 2) then 
        gameover:update(dt)
    end
 
    oldMouseDown = love.mouse.isDown(1)
end

function love.draw()
    if(STATE == 0) then 
        mainmenu:draw()
    end

    if(STATE == 1) then
        game:draw()
    end

    if(STATE == 2) then 
        gameover:draw()
    end

end

function love.keypressed(key, scancode, isrepeat)
    if key == 'q' then 
        love.event.quit(0)
    end

    if key == 'r' then 
        restart()
    end

    if key == 's' then 
        if(STATE == 1) then 
            game.playerActions = {}
            game.localstate=2
            game.runned = false
        end
    end
end

function restart()
    if(STATE == 2) then 
        game = GamePlayScreen:new()
        gameover = nil
        STATE = 1
    end

end

