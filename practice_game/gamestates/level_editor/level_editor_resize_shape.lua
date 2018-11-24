--for resizing objects
local cs = 3 --corner size
local corner_hit = false
local corner_hit_nw = false
local corner_hit_ne = false
local corner_hit_sw = false
local corner_hit_se = false
local corner_nw_x = 0
local corner_nw_y = 0
local corner_ne_x = 0
local corner_ne_y = 0
local corner_sw_x = 0
local corner_sw_y = 0
local corner_se_x = 0
local corner_se_y = 0
local presspointx = 0
local presspointy = 0

function level_editor_resize_shape(selected)
	corner_hit = true
	if (level_editor_mousex() >= selected.x-cs and
                    level_editor_mousey() >=  selected.y-cs and
                    level_editor_mousex() <= selected.x+cs and
                    level_editor_mousey() <= selected.y+cs) or
	                corner_hit_nw and not corner_hit_ne and not corner_hit_se and not corner_hit_sw then
		corner_hit_nw = true
		corner_hit_ne = false
		corner_hit_sw = false
		corner_hit_se = false
		selected.x =  round(math.min(level_editor_mousex(),corner_ne_x-2), grid_lock_size)
		selected.w = corner_ne_x - selected.x
		selected.y =  round(math.min(level_editor_mousey(),corner_sw_y-2), grid_lock_size)
		selected.h = corner_sw_y - selected.y
	elseif (level_editor_mousex() >= (selected.x-cs)+selected.w and --top right
                    level_editor_mousey()    >= selected.y-cs and
                    level_editor_mousex()    <= (selected.x+cs)+selected.w and
                    level_editor_mousey()    <= selected.y+cs) or
	                corner_hit_ne and not corner_hit_nw and not corner_hit_sw and not corner_hit_se then
		corner_hit_nw = false
		corner_hit_ne = true
		corner_hit_sw = false
		corner_hit_se = false
		selected.w = math.max(round(level_editor_mousex()-selected.x, grid_lock_size), 1)
		selected.y =  round(math.min(level_editor_mousey(),corner_se_y-2), grid_lock_size)
		selected.h = corner_se_y - selected.y
	elseif (level_editor_mousex() >= selected.x-cs and								--bottom left
                    level_editor_mousey()    >= (selected.y-cs)+selected.h and
                    level_editor_mousex()    <= selected.x+cs and
                    level_editor_mousey()    <= (selected.y+cs)+selected.h) or
	                corner_hit_sw and not corner_hit_ne and not corner_hit_nw and not corner_hit_se  then
		corner_hit_nw = false
		corner_hit_ne = false
		corner_hit_sw = true
		corner_hit_se = false
		selected.h = math.max(round(level_editor_mousey()-selected.y, grid_lock_size), 1)
		selected.x =  round(math.min(level_editor_mousex(),corner_se_x-2), grid_lock_size)
		selected.w = corner_se_x - selected.x
	elseif (level_editor_mousex() >= (selected.x-cs)+selected.w and --bottom right
                    level_editor_mousey()    >= (selected.y-cs)+selected.h and
                    level_editor_mousex()    <= (selected.x+cs)+selected.w and
                    level_editor_mousey()    <= (selected.y+cs)+selected.h) or
                    corner_hit_se and not corner_hit_nw and not corner_hit_ne and not corner_hit_sw then
		corner_hit_nw = false
		corner_hit_ne = false
		corner_hit_sw = false
		corner_hit_se = true
		selected.w = math.max(round(level_editor_mousex()-selected.x, grid_lock_size), 1)
		selected.h = math.max(round(level_editor_mousey()-selected.y, grid_lock_size), 1)
	else
		corner_hit_nw = false
		corner_hit_ne = false
		corner_hit_sw = false
		corner_hit_se = false
	end
end

function level_editor_resize_shape_draw(selected)
    if selected ~= nil then
        love.graphics.setColor(1, 0.627, 0, alpha) -- default selected object in blender colour
        love.graphics.rectangle('line', selected.x, selected.y, selected.w, selected.h)
        love.graphics.rectangle('line', selected.x-1, selected.y-1, selected.w+2, selected.h+2)
        if love.keyboard.isDown('lctrl') then
            love.graphics.setColor(1, 0, 1, alpha) -- default selected object in blender colour
            love.graphics.rectangle('fill', selected.x-cs, selected.y-cs, cs*2, cs*2)   --top left
            love.graphics.rectangle('fill', (selected.x-cs)+selected.w, selected.y-cs, cs*2, cs*2) --top right
            love.graphics.rectangle('fill', selected.x-cs, (selected.y-cs)+selected.h, cs*2, cs*2) --bottom left
            love.graphics.rectangle('fill', (selected.x-cs)+selected.w, (selected.y-cs)+selected.h, cs*2, cs*2) --buttom right
        end
    end
end