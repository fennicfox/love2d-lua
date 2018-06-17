game_loaded = false

function to_main_menu()
	for i, v in ipairs(button) do button.remove(i) end
	gamestate = "main_menu"
	game_loaded = false
	main_menu_load()
end

function to_game()
	for i, v in ipairs(button) do button.remove(i) end
	gamestate = "playing"
	if not game_loaded then
		game_loaded = true 
		playing_load() 
	end
end

function to_settings()
	for i, v in ipairs(button) do button.remove(i) end
	game_loaded = false
end

function to_paused()
	for i, v in ipairs(button) do button.remove(i) end
	gamestate = "paused"
	paused_load()
end

function to_level_editor()
	for i, v in ipairs(button) do button.remove(i) end
	gamestate = "level_editor"
end

function to_export()
	for i, v in ipairs(button) do button.remove(i) end
	level_editor_menu_state = "exporting"

end

function to_saving()
	local file = io.open("file-name", "a")
	for i, v in ipairs(editor_graphics) do
		print(v.s..":"..tostring(v.x)..":"..tostring(v.y)..":"..tostring(v.w)..":"..tostring(v.h)..":"..tostring(v.r)..":"..tostring(v.g)..":"..tostring(v.b))
		file:write(v.s..":"..tostring(v.x)..":"..tostring(v.y)..":"..tostring(v.w)..":"..tostring(v.h)..":"..tostring(v.r)..":"..tostring(v.g)..":"..tostring(v.b))
	end
	file:close()
end