GamePlayScreen={}
GamePlayScreen.__index = GamePlayScreen

function GamePlayScreen:new()
    local gameplayscreen = {}
    setmetatable(gameplayscreen, GamePlayScreen)
    gameplayscreen.simonButtons = createButtons(createColors(), sounds)
    gameplayscreen.beginButton = UiButton:new('Begin', {0.8, 0.8, 0.8}, 100, 50, 420, 400, function() game.localstate = 2 end)
    gameplayscreen.moves = createMoves(3)
    gameplayscreen.score = 0
    gameplayscreen.round_status = false
    gameplayscreen.runned = false
    gameplayscreen.playerActions = {}
    --[[
        0 - Wait State
        1 - Screen.
        2 - Computer shows moves.
        3 - Play.
    ]]
    gameplayscreen.localstate = 1

    return gameplayscreen
end

function GamePlayScreen:update(dt)
        if(self.localstate == 1) then 
            self.beginButton:update(dt)
        end

        if(self.localstate == 0 or self.localstate == 1 or self.localstate == 3) then

        for k, v in ipairs(self.simonButtons) do 
            v:update(dt, self.localstate)
        end

        if(self.round_status) then 
            table.insert(self.moves, createNewMove())
        end

        if(self.localstate == 3) then 
            play(self.moves, self.simonButtons)
        end
    end

    if(self.localstate == 2) then 
        if(not self.runned) then
            pushTheButtons(self.moves, self.simonButtons)
            --playRound(self.moves, self.simonButtons)
            self.runned = true
        end
    end

end

function GamePlayScreen:draw()
    originalFont = love.graphics.getFont()
    scoreFont = love.graphics.newFont(25)

    if (self.localstate == 1) then 
        self.beginButton:draw()
    end

    for k, v in ipairs(self.simonButtons) do
        v:draw()
    end

    love.graphics.setColor(COLOR_WHITE)
    love.graphics.setFont(scoreFont)
    love.graphics.print("Score: " .. self.score, SCREEN_SIZE.WIDTH / 2.45, 50)
    love.graphics.setFont(originalFont)

    --DEBUG
    if(DEBUG_MODE) then
        love.graphics.print("State: " .. STATE, 100, 100)
        --love.graphics.print("Actions: " .. playerActions[], 100, 200)
        for i=1, #self.playerActions do 
            love.graphics.print(self.playerActions[i], 100, 100 + i*10)
        end

        if(#self.playerActions == 3) then
            if(areTablesEqual(self.playerActions, self.moves) and (#self.playerActions == #self.moves)) then 
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
    play(moves, buttons)
end

function pushTheButtons(moves, buttons)
   
    local waitTime = 1

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
        if (v:isHovered(mouse_x, mouse_y) and v:isClicked() and not oldMouseDown and (sizeOf(game.playerActions) ~= sizeOf(moves))) then 
            table.insert(game.playerActions, k)

            for i=1, #game.playerActions do 
                if(game.playerActions[i] ~= moves[i]) then 
                    gameover = GameOverScreen:new(game.score)
                    STATE = 2 -- GameOver
                end
            end

            if (areTablesEqual(moves, game.playerActions)) then 
                game.score = game.score + 100
                game.runned = false
                game.playerActions = {}
                table.insert(game.moves, createNewMove())
                game.localstate = 0 --Wait
                Timer.after(2, function() game.localstate = 2 end)
            end
        end
    end
end