function love.load()
    gui_x = 10
    gui_y = 10

    vx = 0
    vy = 0
    ivx = 0
    ivy = 0

    buffer = 0.001
    radius = 1000
    direction = 0

    points = {}
    point_selected = {}
    previous_point_selected = 1;
    rotation = 0
    modifier = 20

    lefts  = 0
    rights = 0

    sound = love.audio.newSource("snap1.wav", "static") -- the "static" tells LÖVE to load the file into memory, good for short sound effects
    for i = 1, 10 do
        points[i] = {}
        points[i] = {math.random(100,700), math.random(100,500), false}
    end
    point_selected = {points[1][1], points[1][2], 1}
    change(1)
end

function love.update(dt)
    rotation = (rotation + modifier * dt) % 360
    direction = rotation
    direction_x = math.cos(direction * math.pi / 180)
    direction_y = math.sin(direction * math.pi / 180)

    vx = point_selected[1]+(direction_x*radius)
    vy = point_selected[2]+(direction_y*radius)

    ivx = point_selected[1]+((-direction_x)*radius)
    ivy = point_selected[2]+((-direction_y)*radius)

    for i = 1, #points do
        if (i ~= point_selected[3] and 
           (i ~= previous_point_selected or #points <= 2)) then
            d1 = dist(
                points[i][1], 
                points[i][2], 
                point_selected[1], 
                point_selected[2]);
            d2 = dist(
                points[i][1], 
                points[i][2], 
                vx, 
                vy);
            if d1+d2 >= radius-buffer and d1+d2 <= radius+buffer then
                change(i)
                break
            end
            d2 = dist(points[i][1], points[i][2], ivx, ivy);
            if d1+d2 >= radius-buffer and d1+d2 <= radius+buffer then
                change(i)
                break
            end
        end
    end
    leftsAndRights(i)
end

function love.draw()

    love.graphics.setColor(1,1,1)
    love.graphics.line(point_selected[1], point_selected[2], vx, vy)
    love.graphics.line(point_selected[1], point_selected[2], ivx, ivy)

    love.graphics.setColor(0.0, 1.0, 0.0)
    love.graphics.print("Press 'Space' to reset",gui_x+0,gui_y+0)
    love.graphics.print("Rotation: "..math.floor(rotation, 16),gui_x+0,gui_y+16)
    love.graphics.setColor(0.5, 1.0, 0.5)
    love.graphics.print("Lefts: "   ..math.floor(lefts, 16),   gui_x+0,gui_y+32)
    love.graphics.setColor(1.0, 0.5, 0.5)
    love.graphics.print("Rights: "  ..math.floor(rights, 16),  gui_x+0,gui_y+48)
    
    -- Uncomment this to show 
    -- love.graphics.setColor(1,0,0)
    -- love.graphics.circle("fill", 
    --         points[previous_point_selected][1], 
    --         points[previous_point_selected][2], 
    --         8, 
    --         16)
    love.graphics.setColor(1,1,1)
    love.graphics.circle("fill", point_selected[1], point_selected[2], 4, 16)
    
    for i = 1, #points do

        if point_selected[3] == i then
            love.graphics.setColor(0, 0, 0)
        elseif points[i][3] then
            love.graphics.setColor(1, 0.5, 0.5)
        else
            love.graphics.setColor(0.5, 1, 0.5)
        end
        love.graphics.circle("fill", points[i][1], points[i][2], 3, 16)
    end 
end

function dist(x1, y1, x2, y2)
    return math.sqrt( (y2-y1)*(y2-y1) + (x2-x1)*(x2-x1) )
end

function change(i)
    previous_point_selected = point_selected[3]
    point_selected[1] = points[i][1]
    point_selected[2] = points[i][2]
    point_selected[3] = i
    playSound(sound)
    leftsAndRights(i)
end

function leftsAndRights(i)
    lefts  = 0
    rights = 0
    for p = 1, #points do
        if (p ~= point_selected[3]) then
            side = checkSide(
                vx, vy, 
                ivx, ivy, 
                points[p][1], points[p][2])
            if side > 0 then
                lefts = lefts + 1
                points[p][3] = false
            end
            if side < 0 then
                rights = rights + 1
                points[p][3] = true
            end
        end
    end
end

function checkSide(x1, y1, x2, y2, qx, qy)
    return ((x2 - x1) * (qy - y1)) - ((qx - x1) * (y2 - y1))
end

function playSound( source )

	local clone = source:clone()
	clone:play()

end

function love.keypressed(key)
    if key == "space" then
        love.load()
    end
end