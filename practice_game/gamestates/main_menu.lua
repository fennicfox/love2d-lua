menustate = "main"

function main_menu_load()
	local windowHeight 	= love.graphics.getHeight( ) /2  -- Gets the window height
	local windowWidth  	= love.graphics.getWidth( )  /2  -- Gets the window width
	local colour 	= {1, 1, 1}
	local newColour = {0.4,0.4,0.4}
	button_start 	= button:create(windowWidth, windowHeight-60, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "start",        to_game)
	button_editor   = button:create(windowWidth, windowHeight-20, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "level editor", to_level_editor)

	--this messy line below is temporary :)
	button_settings = button:create(windowWidth, windowHeight+20, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "settings",     function() 
		for i, v in ipairs(fsystem) do
			print(v.text)
			fsystem[i] = nil
		end
		menustate = "settings" 
		findAllLevels()
	end)

	button_quit 	= button:create(windowWidth, windowHeight+60, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "quit",         love.event.quit)
end

function main_menu_update(dt)
	camera.x = 0
	camera.y = 0
	if menustate == "main" then
		if kpressed then
			if pressedk == "escape" then
				love.event.quit()
			end
		end
	elseif menustate == "settings" then
		if kpressed then
			if pressedk == "escape" then
				menustate = "main"
			end
		end
		fsystem_update(dt)
	end
end

function main_menu_draw()
	if menustate == "main" then
		button_start:show()
		button_editor:show()
		button_settings:show()
		button_quit:show()
	elseif menustate == "settings" then
		fsystem_draw()
	end
end

function main_menu_resize(w, h)
	if menustate == "main" then
		button_start:changePos(    w/2, h/2-60)
		button_editor:changePos(   w/2, h/2-20)
		button_settings:changePos( w/2, h/2+20)
		button_quit:changePos(     w/2, h/2+60)
	elseif menustate == "settings" then
	end
end
