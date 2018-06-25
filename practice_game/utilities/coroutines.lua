infomessage = coroutine.create(
	function (time, text)
		running = false
		local infoFont = love.graphics.newFont('font/SourceSansPro-Light.ttf', 24)
		while true do
			local start_time = os.time()
			local elapsed_time = 0
			while elapsed_time <= time do
				running = true
				love.graphics.setColor(1, 1, 1, 1)
				love.graphics.setFont(infoFont, 24)
				love.graphics.print(text, love.graphics.getWidth()/2-(infoFont:getWidth( text ))/2, love.graphics.getHeight()/2-(infoFont:getHeight( text ) ))
				elapsed_time = os.time() - start_time
				coroutine.yield()
			end
			running = false
			coroutine.yield()
		end
	end
)

infomessage2 = coroutine.create(
	function (time, text1, text2)
		running = false
		local infoFont = love.graphics.newFont('font/SourceSansPro-Light.ttf', 24)
		while true do
			local start_time = os.time()
			local elapsed_time = 0
			while elapsed_time <= time do
				running = true
				love.graphics.setColor(1, 1, 1, 1)
				love.graphics.setFont(infoFont, 24)
				love.graphics.print(text1, love.graphics.getWidth()/2-(infoFont:getWidth( text1 ))/2, love.graphics.getHeight()/2-(infoFont:getHeight( text1 ) ))
				elapsed_time = os.time() - start_time
				coroutine.yield()
			end
			print("done")
			running = false
			coroutine.yield()
			local start_time = os.time()
			local elapsed_time = 0
			while elapsed_time <= time do
				running = true
				love.graphics.setColor(1, 1, 1, 1)
				love.graphics.setFont(infoFont, 24)
				love.graphics.print(text2, love.graphics.getWidth()/2-(infoFont:getWidth( text2 ))/2, love.graphics.getHeight()/2-(infoFont:getHeight( text2 ) ))
				elapsed_time = os.time() - start_time
				coroutine.yield()
			end
			running = false
			coroutine.yield()
		end
	end
)