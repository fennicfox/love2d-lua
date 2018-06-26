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
|  'g' enables/disables grid
|  'b' enables/disables grid lock
|  'x' removes placements
|  
|  'escape' pauses the game
|  
|  'lmb' places scenary
|  'rmb' places player spawns
| 
|  'mwheelup' / 'mwheeldown' switches between different shapes (not implemented yet)
]]--


editor_graphics = {}
editor_graphics.w = 50
editor_graphics.h = 50
editor_state = "main"

local shapes = {}          --future plans for different shapes.
local shape_selected = 1   --shape index
local grid_spacing = 50
local grid = true
local grid_lock = true
local grid_lock_size = 5

--for player spawn
local flashing_speed = 1 --lower is faster
local cooldown = false
local alpha = 0

table.insert(shapes, "rectangle")
table.insert(shapes, "triangle")
table.insert(shapes, "player")


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

function level_editor_update(dt) -- love.graphics.polygon( mode, vertices )
	if editor_state == "main" then
		print(pressedm)
		if mpressed then
			if pressedm == 1 then
				if shape_selected == 1 then
					editor_graphics:createRectangle(round(mousex-(editor_graphics.w)/2, grid_lock_size), round(mousey-(editor_graphics.h)/2, grid_lock_size), editor_graphics.w, editor_graphics.h, 1, 1, 1)
				elseif shape_selected == 3 then
					editor_graphics:createPlayer(round(mousex-(editor_graphics.w)/2, grid_lock_size), round(mousey-(editor_graphics.h)/2, grid_lock_size), 30, 50, 1, 1, 1)
				end
			end

		end
	
		if mwheelup then
			if shape_selected == #shapes then shape_selected = 1
			else shape_selected = shape_selected + 1 end
		elseif mwheeldown then
			if shape_selected == 1 then shape_selected = #shapes
			else shape_selected = shape_selected - 1 end
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
			elseif pressedk == 'x' then
				for i, v in ipairs(editor_graphics) do
					if mousex > v.x and mousex < v.x+v.w and mousey > v.y and mousey < v.y + v.h then
						table.remove(editor_graphics, i)
					end
				end
			elseif pressedk == 'escape' then 
				editor_state = "menu"
				level_editor_menu_load( )
			elseif pressedk == '-' then
				if editor_graphics.w ~= 6.25 and editor_graphics.h ~= 6.25 then editor_graphics.w = editor_graphics.w - 6.25 editor_graphics.h = editor_graphics.h - 6.25     end
			elseif pressedk == '=' then
				if editor_graphics.w ~= 100 and editor_graphics.h ~= 100 then editor_graphics.w = editor_graphics.w + 6.25 editor_graphics.h = editor_graphics.h + 6.25 end
			elseif pressedk == '[' then
				if grid_spacing ~= 12.5   then grid_spacing = grid_spacing - 12.5												   								  end
			elseif pressedk == ']' then
				if grid_spacing ~= 100    then grid_spacing = grid_spacing + 12.5												   								  end
			end
		end
	elseif editor_state == "menu" then
		level_editor_menu_update( dt )
	end

	--flashing effect for player (ignore and don't change)
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
	if editor_state == "main" then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setFont(graphFont)
		love.graphics.print("Frames Per Second: "..math.floor(tostring(love.timer.getFPS( ))), (love.graphics.getWidth()-130), 5)	--x and y of player and food
		love.graphics.print("Grid Spacing: "..tostring(grid_spacing), 5, 5)
		love.graphics.print("Width: "..tostring(editor_graphics.w), 5, 20)
		love.graphics.print("Height: "..tostring(editor_graphics.h), 5, 35)
		love.graphics.print("Shape: "..tostring(shapes[shape_selected]), 5, 50)
		love.graphics.setColor(0.2, 0.2, 0.2, 0.47)
		if shape_selected == 3 then --if player is selected
			love.graphics.rectangle('line', round(mousex-(editor_graphics.w)/2, grid_lock_size), round(mousey-(editor_graphics.h)/2, grid_lock_size), 30, 50)
		else
			love.graphics.rectangle('fill', round(mousex-(editor_graphics.w)/2, grid_lock_size), round(mousey-(editor_graphics.h)/2, grid_lock_size), editor_graphics.w, editor_graphics.h)
		end
		love.graphics.setColor(0.4,0.4,0.4,0.47)
		love.graphics.setLineWidth( 1 )
		if grid then -- if the grid is true then draw the grid!
			for i=0, love.graphics.getWidth()/10 do
				love.graphics.line(i*grid_spacing, 0, grid_spacing*i, love.graphics.getHeight()) -- vertical lines
			end
			for i=0, love.graphics.getHeight()/10 do
				love.graphics.line(0, i*grid_spacing, love.graphics.getWidth(), grid_spacing*i) -- horizontal lines
			end
		end
		if #editor_graphics > 0 then
			for i, v in ipairs(editor_graphics) do
				love.graphics.setColor(v.r, v.g, v.b)
				if v.s == "rectangle" then
					love.graphics.rectangle('fill', v.x, v.y, v.w, v.h)
				elseif v.s == "player" then
					love.graphics.setColor(v.r, v.g, v.b, alpha)
					love.graphics.rectangle('line', v.x, v.y, v.w, v.h)
				end
			end
		end
	elseif editor_state == "menu" then
		level_editor_menu_draw()
	end
end