winzone = {}

function winzone:create(x, y, w, h)
	local object = {
 	x = x,
    y = y,
    w = w,
    h = h
}
	table.insert(winzone, object)
	setmetatable(object, {__index = self})
	return object
end

function winzone_collided(entity)
    for i, v in ipairs(winzone) do
        if (((entity.x+entity.w > v.x) and (entity.x+entity.w) < (v.x+v.w)) or 
            ((entity.x > v.x) and (entity.x < v.x+v.w))) and
            (((entity.y+entity.h > v.y) and (entity.y+entity.h) < (v.y+v.h)) or 
            ((entity.y > v.y) and (entity.y < v.y+v.h))) then 
            return true
        end
    end
    return false
end