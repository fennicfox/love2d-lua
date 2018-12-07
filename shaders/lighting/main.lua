require "entities.scenary"
require "entities.player"


local DARKNESS = 42
local NUMBER_OF_LIGHTS = 1

-- local light_code = love.graphics.newShader([[
-- 	extern int radius;
-- 	extern int player_x;
-- 	extern int player_y;
-- 	float r = 0.62;
-- 	float g = 0.6;
-- 	float b = 0.1;
-- 	vec4 effect (vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){
-- 		float distance = pow( (pow((screen_coords.x - radius),2) + pow((screen_coords.y - radius),2)),0.5);
-- 		float scale = .9 + ((distance - 0) / (radius - 0)) * (0 - .9) ;
-- 		return vec4(r,g,b, scale);
-- 	}
-- ]])

local light_code = love.graphics.newShader([[
#define NUM_LIGHTS 32

struct Light {
	vec2 position;
	vec3 diffuse;
	float power;
};

extern Light lights[NUM_LIGHTS];
extern int num_lights;

extern vec2 screen;

const float constant = 1.0;
const float linear = 0.09;
const float quadratic = 0.032;

vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
	vec4 pixel = Texel(image, uvs);
	vec2 norm_screen = screen_coords / screen;
	vec3 diffuse = vec3(0);
	
	for (int i = 0; i < num_lights; i++) {
		Light light = lights[i];
		vec2 norm_pos = light.position / screen;
		
		float distance = length(norm_pos - norm_screen) * light.power;
		float attenuation = 1.0 / (constant + linear * distance + quadratic * (distance * distance));
		diffuse += light.diffuse * attenuation;
	}

	diffuse = clamp(diffuse, 0.0, 1.0);

	return pixel * vec4(diffuse, 1.0);
}
]])


function love.load()
	p = player:create(50,50,20,40, 1.0, 0.717, 0.298)
	s1 = scenary:create(500,400, 40, 40, 0, 0, 0, 1)
	s2 = scenary:create(300,500, 40, 40, 0, 0, 0, 1)
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
	love.graphics.setShader(light_code)
	light_code:send("screen", {love.graphics.getWidth(), love.graphics.getHeight()})
	light_code:send("num_lights", NUMBER_OF_LIGHTS)    
	light_code:send("lights[0].position", {p.x+(p.w/2),p.y+(p.h/2)})
	light_code:send("lights[0].diffuse", {p.r, p.g, p.b})
	light_code:send("lights[0].power", DARKNESS)
	love.graphics.push()
	love.graphics.scale(1.32,2)
	love.graphics.draw(background)
	love.graphics.pop()
	--light_code:send("radius",120)
	--light_code:send("player_x", p.x)
	--light_code:send("player_y", p.y)
	
	p:draw()
	light_code:send("lights[0].diffuse", {0.0, 0.0, 0.0})
	p:draw_rays(s1)
	p:draw_rays(s2)
	s1:draw()
	s2:draw()
	love.graphics.setShader()
	love.graphics.setColor(0.5,1,0)
	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), love.graphics.getWidth()-55, 0)
end

function love.mousepressed(x,y, key)
	if key == 1 then
		print("--------")
		print("x = "..x)
		print("y = "..y)
	end
end