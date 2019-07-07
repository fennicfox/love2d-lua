snake_seg = {}

function snake_seg:create( x, y )
	local object = {
            size = 10,
			x=x,
			y=y,
			--colour = {math.random(), math.random(), math.random()},
			next = nil
	}
	table.insert(snake, object)
	setmetatable(object, { __index = self })
	return object
end

function snake_seg:update( dt )
    
end