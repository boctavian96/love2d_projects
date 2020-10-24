UiButton = {}
UiButton.__index = UiButton

function UiButton:new(text, color, width, height, x, y, action)
    local uibutton = {}
    setmetatable(uibutton, UiButton)
    uibutton.text = text
    uibutton.originalColor = color
    uibutton.color = color
    uibutton.hoverColor = {color[1] + 0.2, color[2] + 0.2, color[3] + 0.2}
    uibutton.pushColor = {color[1] - 0.2, color[2] - 0.2, color[3] - 0.2}
    uibutton.width = width
    uibutton.height = height
    uibutton.x = x
    uibutton.y = y
    uibutton.action = action

    return uibutton
    
end

function UiButton:update(dt)
    local mouse_x, mouse_y = love.mouse.getPosition()

    if(self:isHovered(mouse_x, mouse_y)) then 
        self.color = self.hoverColor

        if(love.mouse.isDown(1) and not oldMouseDown) then 
            self.color = self.pushColor
            if(self.action ~= nil) then 
                self.action()
            end
        end
    else 
        self.color = self.originalColor
    end
end

function UiButton:draw()

    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(COLOR_BLACK) --Black for text
    love.graphics.print(self.text, self.x + self.width/3, self.y + self.height/3)

end

function UiButton:isHovered(mouse_x, mouse_y)
    return (mouse_x > self.x and mouse_x < self.x + self.width and mouse_y > self.y and mouse_y < self.y + self.height)
end