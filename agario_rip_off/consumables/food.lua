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
   if (v.x-player.x)^2 + (player.y-v.y)^2 <= (player.r+v.radius)^2 then
     print("hit")
     v.x=math.random((player.x-2000),(player.x+2000))
     v.y=math.random((player.x-2000),(player.x+2000))
     player.r=player.r+0.5
   end


  end
end

function food:draw( dt )
  for i,v in ipairs(food) do
    love.graphics.setColor(v.r, v.g, v.b, 255)
    love.graphics.circle("fill", v.x, v.y, v.radius, v.segments)
  end
end

function draw_food( dt )
   food:draw(dt)
end


function UPDATE_FOOD( dt )
   food:update(dt)
end

