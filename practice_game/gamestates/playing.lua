
local deathFont = love.graphics.newFont('font/SourceSansPro-Bold.ttf', 24)
local graphFont = love.graphics.newFont('font/SourceSansPro-Bold.ttf', 12)
local camera_speed = 2000
local frozen = false

function playing_load()
	local file = io.open(selected_level, "r")
	p = player:create()
	for i in io.lines (selected_level) do
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
		elseif temp_table[0] == "death_zone" then
			deathzone:create(tonumber(temp_table[1]),
											tonumber(temp_table[2]),
											tonumber(temp_table[3]),
											tonumber(temp_table[4]))
		elseif temp_table[0] == "win_zone" then
			winzone:create(tonumber(temp_table[1]),
											tonumber(temp_table[2]),
											tonumber(temp_table[3]),
											tonumber(temp_table[4]))
		end
	end
	camera:setPosition(p.x-(love.graphics.getWidth()/2),p.y-(love.graphics.getHeight()/2))
	file:close()
end

function playing_update(dt)
	if not frozen then
		p:update(dt)
		p:physics(dt)
		scenary_update(dt)
		if deathzone[1] ~= nil then
			if deathzone_collided(p) then
				p:goToSpawn()
				p.deathcount = p.deathcount + 1
				deathsInSession = deathsInSession + 1
			end
		end
		if winzone[1] ~= nil then
			if winzone_collided(p) then
				frozen = true
			end
		end
		if kpressed then
			if pressedk == "escape" then
				to_paused()
			elseif pressedk == "f" then
				frozen = true
			end
		end

		
		local w = love.graphics.getWidth()
		local h = love.graphics.getHeight()
		local camera_x_min = ((p.x-w/2)-w/8)
		local camera_x_max = ((p.x-w/2)+w/8)
		local camera_y_min = ((p.y-h/2)-h/8)
		local camera_y_max = ((p.y-h/2)+h/8)
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
	else
		if kdown then
			frozen = false
			to_main_menu()
		end
	end
end

function playing_draw(dt)
	camera:set()
	p:draw()
	scenary_draw()
	camera:unset()
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
	love.graphics.setFont(deathFont)
	love.graphics.print("Death Count: "..tostring(p.deathcount), 10,0)
	if frozen then
		love.graphics.setColor(0.2,0.2,0.2,0.5)
		love.graphics.rectangle("fill",0, 0, love.graphics.getWidth(),love.graphics.getHeight())
		coroutine.resume(infomessage, 5, "Congratulations!\nYou only died "..tostring(p.deathcount).." times.")
	end
end
