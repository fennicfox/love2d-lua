local shader_code = [[
extern vec2 screen;
vec4 effect (vec4 color, Image image, vec2 uvs, vec2 screen_coords){
	vec4 pixel = Texel(image, uvs);
	vec2 sc = vec2(screen_coords.x / screen.x, screen_coords.y / screen.y);
	return vec4 (sc.xy, color[0], 1);
}

]]

local shader_dark = [[
extern int darkness;
vec4 effect (vec4 color, Image image, vec2 uvs, vec2 screen_coords){
	return vec4(color[0]/darkness, color[1]/darkness, color[2]/darkness, 1);
}

]]

local blacknwhite = [[
vec4 effect (vec4 color, Image image, vec2 uvs, vec2 screen_coords){
	float av = (color[0], color[1], color[2]) / 3;
	return vec4(av, av, av, color[3]);
}

]]


function love.load() 
	square_size = 300
	shader1 = love.graphics.newShader(shader_code)
	shader2 = love.graphics.newShader(shader_dark)
	shader3 = love.graphics.newShader(blacknwhite)
end

function love.update(dt)

end

function love.draw()
	love.graphics.setColor(.5,.2,.7)
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
	love.graphics.rectangle("fill", 320,320, square_size, square_size)
	love.graphics.rectangle("fill", 630,320, square_size, square_size)
end
