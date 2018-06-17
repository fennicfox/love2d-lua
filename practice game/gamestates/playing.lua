
function playing_load()
	player_1 = player:create(50, 50, 30, 50)
end

function playing_draw()
	player_1:draw()
	local graphFont = love.graphics.newFont('font/SourceSansPro-Bold.ttf', 12)
	love.graphics.setFont(graphFont)
	love.graphics.print("Frames Per Second: "..math.floor(tostring(love.timer.getFPS( ))).."\n\nYou:\nx: "..math.floor(tostring(player_1.x)).."\ny: "..math.floor(tostring(player_1.y)), (love.graphics.getWidth()-130), 5)	--x and y of player and food
end

function playing_update(dt)
	player_1:physics(dt)
	player_1:update(dt)
	if kpressed then
		if pressedk == "escape" then
			to_paused()
		end
	end
end