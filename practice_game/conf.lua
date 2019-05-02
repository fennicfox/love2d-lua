function love.conf(t)
	t.modules.joystick  = false           -- Enable joystick module (boolean)
	t.modules.audio     = true            -- Enable audio module (boolean)
	t.modules.keyboard  = true            -- Enable keyboard module (boolean)
	t.modules.event     = true            -- Enable event module (boolean)
	t.modules.image     = true            -- Enable image module (boolean)
	t.modules.graphics  = true            -- Enable graphics module (boolean)
	t.modules.mouse     = true            -- Enable mouse module (boolean)
	t.modules.sound     = true            -- Enable sound module (boolean)
	t.modules.timer     = true            -- Enable timer module (boolean)
	t.modules.thread    = true            -- Enable thread module (boolean)
	t.modules.math      = false           -- Enable math module (boolean)
	t.modules.physics   = false           -- Enable physics module (boolean)
	t.console           = true            -- Console (boolean, Windows only)
	t.title             = "Practice Game" -- title of window (string)
	t.author            = "Oliver Legg"   -- author of game (string)
	t.window.fullscreen = false           -- Enable fullscreen (boolean)
	t.window.vsync      = true            -- Enable vertical sync (boolean)
	t.window.fsaa       = 16              -- number of FSAA-buffers (number)
	t.window.msaa       = 16              -- multisampled antialiasing (number)
	t.window.width      = 800             -- window width (number)
	t.window.height     = 600             -- window height (number)
	t.window.resizable  = true            -- window is user-resizable (boolean)
	t.window.minwidth   = 800             -- Minimum window width (number)
	t.window.minheight  = 600             -- Minimum window height (number)
	t.window.srgb       = true            -- sRGB gamma correction (boolean)
	--t.window.icon     = ""              -- Changes window icon
	math.randomseed(os.time())            -- Inserts random module
end
