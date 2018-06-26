
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
	file:close()
end

function playing_update(dt)
	p:physics(dt)
	p:update(dt)
	scenary_update(dt)
	if kpressed then
		if pressedk == "escape" then
			to_paused()
		end
	end
end

function playing_draw()
	p:draw()
	scenary_draw()
	local graphFont = love.graphics.newFont('font/SourceSansPro-Bold.ttf', 12)
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
