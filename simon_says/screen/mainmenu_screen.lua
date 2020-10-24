MainMenuScreen={}
MainMenuScreen.__index = MainMenuScreen

function MainMenuScreen:new()
    local mainmenuScreen = {}
    mainmenuScreen.buttons = createMenuButtons()
    setmetatable(mainmenuScreen, MainMenuScreen)

    return mainmenuScreen
end

function MainMenuScreen:update(dt)
    for k, v in ipairs(self.buttons) do 
        v:update(dt)
    end
end

function MainMenuScreen:draw()
    self:drawTitle()

    for k, v in ipairs(self.buttons) do 
        v:draw()
    end
end

function MainMenuScreen:drawTitle()
    local oldFont = love.graphics.getFont()
    local newFont = love.graphics.newFont(40)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(newFont)
    love.graphics.print("Simon Says", SCREEN_SIZE.WIDTH/3, 10)
    love.graphics.setFont(oldFont)
end

function createMenuButtons()
    local buttons = {}
    local button_color = {0.8, 0.8, 0.8}
    local button_width = 100
    local button_height = 40

    function playAction()
        STATE = 1 -- Global
    end

    function exitAction() 
        love.event.quit(0)
    end

    table.insert(buttons, UiButton:new('Play', button_color, button_width, button_height, SCREEN_SIZE.WIDTH/2.5, 200, playAction)) -- Play
    table.insert(buttons, UiButton:new('Exit', button_color, button_width, button_height, SCREEN_SIZE.WIDTH/2.5, 260, exitAction)) -- Exit

    return buttons
end