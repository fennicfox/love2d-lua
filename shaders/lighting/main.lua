require "entities.scenary"
require "entities.player"

local shader_code = [[

]]


function love.load()
	--shader1 = love.graphics.newShader(shader_code)
	p = player:create(50,50)
	s = scenary:create(500,400)
end

function love.update(dt)
	p:physics(dt)
	p:update(dt)
	s:update(dt)
end

function love.draw()
	p:draw()
	p:draw_rays(s)
	s:draw()
	--love.graphics.setShader(shader1)
	--love.graphics.setShader()
end
