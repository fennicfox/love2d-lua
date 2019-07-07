require "playing"
state = 0
PLAYING = 0
PAUSED  = 1

function love.load()
	playing.load()
end

function love.update( dt )
	if state == PLAYING then
		playing.update( dt )
	end
end

function love.draw()
	if state == PLAYING then
		playing.draw()
	end

	love.graphics.setColor(0.1, 1, 0.15, 1)
	love.graphics.print("Frames Per Second: "..
			math.floor( tostring( love.timer.getFPS( ) ) ),
			love.graphics.getWidth()-175,
			5
		)	
end

function love.mousepressed(x, y, key)

end

function love.mousereleased(x, y, key)

end