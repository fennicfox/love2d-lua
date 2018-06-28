level_editor_menu_state = "main"
local elapsed_time = 0
local saved = false

function level_editor_menu_load(  )
	local colour 		= { 1, 1, 1 }
	local newColour 	= { 0.4,0.4,0.4 }
	local windowWidth 	= love.graphics.getWidth()  /2
	local windowHeight  = love.graphics.getHeight() /2
	button_resume 		= button:create(windowWidth, windowHeight-120, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "resume",      function() editor_state = "main" end)
	button_settings 	= button:create(windowWidth, windowHeight-80, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "settings",     to_settings						 )
	button_open 		= button:create(windowWidth, windowHeight-40, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "open",     	 to_open							 )
	button_save 		= button:create(windowWidth, windowHeight   , colour, newColour, "font/SourceSansPro-Light.ttf", 32, "save",         to_saving							 )
	button_export 		= button:create(windowWidth, windowHeight+40, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "export",       to_export							 )
	button_quit 		= button:create(windowWidth, windowHeight+80, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "quit",         function() gamestate="main_menu" end)
	button_dontsave_y   = button:create(windowWidth-80, windowHeight+80, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "yes",       function() save("y")           end)
	button_dontsave_n   = button:create(windowWidth, windowHeight+80, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "no",           function() save("n")            end)
	button_dontsave_c   = button:create(windowWidth+80, windowHeight+80, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "cancel",    function() save("c")        end)
end

function level_editor_menu_draw(  )
	if level_editor_menu_state == "main" then
		button_resume:show()
		button_settings:show()
		button_open:show()
		button_save:show()
		button_export:show()
		button_quit:show()
		if saving then
			love.graphics.setColor(1, 1, 1)
			love.graphics.setFont(graphFont, 12)
			love.graphics.print("saved", 10, love.graphics.getHeight()-20)
			local elapsed_time = os.time() - start_time
			local finished_time = elapsed_time+os.time()
			if elapsed_time >= 2 then saving = false end
		end
	elseif level_editor_menu_state == "save" then
		local mmFont    = love.graphics.newFont("font/SourceSansPro-Light.ttf", 32)
		love.graphics.setFont(mmFont)
		button_dontsave_y:show()
		button_dontsave_n:show()
		button_dontsave_c:show()
		love.graphics.setColor(1,1,1,1)
		love.graphics.print("Opening will lose your current progress",
			love.graphics.getWidth()/2 - mmFont:getWidth("Opening will lose your current progress")/2,
			love.graphics.getHeight()/2-40
		)
		love.graphics.print("Do you want to save?", 
			love.graphics.getWidth()/2 - mmFont:getWidth("Do you want to save?")/2,
			love.graphics.getHeight()/2
		)
	end
end

function level_editor_menu_update( dt )
	if kpressed then 
		if pressedk == "escape" then 
			editor_state = "main" 
		end 
	end
end

function level_editor_menu_resize(w, h)
	if level_editor_menu_state == "main" then
		button_resume:changePos(     w/2,    h/2-120 )
		button_settings:changePos(   w/2,    h/2-80  )
		button_open:changePos(       w/2,    h/2-40  )
		button_save:changePos(       w/2,    h/2     )
		button_export:changePos(     w/2,    h/2+40  )
		button_quit:changePos(       w/2,    h/2+80  )
	elseif level_editor_menu_state == "save" then
		button_dontsave_y:changePos( w/2-80, h/2+80  )
		button_dontsave_n:changePos( w/2,    h/2+80  )
		button_dontsave_c:changePos( w/2+80, h/2+80  )
	end
end

function save( s )
	if s == "y" then
		to_saving()
		to_open(true)
	elseif s == "n" then
		for i = 1, #editor_graphics do 
			editor_graphics[i] = nil
		end
		to_open(true)
	end
	level_editor_menu_state = "main"
end
