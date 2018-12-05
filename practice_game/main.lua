-- Requiring all of these files into the main function.
-- I might change this to reduce the amount of used or variable conflicts
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
	-- Default testing font is useful for displaying information when debugging
	graphFont 		 = love.graphics.newFont('font/SourceSansPro-Bold.ttf', 12)
	click_sfx		 = love.audio.newSource('sfx/click.ogg',"static")
	gamestate        = "Main menu"				   
	selected_level   = "practice_game/default.oli"-- I should replace .oli with .json I didn't know .json existed till recently
	
	-- Loading starting methods
	discord_load()
	main_menu_load()
end

function love.mousereleased( x, y, button )
	mpressed = true								 -- True for one step when they release the mouse button
	pressedm = button							 -- The value that the player takes their finger off the mouse (lmb = 1 rmb = 2)
	--print("x","y")
	--print(x,y,"\n")
end

function love.keyreleased( key )
	kpressed = true 							 -- True for one step when the player takes their finger off a button
	pressedk = key 								 -- The value that the player takes their finger off 
end

function love.keypressed( key )
	kdown = true 								 -- True for one step when the player puts their finger on a button
	kname = key  								 -- The value that the player takes their finger off
	if key == "escape" then click_sfx:play() end -- I will remove this annoying sound in the future
end

function love.wheelmoved( x, y )
	if 		y > 0 then  mwheelup   = true
	elseif  y < 0 then  mwheeldown = true
	end
end

-- Processing
function love.update(dt)
	-- Faster to reference globally like this.
	mousex = love.mouse.getX()
	mousey = love.mouse.getY()
	
	-- Always displaying discord API
	discord_update()
	if      gamestate == "Main menu"    	 then  main_menu_update(dt)
	elseif  gamestate == "Playing"      	 then  playing_update(dt)
	elseif  gamestate == "Paused"       	 then  paused_update(dt)
	elseif  gamestate == "Level editor" 	 then  level_editor_update(dt)
	end
end

-- Graphics Processing
function love.draw()
	-- Always showing the current game state. This is useful for testing atm. I will change this later
	love.graphics.setFont(graphFont, 12)
	love.graphics.setColor(1,1,1,1)
	love.graphics.print(gamestate, love.graphics.getWidth()-80, love.graphics.getHeight()-20)
	if      gamestate == "Main menu"  	 	 then  main_menu_draw()
	elseif  gamestate == "Playing"    	 	 then  playing_draw()
	elseif  gamestate == "Paused"     	 	 then  paused_draw() 
	elseif  gamestate == "Level editor"  	 then  level_editor_draw() end
	love.graphics.setFont(graphFont, 12) 
	love.graphics.setColor(1,1,1,1)

	-- Everything at the end of love.draw will be processed last. Put data you want to be processed at the end of a step here.
	mpressed   = false
	kpressed   = false
	kdown      = false
	mwheeldown = false
	mwheelup   = false
end

-- When the window resizes, it is important that the GUI and general graphics scale with it.
function love.resize( w, h )
	if 	    gamestate == "Main menu" 		 then main_menu_resize(w, h)
	elseif  gamestate == "Paused"    		 then paused_resize(w, h)
	elseif  gamestate == "Level editor menu" then level_editor_menu_resize(w, h) 
	end
end

-- Upon quitting it is important that discord quits accordingly too.
-- I should make sure that level editor saves because quitting too.
function love.quit()
	discord_quit()
end 

-- I've made this function global because it's really useful in all parts of the game
function round( n, p )
	return math.floor(n/p)*p
end