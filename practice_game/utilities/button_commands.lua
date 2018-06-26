require ("utilities.loading_saves")

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
	local file = io.open("practice_game/level.oli", "w")
	file:close()
end

function to_saving()
	local file = io.open("practice_game/level.oli", "w")
	for i, v in ipairs(editor_graphics) do
		print(v.s..":"..tostring(v.x)..":"..tostring(v.y)..":"..tostring(v.w)..":"..tostring(v.h)..":"..tostring(v.r)..":"..tostring(v.g)..":"..tostring(v.b))
		file:write(v.s..":"..tostring(v.x)..":"..tostring(v.y)..":"..tostring(v.w)..":"..tostring(v.h)..":"..tostring(v.r)..":"..tostring(v.g)..":"..tostring(v.b).."\n")
	end
	file:close()
end

function to_open()
	local file = io.open("practice_game/level.oli", "r")
	local string = ""
	local done = false
	local ctr = 0
	for i in io.lines 'practice_game/level.oli' do
  		ctr = ctr + 1
		print(i)
		print(shape(i))
		local string = file:read()
		local object = {
		}
		table.insert(editor_graphics, object)
	end
	file:close()
end