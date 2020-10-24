--Screens

require 'ui.ui_button'
require 'screen.mainmenu_screen'
require 'screen.gameplay_screen'
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

    round_status = false
    runned = false
    oldMouseDown = nil

    math.randomseed(os.time())

    playerActions = {}

    mainmenu = MainMenuScreen:new()
    game = GamePlayScreen:new()

end

function love.update(dt)
    Timer.update(dt)

    if(STATE == 0) then 
        mainmenu:update(dt)
    end

    if(STATE == 1) then 
        game:update(dt)
    end

    oldMouseDown = love.mouse.isDown(1)
end

function love.draw()
    if(STATE==0) then 
        mainmenu:draw()
    end

    if(STATE==1) then
        game:draw()
    end

end

function love.keypressed(key, scancode, isrepeat)
    if key == 'q' then 
        love.event.quit(0)
    end

    if key == 'r' then 
        STATE = 1
    end

    if key == 's' then 
        if(STATE == 1) then 
            playerActions = {}
            game.localstate=2
            runned = false
        end
    end
end

