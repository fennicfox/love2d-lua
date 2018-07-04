require 'utilities.coroutines'
require 'utilities.camera'
require 'utilities.button'
require 'utilities.button_commands'
require 'entities.player.player'
require 'entities.scenary.scenary'
require 'entities.zones.deathzone'
require 'entities.zones.winzone'
require 'gamestates.playing'
require 'gamestates.main_menu'
require 'gamestates.paused'
require 'gamestates.level_editor'
require 'gamestates.level_editor_menu'

function love.load()
	graphFont 		 = love.graphics.newFont('font/SourceSansPro-Bold.ttf', 12)
	click_sfx		 = love.audio.newSource('sfx/click.ogg',"static")
	gamestate        = "main_menu"
	main_menu_load()
end

function love.mousereleased( x, y, button )
	mpressed = true
	pressedm = button
end

function love.keyreleased( key )
	kpressed = true
	pressedk = key
end

function love.wheelmoved( x, y )
	if 		y > 0 then  mwheelup = true
	elseif  y < 0 then  mwheeldown = true
	end
end

function love.update(dt)
	mousex = love.mouse.getX()
	mousey = love.mouse.getY()
	if      gamestate == "main_menu"    	 then  main_menu_update(dt)
	elseif  gamestate == "playing"      	 then  playing_update(dt)
	elseif  gamestate == "paused"       	 then  paused_update(dt)
	elseif  gamestate == "level_editor" 	 then  level_editor_update(dt)
	end
end

function love.draw()
	love.graphics.setFont(graphFont, 12)
	love.graphics.setColor(1,1,1,1)
	love.graphics.print(gamestate, love.graphics.getWidth()-80, love.graphics.getHeight()-20)
	if      gamestate == "main_menu"  	 	 then  main_menu_draw()
	elseif  gamestate == "playing"    	 	 then  playing_draw()
	elseif  gamestate == "paused"     	 	 then  paused_draw() 
	elseif  gamestate == "level_editor"  	 then  level_editor_draw() end
	love.graphics.setFont(graphFont, 12) 
	love.graphics.setColor(1,1,1,1)
    mpressed   = false
    kpressed   = false
    mwheeldown = false
    mwheelup   = false
end

function love.keypressed( key )
	if key == "escape" then click_sfx:play() end
end

function love.resize( w, h )
	if 	    gamestate == "main_menu" 		 then main_menu_resize(w, h)
	elseif  gamestate == "paused"    		 then paused_resize(w, h)
	elseif  gamestate == "level_editor_menu" then level_editor_menu_resize(w, h) 
	end
end

function round( n, p )
	return math.floor(n/p)*p
end