GamePlayScreen={}
GamePlayScreen.__index = GamePlayScreen

function GamePlayScreen:new()
    local gameplayscreen = {}
    setmetatable(gameplayscreen, GamePlayScreen)
    gameplayscreen.simonButtons = createButtons(createColors(), sounds)
    gameplayscreen.moves = createMoves(3)
    gameplayscreen.score = 0
    gameplayscreen.localstate = 1

    return gameplayscreen
end

function GamePlayScreen:update(dt)
        if(self.localstate == 1 or self.localstate == 3) then

        for k, v in ipairs(self.simonButtons) do 
            v:update()
        end

        if(round_status) then 
            table.insert(self.moves, createNewMove())
        end

        if(self.localstate == 3) then 
            play(self.moves, self.simonButtons)
        end
    end

    if(self.localstate == 2) then 
        if(not runned) then
            playRound(self.moves, self.simonButtons)
            runned = true
        end
    end

end

function GamePlayScreen:draw()
    for k, v in ipairs(self.simonButtons) do
        v:draw()
    end

    love.graphics.setColor(COLOR_WHITE)
    love.graphics.print("Score: " .. self.score, SCREEN_SIZE.WIDTH / 2.5, 50)

    --DEBUG
    if(DEBUG_MODE) then
        love.graphics.print("State: " .. STATE, 100, 100)
        --love.graphics.print("Actions: " .. playerActions[], 100, 200)
        for i=1, #playerActions do 
            love.graphics.print(playerActions[i], 100, 100 + i*10)
        end

        if(#playerActions == 3) then
            if(areTablesEqual(playerActions, self.moves) and (#playerActions == #self.moves)) then 
                love.graphics.print("Success", 200, 200)
            else
                love.graphics.print("Mistake", 200, 200)
            end
        end
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

function createMoves(numberOfMoves)
    local moves = {}
    for i=1, numberOfMoves do
        table.insert(moves, createNewMove())
    end

    return moves
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
        game.localstate = 3
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
                    STATE = 2
                end
            end

            if (areTablesEqual(moves, playerActions)) then 
                game.localstate = 1
                love.graphics.print("Success", 100, 200)
            end
        end
    end
end