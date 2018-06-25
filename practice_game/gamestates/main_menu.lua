function main_menu_load()
	local windowHeight 	= love.graphics.getHeight( ) /2  -- Gets the window height
	local windowWidth  	= love.graphics.getWidth( )  /2  -- Gets the window width
	local colour 	= {1, 1, 1}
	local newColour = {0.4,0.4,0.4}
	button_start 	= button:create(windowWidth, windowHeight-60, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "start",        to_game)
	button_editor   = button:create(windowWidth, windowHeight-20, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "level editor", to_level_editor)
	button_settings = button:create(windowWidth, windowHeight+20, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "settings",     to_settings)
	button_quit 	= button:create(windowWidth, windowHeight+60, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "quit",         love.event.quit)
end

function main_menu_draw()
	button_start:show()
	button_editor:show()
	button_settings:show()
	button_quit:show()
end

function main_menu_update(dt)
	if kpressed then
		if pressedk == "escape" then
			love.event.quit()
		end
	end
end

function main_menu_resize(w, h)
	button_start:changePos(    w/2, h/2-60)
	button_editor:changePos(   w/2, h/2-20)
	button_settings:changePos( w/2, h/2+20)
	button_quit:changePos(     w/2, h/2+60)
end
