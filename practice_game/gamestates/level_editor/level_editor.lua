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
|
|  'n' reveals the navigation pane
|
]]--

require 'gamestates.level_editor.level_editor_navigation_panel'
require 'gamestates.level_editor.level_editor_resize_shape'
require 'gamestates.level_editor.le_buttons.le_button'

editor_graphics = {}
editor_graphics.w = 50 --the width  of the things being put down
editor_graphics.h = 50 --the height of the things being put down
editor_graphics.selected = nil
editor_state = "main"

local shapes = {}
local shape_selected = 1   --shape index

-- Grid Variables
grid_spacing = 50
grid = true
grid_lock = true
grid_lock_size = editor_graphics.w / 2

-- Settings for the shape being drawn
local drawing_start_x = 0
local drawing_start_y = 0
local drawing_w = editor_graphics.w
local drawing_h = editor_graphics.h
local drawing_x = 0
local drawing_y = 0

-- For player, selected objects and death zone fading
local flashing_speed = 1 --lower is faster
local cooldown = false
local alpha = 0

-- For scrolling around the universe (not to confuse with zooming)
local scrolling_x = 0
local scrolling_y = 0
local scrolling_has_got = false
local rmb_x = mousex
local rmb_y = mousey

-- Inserting different shapes names into the table.
table.insert(shapes, "rectangle")
table.insert(shapes, "player")
table.insert(shapes, "death_zone")
table.insert(shapes, "win_zone")
--table.insert(shapes, "triangle")

-- Panel state
panel_state = "Navigation Panel"

-- Used to make navigation panel push UI to the right
screen_left = 0

-- Level editor buttons (I made the variable names short because the line was too long)
local button_navigation = {}
local b_fc = function() -- Button function
				 panel_state = "Navigation Panel"
                 navigation_panel_toggle() 
			 end 
local b_t_c = {0.0, 0.0, 0.0, 1.0}          -- Button text colour
local b_c   = {1.0, 1.0, 1.0, 1.0}          -- Button colour
local b_b_c = {0.4, 0.4, 0.4, 1.0}          -- Button background colour
local b_f  = "font/SourceSansPro-Light.ttf" -- Button font
local b_fs = 24                             -- Button font size
local wh = love.graphics.getHeight()-15     -- Window Height
table.insert( button_navigation, le_button:create(screen_left-2, wh, b_t_c,  b_c, b_b_c, b_f, b_fs, "N", b_fc))

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
		if love.mouse.isDown(1) and not presspointgot then
			presspointx = level_editor_mousex()
			presspointy = level_editor_mousey()
			presspointgot = true
		elseif not love.mouse.isDown(1) then
			presspointgot = false
		end
		if love.mouse.isDown(2) or love.mouse.isDown(3) then
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

			end
			if pressedm == 2 then
				if mousex == rmb_x and mousey == rmb_y then
					for i, v in ipairs(editor_graphics) do
						if level_editor_mousex() > v.x and level_editor_mousex() < v.x+v.w and level_editor_mousey() > v.y and level_editor_mousey() < v.y + v.h then
							editor_graphics.selected = editor_graphics[i]
							corner_nw_x = editor_graphics.selected.x
							corner_nw_y = editor_graphics.selected.y
							corner_ne_x = editor_graphics.selected.x + editor_graphics.selected.w
							corner_ne_y = editor_graphics.selected.x 
							corner_sw_x = editor_graphics.selected.x
							corner_sw_y = editor_graphics.selected.y + editor_graphics.selected.h
							corner_se_x = editor_graphics.selected.x + editor_graphics.selected.w
							corner_se_y = editor_graphics.selected.y + editor_graphics.selected.h
						end
					end
				end
			end
		elseif love.mouse.isDown(1) and not drawing_start_got and not love.keyboard.isDown('lctrl') and level_editor_canPlace() then
				drawing_start_got = true
				drawing_start_x = round((level_editor_mousex())-(editor_graphics.w/2), grid_lock_size)
				drawing_start_y = round((level_editor_mousey())-(editor_graphics.h/2), grid_lock_size)
				drawing_x = drawing_start_x
				drawing_y = drawing_start_y
		elseif love.mouse.isDown(1) and not love.keyboard.isDown('lctrl') and level_editor_canPlace()  then
			if level_editor_mousex() < drawing_start_x then
				drawing_x = math.min(round(level_editor_mousex(), grid_lock_size), drawing_start_x-editor_graphics.w)
				drawing_w = (drawing_start_x-drawing_x) + editor_graphics.w
			else
				drawing_x = drawing_start_x
				drawing_w = math.max(round(level_editor_mousex()-drawing_start_x, grid_lock_size), editor_graphics.w)
			end
			if level_editor_mousey() < drawing_start_y then
				drawing_y = math.min(round(level_editor_mousey(), grid_lock_size), drawing_start_y-editor_graphics.h) 
				drawing_h = (drawing_start_y - drawing_y) + editor_graphics.h
			else
				drawing_y = drawing_start_y
				drawing_h = math.max(round(level_editor_mousey()-drawing_start_y, grid_lock_size), editor_graphics.h)
			end
		elseif drawing_start_got and not love.keyboard.isDown('lctrl') and level_editor_canPlace() then
			drawing_start_got = false
			if shape_selected == 1 then
				editor_graphics:createRectangle(drawing_x, drawing_y, drawing_w, drawing_h, 1, 1, 1)
			elseif shape_selected == 3 then --player
				editor_graphics:createPlayer(round((level_editor_mousex())-(drawing_w/2), grid_lock_size), round((level_editor_mousey())-(drawing_h/2), grid_lock_size), 30, 50, 1, 1, 1)
			elseif shape_selected == 4 then
				editor_graphics:death_zone(drawing_x, drawing_y, drawing_w, drawing_h)
			elseif shape_selected == 5 then
				editor_graphics:win_zone(drawing_x, drawing_y, drawing_w, drawing_h)
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
			elseif pressedk == 'n' then
				panel_state = "Navigation Panel"
				navigation_panel_toggle()
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
					if editor_graphics.selected == editor_graphics[i] then
						editor_graphics.selected = nil
					end
					table.remove(editor_graphics, i)
				end
			end
		end
		if love.keyboard.isDown('lctrl') then
			if love.mouse.isDown(1) then
				level_editor_resize_shape(editor_graphics.selected)
			else
				corner_hit = false
				corner_hit_ne = false
				corner_hit_nw = false
				corner_hit_se = false
				corner_hit_sw = false
			end
		else
			corner_hit = false
			corner_hit_ne = false
			corner_hit_nw = false
			corner_hit_se = false
			corner_hit_sw = false
		end
		navigation_panel_update( dt )
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
			for i = xongrid, (xongrid + (winWidth* camera.scaleX)+grid_spacing), grid_spacing do 
				love.graphics.line(i, yongrid, i, yongrid+(winHeight*camera.scaleY)+grid_spacing) -- vertical lines
			end
			--lines going across
			for i = yongrid, (yongrid + (winHeight * camera.scaleY)+grid_spacing), grid_spacing do	
				love.graphics.line(xongrid, i, xongrid+(winWidth*camera.scaleX)+grid_spacing, i) -- horizontal lines
			end
		end
		love.graphics.setColor(0.2, 0.2, 0.2, 0.47)
		if not love.keyboard.isDown('lctrl') and not love.mouse.isDown(1) and level_editor_canPlace() then
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
		level_editor_resize_shape_draw(editor_graphics.selected)
		if drawing_start_got then
			love.graphics.setColor(1,1,1,1)
			love.graphics.rectangle('fill',drawing_x,drawing_y,drawing_w,drawing_h)
		end
		camera:unset()

		-- Draw buttons
		for i = 1, #button_navigation do
			button_navigation[i]:changePos(screen_left-2, love.graphics.getHeight()-button_navigation[i].box_wh)
			button_navigation[i]:show()
		end
		navigation_panel_draw()
		
		-- Draw selected bar
		love.graphics.setColor(0, 0, 0, 0.5)
		love.graphics.rectangle("fill", screen_left, 0, 100, 100)
		love.graphics.setColor(0.3, 0.3, 0.3, 0.47)
		love.graphics.rectangle("line", screen_left, 0, 100, 100)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setFont(graphFont)
		love.graphics.print("Grid Spacing: "..tostring(grid_spacing), screen_left+5, 5)
		love.graphics.print("Camera X: "..tostring(camera.x), screen_left+5, 20)
		love.graphics.print("Camera Y: "..tostring(camera.y), screen_left+5, 35)
		love.graphics.print("Camera SX: "..tostring(camera.scaleX), screen_left+5, 50)
		love.graphics.print("Camera SY: "..tostring(camera.scaleY), screen_left+5, 65)
		love.graphics.print("Shape: "..tostring(shapes[shape_selected]), screen_left+5, 80)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print("Frames Per Second: "..math.floor(tostring(love.timer.getFPS( ))), (love.graphics.getWidth()-130), 5)	--x and y of player and food
	elseif editor_state == "menu" then
		level_editor_menu_draw()
	end
end

-- If the mouse is over a bit of UI then they can't place objects
function level_editor_canPlace()
	if mousex < screen_left then
		return false
	end
	for i = 1, #button_navigation do
		if button_navigation[i]:mouseIsHovering() then
			return false
		end
	end
	return true
end

function level_editor_mousex()
	return camera.x+(mousex*camera.scaleX)
end

function level_editor_mousey()
	return camera.y+(mousey*camera.scaleY)
end