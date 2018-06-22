require "entities.scenary"
require "entities.player"

local godyray_code = [[
	extern number exposure;
    extern number decay;
    extern number density;
    extern number weight;
    extern vec2 light_position;
	extern number samples;
	
    vec4 effect(vec4 color, Image tex, vec2 uv, vec2 px) {
		color = Texel(tex, uv);
   		vec2 offset = (uv - light_position) * density / samples;
    	number illumination = decay;
		vec4 c = vec4(.5, .0, .2, 1.0);
	  
    	for (int i = 0; i < int(samples); ++i) {
        	uv -= offset;
        	c += Texel(tex, uv) * illumination * weight;
			illumination *= decay;
		}
	return vec4(c.rgb * exposure + color.rgb, color.a);
	}
]]


function love.load()
	godsray = love.graphics.newShader(godyray_code)
	p = player:create(50,50,25,50, .3,.3,.3)
	s1 = scenary:create(500,400)
	s2 = scenary:create(300,500)
end

function love.update(dt)
	p:physics(dt)
	p:update(dt)
	s1:update(dt)
	s2:update(dt)
end

function love.draw()
	love.graphics.setColor(.6, .3, .1, 1)
	love.graphics.rectangle("fill", 0,0,love.graphics.getWidth(), love.graphics.getHeight())
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setShader(godsray)
	p:draw()
	godsray:send("exposure",0.25)
	godsray:send("decay",0.95)
	godsray:send("density",0.15)
	godsray:send("weight",0.5)
	godsray:send("light_position", p:get_xy())
	godsray:send("samples", 70)
	p:draw_rays(s1)
	p:draw_rays(s2)
	s1:draw()
	s2:draw()
	love.graphics.setShader()
	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), love.graphics.getWidth()-55, 0)
end

function love.mousepressed(x,y, key)
	if key == 1 then
		print("--------")
		print("x = "..x)
		print("y = "..y)
	end
end