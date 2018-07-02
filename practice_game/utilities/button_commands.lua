require ("utilities.loading_saves")

game_loaded = false

function to_main_menu()
	for i, v in ipairs(button) do button.remove(i) end
	for i, v in ipairs(player) do player.remove(i) end
	gamestate = "main_menu"
	game_loaded = false
	main_menu_load()
end

function to_game()
	for i, v in ipairs(button) do button.remove(i) end
	gamestate = "playing"
	camera.x = 0
	camera.y = 0
	camera:setScale(1,1)
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
	camera.x = 0
	camera.y = 0
end

function to_saving()
	local file = io.open("practice_game/level.oli", "w")
	for i, v in ipairs(editor_graphics) do
		print(v.s..":"..tostring(v.x)..":"..tostring(v.y)..":"..tostring(v.w)..":"..tostring(v.h)..":"..tostring(v.r)..":"..tostring(v.g)..":"..tostring(v.b))
		file:write(v.s..":"..tostring(v.x)..":"..tostring(v.y)..":"..tostring(v.w)..":"..tostring(v.h)..":"..tostring(v.r)..":"..tostring(v.g)..":"..tostring(v.b).."\n")
	end
	file:close()
end

function to_open(override)
	if #editor_graphics > 0 and not override then
		level_editor_menu_state = "save"
		return
	else
		local file = io.open("practice_game/level.oli", "r")
		for i in io.lines 'practice_game/level.oli' do
			local string = ""
			local object = {}
			local str = file:read()
			local temp_table = get_level_details(str)
			if temp_table[0] == "rectangle" then
				editor_graphics:createRectangle(tonumber(temp_table[1]),
												tonumber(temp_table[2]),
												tonumber(temp_table[3]),
												tonumber(temp_table[4]),
												tonumber(temp_table[5]),
												tonumber(temp_table[6]),
												tonumber(temp_table[7]))
			elseif temp_table[0] == "player" then
				editor_graphics:createPlayer(tonumber(temp_table[1]),
												tonumber(temp_table[2]),
												tonumber(temp_table[3]),
												tonumber(temp_table[4]),
												tonumber(temp_table[5]),
												tonumber(temp_table[6]),
												tonumber(temp_table[7]))
			end
		end
		file:close()
	end
end