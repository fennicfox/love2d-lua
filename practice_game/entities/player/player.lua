player = {}

function player:create(x, y, w, h)
	self.__index = self
	player.friction = 5
	player.gravity = 2000
	return setmetatable({
		x=x or  0,
		y=y or  0,
		w=w or 20,
		h=h or 60,
		speed = 1500,
		xvel = 0,
		yvel = 0,
		jumpspeed = 900
	}, self)
end

function player:update(dt)
	if love.keyboard.isDown('a') then self.xvel = self.xvel - (self.speed * dt) end
	if love.keyboard.isDown('d') then self.xvel = self.xvel + (self.speed * dt) end
	if self.y+self.h >= love.graphics.getHeight() then
		self.yvel = 0
		self.y = love.graphics.getHeight()-self.h 
		if love.keyboard.isDown('w') then 
			self.yvel = self.yvel - self.jumpspeed
		end
	else
		self.yvel = self.yvel + (player.gravity * dt)
	end
end

function player:physics(dt)
	self.x = self.x + self.xvel * dt                              --moves the player if the velocity is not 0
	self.y = self.y + self.yvel * dt                              --moves the player if the velocity is not 0
	self.xvel = self.xvel * (1 - math.min(dt*player.friction, 1)) --slows the player down if they're moving
	self.yvel = self.yvel * (1 - math.min(dt*player.friction, 1)) --slows the player down if they're moving
	if self.xvel < 0.1 and self.xvel > -0.1 then                --hotfix for player not completely stopping when idle.
		self.xvel = 0
	end
end

function player:draw()
	love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
end