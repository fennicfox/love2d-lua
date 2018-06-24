camera = {}
camera.x = 0
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.friction = 5
camera.xvel = 0
camera.yvel = 0


function camera:set(dt)
	love.graphics.push()
	love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
	love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
	love.graphics.pop()
end

function camera:move(dx, dy)

	self.x = self.x * (1 - math.min(dt*camera.friction, 1))
	self.y = self.y * (1 - math.min(dt*camera.friction, 1))
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