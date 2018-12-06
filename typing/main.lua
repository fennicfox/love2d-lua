require("typing")

function love.load()
    font = love.graphics.getFont()
    inputs = { 
        typing:create(200, 200, 200, font:getHeight("W")+1),
        typing:create(200, 250, 200, (font:getHeight("W")+1))
    }
end

function love.update(dt)
    mouse()
    for i = 1, #inputs do
        inputs[i]:update(dt)
    end
end

function love.draw()
    for i = 1, #inputs do
        inputs[i]:draw()
    end
    love.graphics.print("Name:", 200, 180)
    love.graphics.print("Phone number:", 200, 230)
    mouse_reset()
end

function love.keypressed(key)
    for i = 1, #inputs do
        inputs[i]:keyPressed(key)
    end
end

function love.keyreleased(key)
    for i = 1, #inputs do
        inputs[i]:keyReleased(key)
    end
end
