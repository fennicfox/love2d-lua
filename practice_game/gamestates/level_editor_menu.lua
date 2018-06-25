local level_editor_menu_state = "main"
local elapsed_time = 0
local saved = false

function level_editor_menu_load(  )
	local colour 		= { 1, 1, 1 }
	local newColour 	= { 0.4,0.4,0.4 }
	local windowWidth 	= love.graphics.getWidth()   /2
	local windowHeight  = love.graphics.getHeight() /2
	button_resume 		= button:create(windowWidth, windowHeight-120, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "resume",       function() editor_state = "main" end)
	button_settings 	= button:create(windowWidth, windowHeight-80, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "settings",     to_settings)
	button_open 		= button:create(windowWidth, windowHeight-40, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "open",     	 function() editor_state = "open" end)
	button_save 		= button:create(windowWidth, windowHeight   , colour, newColour, "font/SourceSansPro-Light.ttf", 32, "save",         function()  
					start_time = os.time() 
					local file = io.open("file-name", "a") 
					for i, v in ipairs(editor_graphics) do
						print(v.s..":"..tostring(v.x)..":"..tostring(v.y)..":"..tostring(v.w)..":"..tostring(v.h)..":"..tostring(v.r)..":"..tostring(v.g)..":"..tostring(v.b))
						file:write(v.s..":"..tostring(v.x)..":"..tostring(v.y)..":"..tostring(v.w)..":"..tostring(v.h)..":"..tostring(v.r)..":"..tostring(v.g)..":"..tostring(v.b)) 
					end
					saved = true
					return saved
					end)
	button_export 		= button:create(windowWidth, windowHeight+40, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "export",       to_export)
	button_quit 		= button:create(windowWidth, windowHeight+80, colour, newColour, "font/SourceSansPro-Light.ttf", 32, "quit",         function() gamestate=("main_menu") end)
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
	elseif level_editor_menu_state == "exporting" then
		
	elseif level_editor_menu_state == "open" then

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
	button_resume:changePos(   w/2, h/2-120 )
	button_settings:changePos( w/2, h/2-80 )
	button_open:changePos(     w/2, h/2-40 )
	button_save:changePos(     w/2, h/2    )
	button_export:changePos(   w/2, h/2+40 )
	button_quit:changePos(     w/2, h/2+80 )
end

