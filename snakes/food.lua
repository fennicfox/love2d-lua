food = {}

function food:load(x, y, r, g, b)
    local object = {
    x = x,
    y = y,
    r = r,
    g = g,
    b = b,
    radius = nil,
    segments = 40
}
    local food_size_chance = math.random()
    print(food_size_chance)
    if food_size_chance < .025 then
        object.radius = 6
    elseif food_size_chance < .05 then
        object.radius = 5
    elseif food_size_chance < .1 then
        object.radius = 4
    else
        object.radius = 3
    end

    table.insert(food, object)
    setmetatable(object, {__index = self})
    return object
end

function food.draw( )
    for i,v in ipairs(food) do
      love.graphics.setColor(v.r, v.g, v.b, 1)
      love.graphics.circle("fill", v.x, v.y, v.radius, v.segments)
    end
end

function food:respawn(x, y)
    self.x=math.random((x-2000),(x+2000))
    self.y=math.random((y-2000),(y+2000))
end

function draw_food( dt )
    food:draw(dt)
end


function UPDATE_FOOD( dt )
    food:update(dt)
end
