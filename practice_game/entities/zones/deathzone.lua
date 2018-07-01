deathzone = {}

function deathzone:create(x, y, w, h)
	local object = {
    t = "zone_death",
 	x = x,
    y = y,
    w = w,
    h = h
}
	table.insert(deathzone, object)
	setmetatable(object, {__index = self})
	return object
end

function deathzone:update(dt)

end

function deathzone:collided(x,y,w,h)
    if (((x+w > self.x) and (x+w) < (self.x+self.w)) or 
        ((x > self.x) and (x < self.x+self.w))) and
        (((y+h > self.y) and (y+h) < (self.y+self.h)) or 
        ((y > self.y) and (y < self.y+self.h))) then 
        return true
    end
    return false
end



function deathzone:draw()
    for i, v in ipairs(scenary) do
        love.graphics.setColor(1,0.2,0.2,0.4)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end
end
