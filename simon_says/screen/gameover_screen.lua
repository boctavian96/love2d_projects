GameOverScreen = {}
GameOverScreen.__index = GameOverScreen

function GameOverScreen:new(score)
    local gameoverscreen = {}
    setmetatable(gameoverscreen, GameOverScreen)
    gameoverscreen.score = score

    return gameoverscreen
end

function GameOverScreen:update(dt)

end

function GameOverScreen:draw()
    love.graphics.print('Game Over...', 100, 100)
    love.graphics.print('Score: ' .. self.score, 100, 150)
end