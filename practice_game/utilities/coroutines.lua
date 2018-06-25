infomessage = coroutine.create(function (time, text)
		local elapsed_time = 0
		local infoFont = love.graphics.newFont('font/SourceSansPro-Light.ttf', 24)
		local start_time = os.time()
		while elapsed_time <= time do
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.setFont(infoFont, 24)
			love.graphics.print(text, love.graphics.getWidth()/2-(infoFont:getWidth( text ))/2, love.graphics.getHeight()/2-(infoFont:getHeight( text ) ))
			elapsed_time = os.time() - start_time
			coroutine.yield()
		end
	end
)