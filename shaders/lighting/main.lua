require "entities.scenary"
require "entities.player"
require "entities.light"

local light_code = love.graphics.newShader([[
	extern int radius;
	float r = 0.62;
	float g = 0.6;
	float b = 0.1;
	vec4 effect (vec4 color, Image image, vec2 uvs, vec2 screen_coords){
		return r,g,b,(.9 + (pow((pow((screen_coords[0] - radius),2) + pow((screen_coords[1] - radius),2)) - 0,0.5) / (radius - 0)) * (0 - .9));
	}
]])


function love.load()
	p = player:create(50,50,25,50, .3,.3,.3)
	s1 = scenary:create(500,400)
	s2 = scenary:create(300,500)
	image_size = 400
	image = radialGradient(image_size)
	--background = love.graphics.newImage('images/background_example.png')
	background = love.graphics.newImage('images/cover.png')
end

function love.update(dt)
	p:physics(dt)
	p:update(dt)
	s1:update(dt)
	s2:update(dt)
end

function love.draw()
	love.graphics.push()
	--love.graphics.scale(.6,.7)
	love.graphics.scale(1.32,2)
	love.graphics.draw(background)
	love.graphics.pop()
	--love.graphics.setColor(.6, .3, .1, 1)
	--love.graphics.rectangle("fill", 0,0,love.graphics.getWidth(), love.graphics.getHeight())
	p:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(image,p.centerx-image_size, p.centery-image_size )
	p:draw_rays(s1)
	p:draw_rays(s2)
	s1:draw()
	s2:draw()
	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), love.graphics.getWidth()-55, 0)
end

function love.mousepressed(x,y, key)
	if key == 1 then
		print("--------")
		print("x = "..x)
		print("y = "..y)
	end
end