food = {}

function food:load(x, y, r, g, b)
    local object = {
    x = x,
    y = y,
    r = r,
    g = g,
    b = b,
    radius = 3,
    segments = 40
}
    table.insert(food, object)
    setmetatable(object, {__index = self})
    return object
end


function food:update( dt )

    for i,v in ipairs(food) do
    --getting distance
        local xdistance = 0
        local ydistance = 0
        if v.x > player.x then
            xdistance = v.x - player.x
        else
            xdistance = player.x - v.x
    end

    if v.y > player.y then
        ydistance = v.y - player.y
    else
        ydistance = player.y - v.y
    end
    
    local distance = math.sqrt((math.pow(xdistance, 2) + math.pow(ydistance, 2)))
    if distance > 4000 then --if the distance is too far, then respawn
        food.i:respawn()
    end

    if (v.x-player.x)^2 + (player.y-v.y)^2 <= (player.r+v.radius)^2 then --if player hits food
        food.i:respawn()
        player.r=player.r+0.5 --increase the player's mass
    end


    end
end

function food:draw( dt )
    for i,v in ipairs(food) do
      love.graphics.setColor(v.r, v.g, v.b, 255)
      love.graphics.circle("fill", v.x, v.y, v.radius, v.segments)
    end
end

function food:respawn()
    v.x=math.random((player.x-2000),(player.x+2000))
    v.y=math.random((player.x-2000),(player.x+2000))
end

function draw_food( dt )
    food:draw(dt)
end


function UPDATE_FOOD( dt )
    food:update(dt)
end

