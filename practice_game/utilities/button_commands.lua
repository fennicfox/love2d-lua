require ("utilities.loading_saves")

function to_main_menu()
	for i, v in ipairs(button)  do button[i]  = nil end
	for i, v in ipairs(player)  do player[i]  = nil end
	for i, v in ipairs(scenary) do scenary[i] = nil end
	if death_zone ~= nil then
		for i, v in ipairs(death_zone) do death_zone[i] = nil end
		for i, v in ipairs(win_zone) do win_zone[i] = nil end
	end
	if deathzone ~= nil then
		for i, v in ipairs(deathzone) do deathzone[i] = nil end
		for i, v in ipairs(winzone) do winzone[i] = nil end
	end

	gamestate = "Main menu"
	game_loaded = false
	main_menu_load()
end

function to_game()
	for i, v in ipairs(button) do button[i] = nil end
	gamestate = "Playing"
	camera.x = 0
	camera.y = 0
	camera:setScale(1,1)
	playing_load() 
end

function to_settings()
	
end

function to_paused()
	for i, v in ipairs(button) do button[i] = nil end
	gamestate = "Paused"
	paused_load()
end

function to_level_editor()
	for i, v in ipairs(button) do button[i] = nil end
	gamestate = "Level editor"
	camera.x = 0
	camera.y = 0
end

function to_saving()
	local file = io.open(selected_level, "w")
	for i, v in ipairs(editor_graphics) do
		if v.s == "death_zone" or v.s == "win_zone" then
			file:write(v.s..":"..tostring(v.x)..":"..tostring(v.y)..":"..tostring(v.w)..":"..tostring(v.h).."\n")
		else
			file:write(v.s..":"..tostring(v.x)..":"..tostring(v.y)..":"..tostring(v.w)..":"..tostring(v.h)..":"..tostring(v.r)..":"..tostring(v.g)..":"..tostring(v.b).."\n")
		end
	end
	file:close()
end

function to_open(override)
	if #editor_graphics > 0 and not override then
		level_editor_menu_state = "save"
		return
	else
		local file = io.open(selected_level, "r")
		for i in io.lines (selected_level) do
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
			elseif temp_table[0] == "death_zone" then
				editor_graphics:death_zone(tonumber(temp_table[1]),
												tonumber(temp_table[2]),
												tonumber(temp_table[3]),
												tonumber(temp_table[4]))
			elseif temp_table[0] == "win_zone" then
				editor_graphics:win_zone(tonumber(temp_table[1]),
												tonumber(temp_table[2]),
												tonumber(temp_table[3]),
												tonumber(temp_table[4]))
			end
		end
		editor_graphics.selected = nil
		file:close()
	end
end