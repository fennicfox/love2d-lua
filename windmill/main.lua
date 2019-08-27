
-- This visual is based on the 52nd International Mathematical Olympiad (C3)
-- https://www.imo-official.org/problems/IMO2011SL.pdf
-- 
-- C3
-- Let S be a finite set of at least two points in the plane. Assume that no 
-- three points of S are collinear. By a windmill we mean a process as follows. 
-- Start with a line ℓ going through a point P ∈ S. Rotate ℓ clockwise around 
-- the pivot P until the line contains another point Q of S. The point Q now 
-- takes over as the new pivot. This process continues indefinitely, with
-- the pivot always being a point from S. Show that for a suitable P ∈ S and a 
-- suitable starting line ℓ containing P, the resulting windmill will visit each
-- point of S as a pivot infinitely often.
--
-- 
-- Coded by Oliver Legg
-- Inspired by 3Blue1Brown (https://www.youtube.com/watch?v=M64HUIJFTZM)

function love.load()
    -- margin for the gui
    gui_x = 10
    gui_y = 10

    -- The windmill endpoint lines
    vx  = 0
    vy  = 0
    ivx = 0
    ivy = 0

    -- The line hitbox size, line length and line directio
    buffer    = 0.001
    radius    = 1000
    direction = 0

    -- The points and the point selected
    points = {}
    point_selected = {}
    previous_point_selected = 1;

    -- The rotation of the line and the speed at which it rotates
    rotation = 0
    modifier = 20

    -- The number of points on the left and right of the windmill
    lefts  = 0
    rights = 0

    -- Creation of sound (for fun)
    sound = love.audio.newSource("snap1.wav", "static")

    -- Creates all the the points (randomly)
    for i = 1, 10 do
        points[i] = {}
        points[i] = {math.random(100,700), math.random(100,500), false}
    end

    -- Create points randomly and assign to a random point
    createPoints()
end

function love.update(dt)
    -- sets the rotation of the line correctly
    rotation = (rotation + modifier * dt) % 360
    direction = rotation
    direction_x = math.cos(direction * math.pi / 180)
    direction_y = math.sin(direction * math.pi / 180)

    -- Sets the end points for the lines
    vx = point_selected[1]+(direction_x*radius)
    vy = point_selected[2]+(direction_y*radius)
    ivx = point_selected[1]+((-direction_x)*radius)
    ivy = point_selected[2]+((-direction_y)*radius)

    -- Checks to see when the lines intersect the points
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

    -- Checks to see what is on the left of the line and what is on the right
    leftsAndRights(i)
end

function love.draw()

    -- Draws the windmill
    love.graphics.setColor(1,1,1)
    love.graphics.line(point_selected[1], point_selected[2], vx, vy)
    love.graphics.line(point_selected[1], point_selected[2], ivx, ivy)

    --Draws the GUI
    love.graphics.setColor(0.0, 1.0, 0.0)
    love.graphics.print("Press 'Space' to reset",gui_x+0,gui_y+0)
    love.graphics.print("Rotation: "..math.floor(rotation, 16),gui_x+0,gui_y+16)
    love.graphics.setColor(0.5, 1.0, 0.5)
    love.graphics.print("Lefts: "   ..math.floor(lefts, 16),   gui_x+0,gui_y+32)
    love.graphics.setColor(1.0, 0.5, 0.5)
    love.graphics.print("Rights: "  ..math.floor(rights, 16),  gui_x+0,gui_y+48)
    
    -- Shows the previous point
    love.graphics.setColor(0.5,0.5,1)
    love.graphics.circle("fill", 
            points[previous_point_selected][1], 
            points[previous_point_selected][2], 
            4, 
            32)

    -- Highlights the point selected
    love.graphics.setColor(1,1,1)
    love.graphics.circle("fill", point_selected[1], point_selected[2], 4, 16)
    
    -- Draws all of the points
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

-- Euclidean distance function between 2 points in r^2
function dist(x1, y1, x2, y2)
    return math.sqrt( (y2-y1)*(y2-y1) + (x2-x1)*(x2-x1) )
end

-- Run when you want to switch selected point (pass i as the index of the point)
function change(i)
    previous_point_selected = point_selected[3]
    point_selected[1] = points[i][1]
    point_selected[2] = points[i][2]
    point_selected[3] = i
    playSound(sound)
    leftsAndRights(i)
end

-- Checks to see what is on the left of the line and what is on the right
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

-- Sets points to random positions
function createPoints()
    for i = 1, 10 do
        points[i] = {}
        points[i] = {math.random(100,700), math.random(100,500), false}
    end
    point_selected = {points[1][1], points[1][2], 1}
end

-- Uses determinant to check if the point is on the left, right or on the line
-- [(x2 - x1), (x3 - x1)]
-- [(y2 - y1), (y3 - y1)]
function checkSide(x1, y1, x2, y2, qx, qy)
    return ((x2 - x1) * (qy - y1)) - ((qx - x1) * (y2 - y1))
end

-- Used to create a thread when making sound (so they can overlap)
function playSound( source )

	local clone = source:clone()
	clone:play()

end

-- When you press a button, this function runs
function love.keypressed(key)

    -- If you press space, the points reset to random positions again
    if key == "space" then
        createPoints()
    end
end