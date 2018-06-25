function paused_load()
	windowHeight 	= love.graphics.getHeight( )/2  -- Gets the window height
	windowWidth  	= love.graphics.getWidth( ) /2    -- Gets the window width
	local colour 	= {1, 1, 1}
	local newColour = {0.4,0.4,0.4}
	button_resume 	= button:create(windowWidth, windowHeight-40, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "resume", to_game)
	button_settings = button:create(windowWidth, windowHeight, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "settings", to_main_menu)
	button_quit 	= button:create(windowWidth, windowHeight+40, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "quit", to_main_menu)
end

function paused_draw()
	button_resume:show()
	button_settings:show()
	button_quit:show()
end

function paused_update(dt)
	if kpressed then
		if pressedk == "escape" then
			to_game()
		end
	end
end

function paused_resize(w, h)
	button_resume:changePos(w/2, h/2-40)
	button_settings:changePos(w/2, h/2)
	button_quit:changePos(w/2, h/2+40)
end