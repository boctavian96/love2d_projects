GameOverScreen = {}
GameOverScreen.__index = GameOverScreen

function GameOverScreen:new(score)
    local gameoverscreen = {}
    setmetatable(gameoverscreen, GameOverScreen)
    gameoverscreen.score = score
    gameoverscreen.restartButton = UiButton:new('Restart', {0.8, 0.8, 0.8}, 80, 50, 300, 400, function() restart() end)

    return gameoverscreen
end

function GameOverScreen:update(dt)
    self.restartButton:update(dt)
end

function GameOverScreen:draw()
    love.graphics.setColor(COLOR_WHITE)
    love.graphics.print('Game Over...', 300, 100)
    love.graphics.print('Score: ' .. self.score, 300, 150)

    self.restartButton:draw()
end