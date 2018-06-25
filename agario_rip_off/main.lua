require("players.player") --loads the player.lua file
require("camera") --loads the camera.lua file
require("consumables.food") --loads the food.lua file in the food directory
require("consumables.spike") --loads the spike.lua file in the food directory
require("audio.sound")
require("gamestate.menu")


function love.load() 							-- Loads all the stuff commands that only need to be loaded once. This function does not repeat (update).
	love.graphics.setBackgroundColor( 0, 0, 0 ) -- Sets background colour
	player.load()								-- Loads the player properties!
	gamestate = "paused"
	w = love.graphics.getWidth()
	h = love.graphics.getHeight()
	button.spawn("center", "Start")
	button.spawn("center", "Settings")
	button.spawn("center", "Quit")

	for i = 0, 10 do
		spike:load() -- Loads the spike properties!
	end
	for i = 1,500 do
		food:load   (math.random((player.x-2000),(player.x+2000)),
					math.random((player.x-2000),(player.x+2000)),
					math.random(0.2,1),
					math.random(0.2,1),
					math.random(0.2,1))
	end
end

function love.update(dt)
	h = love.graphics.getHeight( )  -- Gets the window height
	w = love.graphics.getWidth( )    -- Gets the window width
	if gamestate == "playing" then
		if love.keyboard.isDown('tab') then
			camera:setPosition(50, 50)
		else
			camera:setPosition(player.x - (w/2), player.y - (h/2))
		end
		UPDATE_PLAYER( dt )
		UPDATE_FOOD( dt )
		UPDATE_SPIKE( dt )
	end
	if gamestate == "paused" then
		button.update(dt)
		if love.keyboard.isDown('return') then
			gamestate = "playing"
		end
	end
end


function love.draw(dt)
	if gamestate=="playing" then
		love.graphics.setColor(1,1,1)
		local font = love.graphics.setNewFont(12)
		love.graphics.print("Frames Per Second: "..math.floor(tostring(love.timer.getFPS( ))).."\n\nYou:\nx: "..math.floor(tostring(player.x)).."\ny: "..math.floor(tostring(player.y)), (w-175), 5)	--x and y of player and food
		camera:set()
		draw_player(dt)
		draw_food(dt)
		spike:draw(dt)
		camera:unset()
	end
	if gamestate == "paused" then
		button.draw()
	end
end


function love.keypressed( key, unicode )
	if key=="escape"then
		print("Bye!")
		os.exit(0)
	end
end


function love.keyreleased( key, unicode )

end




function love.mousepressed( x, y, button )
	if button == "l" then
    	print("#########\nx="..x.."\ny="..y)
 	end 
end




function love.mousereleased( x, y, button )

end


function love.quit()

end