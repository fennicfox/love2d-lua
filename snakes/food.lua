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

