Button = {} 
Button.__index = Button

function Button:new(color, x, y, size, sound)
    local button = {}
    setmetatable(button, Button)
    button.originalColor = color
    button.color = color
    button.hoverColor = {color[1] + 0.2, color[2] + 0.2, color[3] + 0.2, color[4]}
    button.pushColor = {color[1] - 0.2, color[2] - 0.2, color[3] - 0.2, color[4]}
    button.x = x
    button.y = y
    button.size = size
    button.sound = sound

    return button

end

function Button:update(dt, state)
    local mouse_x, mouse_y = love.mouse.getPosition()

    if(self:isHovered(mouse_x, mouse_y)) then 
        self.color = self.hoverColor
        if(self:isClicked() and state == 3) then 
            self:click()
        else
            self.color = self.hoverColor
        end
    else 
        self.color = self.originalColor
    end

end

function Button:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end

function Button:isHovered(mouse_x, mouse_y)
    return (mouse_x > self.x and mouse_x < self.x + self.size and mouse_y > self.y and mouse_y < self.y + self.size)      
end

function Button:isClicked()
    return (love.mouse.isDown(1) and not oldMouseDown)
end

function Button:click()
    self.color = self.pushColor
    if(self.sound ~= nil) then
        self.sound:stop()
        self.sound:play()
    end
end

function Button:refresh()
    self.color = self.originalColor
end