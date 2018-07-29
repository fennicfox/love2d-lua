local moonshine = require 'more_shaders.moonshine'
--black and white
local shader1 = love.graphics.newShader [[
extern vec2 screen;
vec4 effect (vec4 color, Image image, vec2 uvs, vec2 screen_coords){
	vec4 pixel = Texel(image, uvs);
	vec2 sc = vec2(screen_coords.x / screen.x, screen_coords.y / screen.y);
	return vec4 (sc.xy, color[0], 1);
}

]]

--darkness
local shader2 = love.graphics.newShader [[
extern int darkness;
vec4 effect (vec4 color, Image image, vec2 uvs, vec2 screen_coords){
	return vec4(color[0]/darkness, color[1]/darkness, color[2]/darkness, 1);
}

]]

--colour gradients
local shader3 = love.graphics.newShader [[
vec4 effect (vec4 color, Image image, vec2 uvs, vec2 screen_coords){
	float av = (color[0], color[1], color[2]) / 3;
	return vec4(av, av, av, color[3]);
}

]]

--film grain
local shader4 = love.graphics.newShader [[
	extern number opacity;
    extern number size;
    extern vec2 noise;
    extern Image noisetex;
    extern vec2 tex_ratio;
    float rand(vec2 co) {
    	return Texel(noisetex, mod(co * tex_ratio / vec2(size), vec2(1.0))).r;
    }
    vec4 effect(vec4 color, Image texture, vec2 tc, vec2 _) {
		return color * Texel(texture, tc) * mix(1.0, rand(tc+vec2(noise)), opacity);
	}
]]

local pixelcode = [[
	varying vec4 vpos;
 
	vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
	{
		texture_coords += vec2(cos(vpos.x), sin(vpos.y));
		vec4 texcolor = Texel(texture, texture_coords);
		return texcolor * color;
	}
]]
 
local vertexcode = [[
	varying vec4 vpos;
 
	vec4 position( mat4 transform_projection, vec4 vertex_position )
	{
		vpos = vertex_position;
		return transform_projection * vertex_position;
	}
]]

shader5 = love.graphics.newShader(pixelcode)

function love.load() 
	square_size = 300
	effect = moonshine(moonshine.effects.glow)
end

function love.update(dt)

end

function love.draw()
	love.graphics.setColor(.5,.2,.7)

	love.graphics.setShader(shader5)
	love.graphics.rectangle("fill", 10, 10, square_size, square_size)

	love.graphics.setShader(shader2)
	shader2:send("darkness", 10)
	love.graphics.rectangle("fill", 320, 10, square_size, square_size)
	love.graphics.setShader()

	love.graphics.setShader(shader3)
	love.graphics.rectangle("fill", 630, 10, square_size, square_size)
	love.graphics.setShader()

	love.graphics.setShader(shader1)
	shader1:send("screen", {10+square_size, 320+square_size})
	love.graphics.rectangle("fill", 10, 320, square_size, square_size)
	love.graphics.setShader()

	love.graphics.setShader(shader4)
	local noisetex = love.image.newImageData(256,256)
	noisetex:mapPixel(function()
		local l = love.math.random() * 255
		return l,l,l,l
	end)
	noisetex = love.graphics.newImage(noisetex)
	shader4:send("opacity", .3)
	shader4:send("size", 1)
	shader4:send("noise", {love.math.random(), love.math.random()})
	shader4:send("noisetex", noisetex)
	shader4:send("tex_ratio", {love.graphics.getWidth() / noisetex:getWidth(),love.graphics.getHeight() / noisetex:getHeight()})
	love.graphics.rectangle("fill", 320,320, square_size, square_size)
	love.graphics.setShader()

	effect(function()
		love.graphics.rectangle("fill", 630,320, square_size, square_size)
	end)
	love.graphics.setShader()
end