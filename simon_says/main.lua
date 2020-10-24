require 'button'

--Game state 1 - play; 2 - Computer shows; 3 - Lose
STATE = 1

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
    

    button_colors = createColors()
    buttons = createButtons(button_colors, sounds)
    moves = {}
    round_status = false
    runned = false
    score = 0

    math.randomseed(os.time())

    moves = {}

    table.insert(moves, createNewMove())
    table.insert(moves, createNewMove())
    table.insert(moves, createNewMove())

    playerActions = {}

end

function love.update(dt)
    Timer.update(dt)

    if(STATE == 1 or STATE == 3) then

        for k, v in ipairs(buttons) do 
            v:update()
        end

        if(round_status) then 
            table.insert(moves, createNewMove())
        end

        if(STATE == 3) then 
            play(moves, buttons)
        end
    end

    if(STATE == 2) then 
        if(not runned) then
            playRound(moves, buttons)
            runned = true
        end
    end

    oldMouseDown = love.mouse.isDown(1)
end

function love.draw()
    for k, v in ipairs(buttons) do
        v:draw()
    end

    love.graphics.setColor(COLOR_WHITE)
    love.graphics.print("Score: " .. score, SCREEN_SIZE.WIDTH / 2.5, 50)

    if(STATE == 3) then 
        --TODO: Show number of rounds.
        --TODO: Press R to restart.
    end

    --DEBUG
    love.graphics.print("State: " .. STATE, 100, 100)
    --love.graphics.print("Actions: " .. playerActions[], 100, 200)
    for i=1, #playerActions do 
        love.graphics.print(playerActions[i], 100, 100 + i*10)
    end

    if(#playerActions == 3) then
        if(areTablesEqual(playerActions, moves) and (#playerActions == #moves)) then 
            love.graphics.print("Success", 200, 200)
        else
            love.graphics.print("Mistake", 200, 200)
        end
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
        STATE = 2
        runned = false
    end
end

function createColors()
    local colors={}

    table.insert(colors, COLOR_RED)
    table.insert(colors, COLOR_YELLOW)
    table.insert(colors, COLOR_GREEN)
    table.insert(colors, COLOR_BLUE)

    return colors
end

function createButtons(colors, sounds)
    local buttons={}
    local button_size = 60

    local coordinates = {
--[[    {x = 100, y = 100},
        {x = 180, y = 100},
        {x = 100, y = 180},
        {x = 180, y = 180}
        ]]

        {x = SCREEN_SIZE.WIDTH / 2.5, y = SCREEN_SIZE.HEIGHT/3},
        {x = SCREEN_SIZE.WIDTH / 2.5 + 1.1*SCREEN_SIZE.WORLD_UNITS, y = SCREEN_SIZE.HEIGHT/3},
        {x = SCREEN_SIZE.WIDTH / 2.5, y = SCREEN_SIZE.HEIGHT/4},
        {x = SCREEN_SIZE.WIDTH / 2.5 + 1.1*SCREEN_SIZE.WORLD_UNITS, y = SCREEN_SIZE.HEIGHT/4}
    }

    for i=1, #colors do
        table.insert(buttons, Button:new(colors[i], coordinates[i].x, coordinates[i].y, button_size, sounds[i]))
    end

    return buttons
end

function createNewMove()
    return math.random(1, 4)
end

function playRound(moves, buttons)
    --Jocul apasa butoanele. 
    pushTheButtons(moves, buttons)

    --Jucatorul repeta string-ul
    --play(moves, buttons)
end

function pushTheButtons(moves, buttons)
   
    local waitTime = 1

    --Timer.after(waitTime * #moves, function() STATE=1 end)    

    Timer.script(function(wait)
        for i=1, #moves do 
            buttons[moves[i]]:click()
            wait(0.2)
            buttons[moves[i]]:refresh()
            wait(waitTime)
        end
        STATE = 3
    end
    )


end

function play(moves, buttons)
    local mouse_x, mouse_y = love.mouse.getPosition()

    for k, v in ipairs(buttons) do 
        if (v:isHovered(mouse_x, mouse_y) and v:isClicked()) then 
            table.insert(playerActions, k)

            for i=1, #playerActions do 
                if(playerActions[i] ~= moves[i]) then 
                    --Player made a mistake :(
                end
            end

            if (areTablesEqual(moves, playerActions)) then 
                STATE = 1
                love.graphics.print("Success", 100, 200)
            end
        end
    end
end