require 'utilities.file_system'
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
require 'gamestates.level_editor.level_editor'
require 'gamestates.level_editor.level_editor_menu'
require 'discord.discord'

function love.load()
	discord_load()
	graphFont 		 = love.graphics.newFont('font/SourceSansPro-Bold.ttf', 12)
	click_sfx		 = love.audio.newSource('sfx/click.ogg',"static")
	gamestate        = "Main menu"
	selected_level   = "practice_game/default.oli"
	main_menu_load()
end

function love.mousereleased( x, y, button )
	mpressed = true
	pressedm = button
	--print("x","y")
	--print(x,y,"\n")
end

function love.keyreleased( key )
	kpressed = true
	pressedk = key
end

function love.keypressed( key )
	kdown = true
	kname = key
	if key == "escape" then click_sfx:play() end
end

function love.wheelmoved( x, y )
	if 		y > 0 then  mwheelup = true
	elseif  y < 0 then  mwheeldown = true
	end
end

function love.update(dt)
	discord_update()
	mousex = love.mouse.getX()
	mousey = love.mouse.getY()
	if      gamestate == "Main menu"    	 then  main_menu_update(dt)
	elseif  gamestate == "Playing"      	 then  playing_update(dt)
	elseif  gamestate == "Paused"       	 then  paused_update(dt)
	elseif  gamestate == "Level editor" 	 then  level_editor_update(dt)
	end
end

function love.draw()
	love.graphics.setFont(graphFont, 12)
	love.graphics.setColor(1,1,1,1)
	love.graphics.print(gamestate, love.graphics.getWidth()-80, love.graphics.getHeight()-20)
	if      gamestate == "Main menu"  	 	 then  main_menu_draw()
	elseif  gamestate == "Playing"    	 	 then  playing_draw()
	elseif  gamestate == "Paused"     	 	 then  paused_draw() 
	elseif  gamestate == "Level editor"  	 then  level_editor_draw() end
	love.graphics.setFont(graphFont, 12) 
	love.graphics.setColor(1,1,1,1)
    mpressed   = false
	kpressed   = false
	kdown      = false
    mwheeldown = false
    mwheelup   = false
end

function love.resize( w, h )
	if 	    gamestate == "Main menu" 		 then main_menu_resize(w, h)
	elseif  gamestate == "Paused"    		 then paused_resize(w, h)
	elseif  gamestate == "Level editor menu" then level_editor_menu_resize(w, h) 
	end
end

function love.quit()
	discord_quit()
end 

function round( n, p )
	return math.floor(n/p)*p
end