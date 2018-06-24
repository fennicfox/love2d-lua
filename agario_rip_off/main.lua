require("players.player") --loads the player.lua file
require("camera") --loads the camera.lua file
require("consumables.food") --loads the food.lua file in the food directory
require("consumables.spike") --loads the spike.lua file in the food directory
require("audio.sound")
require("gamestate.menu")


function love.load() 							-- Loads all the stuff commands that only need to be loaded once. This function does not repeat (update).
	love.graphics.setBackgroundColor( 0, 0, 0 ) -- Sets background colour
	spike:load()								-- Loads the spike properties!
	player.load()								-- Loads the player properties!
	gamestate = "paused"

	for i = 1,500 do
		food:load(math.random((player.x-2000),
			(player.x+2000)),
			math.random((player.x-2000),
			(player.x+2000)),
			math.random(0.2,1),
			math.random(0.2,1),
			math.random(0.2,1))
	end
end

function love.update(dt)
	windowHeight = love.graphics.getHeight( )  -- Gets the window height
	windowWidth = love.graphics.getWidth( )    -- Gets the window width
	if gamestate == "playing" then
		if love.keyboard.isDown('tab') then
			camera:setPosition(50, 50)
		else
			camera:setPosition(player.x - (windowWidth/2), player.y - (windowHeight/2))
		end
		UPDATE_PLAYER( dt )
		UPDATE_FOOD( dt )
		UPDATE_SPIKE( dt )
	end
	if gamestate == "paused" then
		if love.keyboard.isDown('return') then
			gamestate = "playing"
		end
	end
end


function love.draw(dt)
	if gamestate=="playing" then
		love.graphics.setColor(1,1,1)
		local font = love.graphics.setNewFont(12)
		love.graphics.print("Frames Per Second: "..math.floor(tostring(love.timer.getFPS( ))).."\n\nYou:\nx: "..math.floor(tostring(player.x)).."\ny: "..math.floor(tostring(player.y)), (windowWidth-175), 5)	--x and y of player and food
		camera:set()
		draw_player(dt)
		draw_food(dt)
		spike:draw(dt)
		camera:unset()
	end
	if gamestate == "paused" then
		local font = love.graphics.setNewFont("Android.ttf", 100)
		button.draw()
		local width = font:getWidth("Start") --gets the width of the argument in pixels for this font
		button.spawn(windowWidth/2-width/2, windowHeight/4, "Start")
		local width = font:getWidth("Settings") --gets the width of the argument in pixels for this font
		button.spawn(windowWidth/2-width/2, windowHeight/2, "Settings")
		local width = font:getWidth("Quit") --gets the width of the argument in pixels for this font
		button.spawn(windowWidth/2-width/2, windowHeight/4+windowHeight/2, "Quit")
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