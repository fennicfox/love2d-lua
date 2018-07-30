local panel_w = 250
local panel_h = love.graphics.get
local panel_open = false
local panel_friction = 5
local panel_xvel     = 0
local panel_yvel     = 0

function navigation_panel_update(dt)
    if panel_open then
        panel_w = 250
    else
        panel_w = 0
    end
end

function navigation_panel_draw()
    if panel_open then
        panel_h = love.graphics.getHeight()
        love.graphics.setColor(0, 0, 0, 0.9)
        love.graphics.rectangle("fill",0,0,panel_w,panel_h)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.line(panel_w,0,panel_w,panel_h)
    end
end

function navigation_panel_toggle()
    if panel_open then
        panel_open = false
    else
        panel_open = true
    end
end

function navigation_panel_isOpen()
    return panel_open
end

function navigation_panel_width()
    return panel_w
end