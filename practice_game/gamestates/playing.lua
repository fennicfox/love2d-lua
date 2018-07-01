function playing_load()
	local file = io.open("practice_game/level.oli", "r")
	p = player:create()
	for i in io.lines 'practice_game/level.oli' do
		local string = ""
		local object = {}
		local str = file:read()
		local temp_table = get_level_details(str)
		if temp_table[0] == "rectangle" then
			scenary:createRectangle(tonumber(temp_table[1]),
											tonumber(temp_table[2]),
											tonumber(temp_table[3]),
											tonumber(temp_table[4]),
											tonumber(temp_table[5]),
											tonumber(temp_table[6]),
											tonumber(temp_table[7]))
		elseif temp_table[0] == "player" then
			p = player:create(tonumber(temp_table[1]),
											tonumber(temp_table[2]),
											tonumber(temp_table[3]),
											tonumber(temp_table[4]),
											tonumber(temp_table[5]),
											tonumber(temp_table[6]),
											tonumber(temp_table[7]))
		end
	end
	camera:setPosition(p.x-(love.graphics.getWidth()/2),p.y-(love.graphics.getHeight()/2))
	file:close()
end

function playing_update(dt)
	p:update(dt)
	p:physics(dt)
	scenary_update(dt)
	if kpressed then
		if pressedk == "escape" then
			to_paused()
		end
	end
	
	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()
	local camera_x_min = ((p.x-w/2)-w/8)
	local camera_x_max = ((p.x-w/2)+w/8)
	local camera_y_min = ((p.y-h/2)-h/8)
	local camera_y_max = ((p.y-h/2)+h/8)
	local camera_speed = 2000
	local camera_xv = 0
	local camera_yv = 0

	if camera.x < camera_x_min then
		camera_xv = camera_speed
	elseif camera.x > camera_x_max then
		camera_xv = -camera_speed
	end
	if camera.y < camera_y_min then
		camera_yv = camera_speed
	elseif camera.y > camera_y_max then
		camera_yv = -camera_speed
	end
	camera:move(camera_xv,camera_yv, dt)
end

function playing_draw(dt)
	camera:set()
	p:draw()
	scenary_draw()
	camera:unset()
	local graphFont = love.graphics.newFont('font/SourceSansPro-Bold.ttf', 12)
	love.graphics.setColor(0.2,0.2,0.2,0.5)
	love.graphics.rectangle("fill", love.graphics.getWidth()-130, 0, 130,110)
	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(graphFont)
	love.graphics.print("Frames Per Second: "..math.floor(tostring(love.timer.getFPS( )))..
						"\n\nYou:\nx: "..math.floor(tostring(p.x))..
						"\ny: "..math.floor(tostring(p.y))..
						"\nxvel"..math.floor(tostring(p.xvel))..
						"\nyvel"..math.floor(tostring(p.yvel)),
						(love.graphics.getWidth()-130),
						5
	)
	
end
