require("typing")

function love.load()
    font = love.graphics.getFont()
    inputs = { 
        typing:create(200,200,200,font:getHeight("W")+1),
        --typing:create(200,220,200,font:getHeight("W")+1)
    }
end

function love.update()
	
end

function love.draw()
    for i = 1, #inputs do
        inputs[i]:draw()
    end
end

function love.textinput(t)

end

function love.mousepressed()
    for i = 1, #inputs do
        inputs[i]:mouseDown()
    end
end

function love.mousereleased()
    for i = 1, #inputs do
        inputs[i]:mouseUp()
    end
end

function love.keypressed(key)

end

function love.keyreleased(key)

end
