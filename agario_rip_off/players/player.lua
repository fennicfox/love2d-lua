require("camera")
player = {}
local font_scaling_size = 200
function player.load()
	player.x        = 0
	player.y        = 0
	player.xvel     = 0
	player.yvel     = 0
	player.friction = 5
	player.speed    = 2250
	player.r        = 20
	player.s        = 512
	player.red      = math.random(0.2,0.3)
	player.green    = math.random(0.2,0.3)
	player.blue     = math.random(0.2,0.3)
	player.font     = love.graphics.setNewFont("SourceSansPro-Light.ttf", 500 )
end

function player.draw()
	love.graphics.setColor(player.red, player.green, player.blue, 1)
	love.graphics.circle("fill", player.x, player.y, player.r, player.s)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(player.font)
	love.graphics.push()
	love.graphics.scale((player.r/2)/font_scaling_size, (player.r/2)/font_scaling_size) 
	--starting scale = 0.1
	--scale increments by 0.0025
	--e.g. 0.1, 0.1025, 0.1050 etc..
	--need to decrement scaler every time font gets bigger
	--e.g. 10, 9.75609756098, 9.52380952381
	--1 / 0.1025
	love.graphics.print(math.floor(player.r),
				player.x*(1/((player.r/2)/font_scaling_size))-(player.font:getWidth(math.floor(player.r))/2),
				player.y*(1/((player.r/2)/font_scaling_size))-(player.font:getHeight(math.floor(player.r))/2)
	)
	love.graphics.pop()
end


function player.physics( dt )
	player.x = player.x + player.xvel * dt
	player.y = player.y + player.yvel * dt
	player.xvel = player.xvel * (1 - math.min(dt*player.friction, 1))
	player.yvel = player.yvel * (1 - math.min(dt*player.friction, 1))
end


function player.move( dt )

	if love.keyboard.isDown('right','d') and
	player.xvel < player.speed then
		player.xvel = player.xvel + player.speed * dt
	end

	if love.keyboard.isDown('left','a') and
	player.xvel > -player.speed then
		player.xvel = player.xvel - player.speed * dt
	end

	if love.keyboard.isDown('down','s') and
	player.yvel < player.speed then
		player.yvel = player.yvel + player.speed * dt
	end

	if love.keyboard.isDown('up','w') and
	player.yvel > -player.speed then
		player.yvel = player.yvel - player.speed * dt
	end

	if love.keyboard.isDown('space') then
 		player.speed = 0
	else
 		player.speed = 2250
	end

	if love.keyboard.isDown('f1') then
		print("#########\nx="..player.x)
		print("y="..player.y.."\n#########")
	end
end

function UPDATE_PLAYER( dt )
	player.physics( dt )
	player.move( dt )
end


function draw_player( dt )
	player.draw(dt)
end
