spike = {}

function spike:load()
	local object = {
			x=math.random(1000),
			y=math.random(1000),
			size = 75,
			fedcapactiy = 0
	}
	table.insert(spike, object)
	setmetatable(object, { __index = self })
	return object
end

function spike:update( dt )
	for i, v in ipairs(spike) do

	end
end


function spike:draw( )
	for i, v in ipairs(spike) do
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.polygon( "fill", v.x-v.size/2, v.y, v.x, v.y+v.size/2, v.x+v.size/2, v.y, v.x, v.y-v.size/2 )
		love.graphics.polygon( "fill", v.x-v.size/3, v.y-v.size/3, v.x+v.size/3, v.y-v.size/3, v.x+v.size/3, v.y+v.size/3, v.x-v.size/3, v.y+v.size/3)
	end
end

function spike:respawn()
	v.x=math.random(1,1000)
	v.y=math.random(1,1000)
end

function UPDATE_SPIKE( dt )
	spike:draw()
	spike:update(dt)
end
