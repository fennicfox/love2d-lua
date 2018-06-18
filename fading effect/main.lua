
function rn()
	return zero_point( math.random (0, 100000000) )
end

function zero_point(n)
	if n > 1 then
		return zero_point(n/10)
	else
		return n
	end
end

x  = 0
random_c = {rn(),rn(),rn()}
flashing_speed = 1 --lower is faster
cooldown = false

function love.update(dt)
	if x < 1 and not cooldown then
		x = (x + (dt/flashing_speed))
		if x > 1 then
			cooldown = true
		end
	else
		x = (x - (dt/flashing_speed))
		if x < 0 then
			cooldown = false
			random_c = {rn(), rn(), rn()}
		end
	end
end

function love.draw()
	for i = 0, 100 do
		for y = 0, 100 do
			random_c[4] = x
			love.graphics.setColor(random_c)
			love.graphics.print("I love Sarah. ", i*80,y*11)
		end
	end
end

