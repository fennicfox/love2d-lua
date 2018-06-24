require "entities.scenary"
require "entities.player"
require "entities.light"

local light_code = love.graphics.newShader([[
	extern int radius;
	float r = 0.62;
	float g = 0.6;
	float b = 0.1;
	vec4 effect (vec4 color, Image image, vec2 uvs, vec2 screen_coords){
		float distance = pow( (pow((screen_coords.x - radius),2) + pow((screen_coords.y - radius),2)),0.5);
		float scale = .9 + ((distance - 0) / (radius - 0)) * (0 - .9);
		return vec4(r,g,b, scale);
	}
]])


function love.load()
	p = player:create(50,50,25,50, .3,.3,.3)
	s1 = scenary:create(500,400)
	s2 = scenary:create(300,500)
	image_size = 400
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
	love.graphics.scale(1.32,2)
	love.graphics.draw(background)
	love.graphics.pop()
	love.graphics.setShader(light_code)
	light_code:send("radius",100)
	p:draw()
	love.graphics.setShader()
	love.graphics.setColor(1, 1, 1, 1)
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