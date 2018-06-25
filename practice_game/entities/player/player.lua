player = {}

function player:create(x, y, w, h)
	self.__index = self
	player.friction = 6
	player.gravity = 2500
	return setmetatable({
		x=x or  0,
		y=y or  0,
		w=w or 20,
		h=h or 60,
		speed = 1500,
		xvel = 0,
		yvel = 0,
		jumpspeed = 100
	}, self)
end

function player:update(dt)
	if love.keyboard.isDown('a') then self.xvel = self.xvel - (self.speed * dt) end
	if love.keyboard.isDown('d') then self.xvel = self.xvel + (self.speed * dt) end
	if self.y+self.h+1 > love.graphics.getHeight() then 
		self.y = love.graphics.getHeight()-self.h 
		if love.keyboard.isDown('w') then 
			self.yvel = self.yvel - (self.jumpspeed * dt) 
		end
	else
	    self.yvel = self.yvel + player.gravity * dt 
	end
end

function player:physics(dt)
	self.x = self.x + self.xvel * dt
	self.y = self.y + self.yvel * dt
	self.xvel = self.xvel * (1 - math.min(dt*player.friction, 1))
	self.yvel = self.yvel * (1 - math.min(dt*player.friction, 1))
end

function player:draw()
	love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
end