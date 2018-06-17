local shader_code = [[

]]


function love.load()
	shader1 = love.graphics.newShader(shader_code)
end

function love.update(dt)

end

function love.draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("fill", 0, 0, 1000, 1000)
--[[	love.graphics.setShader(shader1)
	love.graphics.setShader()--]]
end
