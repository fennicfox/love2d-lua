--[[
	=========================
	  How to use the editor
	=========================
|
|  '[' decreases the grid spacing
|  ']' increases the grid spacing
|
|  '-' decreases next placed square size
|  '+' increases next placed square size
|	
|  '.' next shape
|  ',' previous shape
|
|  'g' enables/disables grid
|  'b' enables/disables grid lock
|  'x' removes placements
|  
|  'escape' pauses the game
|  
|  'lmb' places entity
|  'rmb' scrolls around universe and selects objects
| 
|  'mwheelup' / 'mwheeldown' zooms in and out
|  
|  'lctrl' resizes selected objects
|
|  'space' or 'r' resets the camera back to 0

]]--


editor_graphics = {}
editor_graphics.w = 50 --the width  of the things being put down
editor_graphics.h = 50 --the height of the things being put down
editor_state = "main"

local shapes = {}
local shape_selected = 1   --shape index
local selected = nil
local grid_spacing = 50
local grid = true
local grid_lock = true
local grid_lock_size = editor_graphics.w / 2

--for player, selected objects and death zone fading
local flashing_speed = 1 --lower is faster
local cooldown = false
local alpha = 0

--for scrolling around the universe (not to confuse with zooming)
local scrolling_x = 0
local scrolling_y = 0
local scrolling_has_got = false
local rmb_x = mousex
local rmb_y = mousey

--for resizing objects
local cs = 3 --corner size

table.insert(shapes, "rectangle")
table.insert(shapes, "triangle")
table.insert(shapes, "player")
table.insert(shapes, "death_zone")
table.insert(shapes, "win_zone")


function editor_graphics:createRectangle(x, y, w, h, r, g ,b)
	local object = {
	s = "rectangle",
 	x = x,
	y = y,
	w = w,
	h = h,
	r = r,
	g = g,
	b = b
}
	table.insert(editor_graphics, object)
	setmetatable(object, {__index = self})
	return object
end

function editor_graphics:createPlayer(x, y, w, h, r, g, b)
	local object = {
		s = "player",
		x = x,
		y = y,
		w = w,
		h = h,
		r = r,
		g = g,
		b = b
	}
	
	table.insert(editor_graphics, object)
	setmetatable(object, {__index = self})
	return object
end

function editor_graphics:death_zone(x, y, w, h)
	local object = {
		s = "death_zone",
		x = x,
		y = y,
		w = w,
		h = h
	}
	
	table.insert(editor_graphics, object)
	setmetatable(object, {__index = self})
	return object
end

function editor_graphics:win_zone(x, y, w, h)
	local object = {
		s = "win_zone",
		x = x,
		y = y,
		w = w,
		h = h
	}
	
	table.insert(editor_graphics, object)
	setmetatable(object, {__index = self})
	return object
end

function level_editor_update(dt) -- love.graphics.polygon( mode, vertices )
	if editor_state == "main" then
		if love.mouse.isDown(2) then
			if not scrolling_has_got then
				scrolling_has_got = true
				scrolling_x = level_editor_mousex()
				scrolling_y = level_editor_mousey()
				rmb_x = mousex
				rmb_y = mousey
			else
				camera.x = camera.x - (level_editor_mousex() - scrolling_x)
				camera.y = camera.y - (level_editor_mousey() - scrolling_y)
				scrolling_x = level_editor_mousex()
				scrolling_y = level_editor_mousey()
			end
		else
			scrolling_has_got = false
		end
		if mpressed then
			if pressedm == 1 then
				if not love.keyboard.isDown('lctrl') then
					if shape_selected == 1 then
						editor_graphics:createRectangle(round((level_editor_mousex())-(editor_graphics.w/2), grid_lock_size), round((level_editor_mousey())-(editor_graphics.h/2), grid_lock_size), editor_graphics.w, editor_graphics.h, 1, 1, 1)
					elseif shape_selected == 3 then
						editor_graphics:createPlayer(round((level_editor_mousex())-(editor_graphics.w/2), grid_lock_size), round((level_editor_mousey())-(editor_graphics.h/2), grid_lock_size), 30, 50, 1, 1, 1)
					elseif shape_selected == 4 then
						editor_graphics:death_zone(round((level_editor_mousex())-(editor_graphics.w/2), grid_lock_size), round((level_editor_mousey())-(editor_graphics.h/2), grid_lock_size), editor_graphics.w, editor_graphics.h)
					elseif shape_selected == 5 then
						editor_graphics:win_zone(round((level_editor_mousex())-(editor_graphics.w/2), grid_lock_size), round((level_editor_mousey())-(editor_graphics.h/2), grid_lock_size), editor_graphics.w, editor_graphics.h)
					end
				end
			end
			if pressedm == 2 then
				if mousex == rmb_x and mousey == rmb_y then
					for i, v in ipairs(editor_graphics) do
						if level_editor_mousex() > v.x and level_editor_mousex() < v.x+v.w and level_editor_mousey() > v.y and level_editor_mousey() < v.y + v.h then
							selected = editor_graphics[i]
						end
					end
				end
				
			end
		end
	
		if mwheelup and (camera.scaleX > 0.2 and camera.scaleY > 0.2) then
			local mx = level_editor_mousex()
			local my = level_editor_mousey()
			camera:scale(0.8,0.8) --don't change
			camera.x = mx - (mousex * camera.scaleX)
			camera.y = my - (mousey * camera.scaleY)
			
		elseif mwheeldown and (camera.scaleX < 10 and camera.scaleY < 10) then
			local mx = level_editor_mousex()
			local my = level_editor_mousey()
			camera:scale(1.25,1.25) --don't change
			camera.x = mx - (mousex * camera.scaleX)
			camera.y = my - (mousey * camera.scaleY)
		end
		
		if kpressed then
			if pressedk == 'g' then
				if grid then 
					grid = false 
				else 
					grid = true 
				end
			elseif pressedk == 'b' then
				if grid then 
					grid_lock = false 
				else 
					grid_lock = true 
				end 
			elseif pressedk == 'escape' then 
				editor_state = "menu"
				level_editor_menu_load( )
			elseif pressedk == '-' then
				if editor_graphics.w >= 6.25 and editor_graphics.h >= 6.25 then 
					editor_graphics.w = editor_graphics.w/2 
					editor_graphics.h = editor_graphics.h/2 
					grid_lock_size = editor_graphics.w / 2
				end
			elseif pressedk == '=' then
				if editor_graphics.w <= 100 and editor_graphics.h <= 100 then 
					editor_graphics.w = editor_graphics.w*2 
					editor_graphics.h = editor_graphics.h*2 
					grid_lock_size = editor_graphics.w / 2
				end
			elseif pressedk == '[' then
				if grid_spacing ~= 12.5 then grid_spacing = grid_spacing - 12.5 end
			elseif pressedk == ']' then
				if grid_spacing ~= 100 then grid_spacing = grid_spacing + 12.5 end
			elseif pressedk == '.' then 
				shape_selected = ((shape_selected + 1) % (#shapes+1)) print(shape_selected, #shapes)
				if shape_selected == 0 then
					shape_selected = 1
				end
			elseif pressedk == ',' then
				shape_selected = ((shape_selected - 1 )% (#shapes)) print(shape_selected, #shapes)
				if shape_selected == 0 then
					shape_selected = #shapes
				end
			elseif pressedk == 'space' or pressedk == 'r' then
				camera.x = 0
				camera.y = 0
			end
		end
		if love.keyboard.isDown('x') then
			for i, v in ipairs(editor_graphics) do
				if level_editor_mousex() > v.x and level_editor_mousex() < v.x+v.w and level_editor_mousey() > v.y and level_editor_mousey() < v.y + v.h then
					if selected == editor_graphics[i] then
						selected = nil
					end
					table.remove(editor_graphics, i)
				end
			end
		end
	elseif editor_state == "menu" then
		level_editor_menu_update( dt )
	end
	
	--flashing effect for player (ignore and don't change) I might put this into a function later.
		if alpha < 1 and not cooldown then
		alpha = (alpha + (dt/flashing_speed))
		if alpha > 1 then
			cooldown = true
		end
	else
		alpha = (alpha - (dt/flashing_speed))
		if alpha < 0 then
			cooldown = false
		end
	end
end


function level_editor_draw()
	local winWidth  = love.graphics.getWidth()
	local winHeight = love.graphics.getHeight()
	if editor_state == "main" then
		love.graphics.setColor(0.4,0.4,0.4,0.47)
		camera:set()
		if grid then -- if the grid is true then draw the grid
			local xongrid = camera.x - (camera.x % grid_spacing)
			local yongrid = camera.y - (camera.y % grid_spacing)
			--lines going down
			for i = xongrid, (xongrid + (winWidth* camera.scaleX)), grid_spacing do 
				love.graphics.line(i, yongrid, i, yongrid+(winHeight*camera.scaleY)+grid_spacing) -- vertical lines
			end
			--lines going across
			for i = yongrid, (yongrid + (winHeight * camera.scaleY)), grid_spacing do	
				love.graphics.line(xongrid, i, xongrid+(winWidth*camera.scaleX)+grid_spacing, i) -- horizontal lines
			end
		end
		love.graphics.setColor(0.2, 0.2, 0.2, 0.47)
		if not love.keyboard.isDown('lctrl') then
			if shape_selected == 3 then --if player is selected
				love.graphics.rectangle('line', round((level_editor_mousex())-(editor_graphics.w/2), grid_lock_size), round((level_editor_mousey())-(editor_graphics.h/2), grid_lock_size), 30, 50)
			elseif shape_selected == 4 then
				love.graphics.rectangle('line', round((level_editor_mousex())-(editor_graphics.w/2), grid_lock_size), round((level_editor_mousey())-(editor_graphics.h/2), grid_lock_size), editor_graphics.w, editor_graphics.h)
			else
				love.graphics.rectangle('fill', round((level_editor_mousex())-(editor_graphics.w/2), grid_lock_size), round((level_editor_mousey())-(editor_graphics.h/2), grid_lock_size), editor_graphics.w, editor_graphics.h)
			end
		else

		end
		if #editor_graphics > 0 then
			for i, v in ipairs(editor_graphics) do
				if v.s == "rectangle" then
					love.graphics.setColor(v.r, v.g, v.b, 1)
					love.graphics.rectangle('fill', v.x, v.y, v.w, v.h)
				elseif v.s == "player" then
					love.graphics.setColor(v.r, v.g, v.b, alpha)
					love.graphics.rectangle('line', v.x, v.y, v.w, v.h)
				elseif v.s == "death_zone" then
					love.graphics.setColor(1,0.2,0.2,alpha)
					love.graphics.rectangle('line', v.x, v.y, v.w, v.h)
				elseif v.s == "win_zone" then
					love.graphics.setColor(0.2,255,0.2,alpha)
					love.graphics.rectangle('line', v.x, v.y, v.w, v.h)
				end
			end
		end
		if selected ~= nil then
			love.graphics.setColor(1, 0.627, 0, alpha) -- default selected object in blender colour
			love.graphics.rectangle('line', selected.x, selected.y, selected.w, selected.h)
			love.graphics.rectangle('line', selected.x-1, selected.y-1, selected.w+2, selected.h+2)
			love.graphics.rectangle('line', selected.x-2, selected.y-2, selected.w+4, selected.h+4)
			if love.keyboard.isDown('lctrl') then
				love.graphics.setColor(1, 0, 1, alpha) -- default selected object in blender colour
				love.graphics.rectangle('fill', selected.x-cs, selected.y-cs, cs*2, cs*2)   --top left
				love.graphics.rectangle('fill', (selected.x-cs)+selected.w, selected.y-cs, cs*2, cs*2) --top right
				love.graphics.rectangle('fill', selected.x-cs, (selected.y-cs)+selected.h, cs*2, cs*2) --bottom left
				love.graphics.rectangle('fill', (selected.x-cs)+selected.w, (selected.y-cs)+selected.h, cs*2, cs*2) --buttom right
			end
		end
		camera:unset()
		love.graphics.setColor(0, 0, 0, 0.5)
		love.graphics.rectangle("fill", 0, 0, 100, 100)
		love.graphics.setColor(0.3, 0.3, 0.3, 0.47)
		love.graphics.rectangle("line", 0, 0, 100, 100)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setFont(graphFont)
		love.graphics.print("Frames Per Second: "..math.floor(tostring(love.timer.getFPS( ))), (love.graphics.getWidth()-130), 5)	--x and y of player and food
		love.graphics.print("Grid Spacing: "..tostring(grid_spacing), 5, 5)
		love.graphics.print("Camera X: "..tostring(camera.x), 5, 20)
		love.graphics.print("Camera Y: "..tostring(camera.y), 5, 35)
		love.graphics.print("Camera SX: "..tostring(camera.scaleX), 5, 50)
		love.graphics.print("Camera SY: "..tostring(camera.scaleY), 5, 65)
		love.graphics.print("Shape: "..tostring(shapes[shape_selected]), 5, 80)
	elseif editor_state == "menu" then
		level_editor_menu_draw()
	end
end

function level_editor_mousex()
	return camera.x+(mousex*camera.scaleX)
end

function level_editor_mousey()
	return camera.y+(mousey*camera.scaleY)
end