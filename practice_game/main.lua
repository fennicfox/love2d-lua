
-- TO DO:
-- 	- make collisions with blocks better
-- 	- make a way for the player climb up hills
-- 	- the player should rotate to the angle that the hills are
-- 	- need to implement some kind of grapple hook


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
	graphFont        = love.graphics.newFont('font/SourceSansPro-Bold.ttf', 12)
	click_sfx        = love.audio.newSource('sfx/click.ogg',"static")
	gamestate        = "Main menu"
	selected_level   = "practice_game/default.oli"-- replace .oli with .json

	-- Loading starting methods
	discord_load()
	main_menu_load()
end

function love.mousereleased( x, y, button )
	mpressed = true   -- True for one step when they release the mouse button
	pressedm = button -- btn the player stops pressing (lmb = 1 rmb = 2)
	--print("x","y")
	--print(x,y,"\n")
end

function love.keyreleased( key )
	kpressed = true  -- True for one step if player stops pressing a key
	pressedk = key   -- The value that the player takes their finger off
end

function love.keypressed( key )
	kdown = true          -- True for one step when player presses a key
	kname = key           -- The value that the player takes their finger off
	if key == "escape" then
		click_sfx:play()  -- I will remove this annoying sound in the future
	end
end

function love.wheelmoved( x, y )
	if      y > 0 then  mwheelup   = true
	elseif  y < 0 then  mwheeldown = true
	end
end

-- Processing
function love.update(dt)
	-- Faster to reference globally like this
	mousex = love.mouse.getX()
	mousey = love.mouse.getY()

	-- Always displaying discord API
	discord_update()

	-- Updating the game state which should be being processed
	if      gamestate == "Main menu"         then  main_menu_update(dt)
	elseif  gamestate == "Playing"           then  playing_update(dt)
	elseif  gamestate == "Paused"            then  paused_update(dt)
	elseif  gamestate == "Level editor"      then  level_editor_update(dt)
	end
end

-- Graphics Processing
function love.draw()
	local screenWidth = love.graphics.getWidth()
	local screenHeight = love.graphics.getHeight()

	-- Always showing the current game state.
	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(graphFont, 12)
	love.graphics.print(gamestate, screenWidth-80, screenHeight-20)

	-- The right processing for the right states
	if      gamestate == "Main menu"         then  main_menu_draw()
	elseif  gamestate == "Playing"           then  playing_draw()
	elseif  gamestate == "Paused"            then  paused_draw()
	elseif  gamestate == "Level editor"      then  level_editor_draw() end

	-- Everything at the end of love.draw is processed at the end of a cycle
	-- Put data you want to be processed at the end of a step here.
	mpressed   = false
	kpressed   = false
	kdown      = false
	mwheeldown = false
	mwheelup   = false
end

-- If the window resizes, it's important that graphics scale with it.
function love.resize( w, h )
	if      gamestate == "Main menu"         then main_menu_resize(w, h)
	elseif  gamestate == "Paused"            then paused_resize(w, h)
	elseif  gamestate == "Level editor menu" then level_editor_menu_resize(w, h)
	end
end


-- Upon quitting it is important that discord quits accordingly too.
-- I should make sure that level editor saves before quitting too.
function love.quit()
	discord_quit()
end

-- This function is global because it's really useful in all parts of the game
function round( n, p )
	local remainder = n % p
	if    remainder > p/2 then return n + (p - remainder)
	else  return n - remainder
	end
end