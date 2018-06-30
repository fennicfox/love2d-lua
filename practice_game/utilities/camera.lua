camera 			= {}
camera.x 		= 0
camera.y 		= 0
camera.scaleX   = 1
camera.scaleY   = 1
camera.friction = 4
camera.xvel     = 0
camera.yvel     = 0


function camera:set()
	love.graphics.push()
	love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
	love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
	love.graphics.pop()
end

function camera:move(xv,yv, dt)
	local xv2 = math.abs(xv)
	local yv2 = math.abs(yv)
	if xv < 0 then
		self.xvel = self.xvel - (xv2*dt)
	end
	if xv > 0 then
		self.xvel = self.xvel + (xv2*dt)
	end
	if yv < 0 then
		self.yvel = self.yvel - (yv2*dt)
	end
	if yv > 0 then
		self.yvel = self.yvel + (yv2*dt)
	end

	self.x = self.x + self.xvel * dt                              --moves the player if the velocity is not 0
	self.y = self.y + self.yvel * dt                              --moves the player if the velocity is not 0
	self.xvel = self.xvel * (1 - math.min(dt*self.friction, 1)) 
	self.yvel = self.yvel * (1 - math.min(dt*self.friction, 1))

	if self.xvel > -0.1 and self.xvel < 0.1 then
		self.xvel = 0
	end
	if self.yvel > -0.1 and self.yvel < 0.1 then
		self.yvel = 0
	end
end

function camera:scale(sx, sy)
sx = sx or 1
self.scaleX = self.scaleX * sx
self.scaleY = self.scaleY * (sy or sx)
end

function camera:setPosition(x, y)
self.x = x or self.x
self.y = y or self.y
end

function camera:setScale(sx, sy)
self.scaleX = sx or self.scaleX
self.scaleY = sy or self.scaleY
end
