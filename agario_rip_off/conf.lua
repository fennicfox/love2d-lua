function love.conf(t)
    t.identity = "main"                 -- The name of the save directory (string)
    t.appendidentity = true             -- Search files in source directory before save directory (boolean)
    t.version = "11.0"                  -- The LÖVE version this game was made for (string)
    t.modules.joystick = false  -- Enable the joystick module (boolean)
    t.modules.audio = true      -- Enable the audio module (boolean)
    t.modules.keyboard = true   -- Enable the keyboard module (boolean)
    t.modules.event = true      -- Enable the event module (boolean)
    t.modules.image = true      -- Enable the image module (boolean)
    t.modules.graphics = true   -- Enable the graphics module (boolean)
    t.modules.mouse = true      -- Enable the mouse module (boolean)
    t.modules.sound = true      -- Enable the sound module (boolean)
	t.modules.timer = true      -- Enable the timer module (boolean)
	t.modules.thread = true
	t.modules.math = true 		-- Enable the math module (boolean)
    t.modules.physics = true    -- Enable the physics module (boolean)
    t.console = false            -- Attach a console (boolean, Windows only)
    t.title = "Agario rip off"         -- The title of the window the game is in (string)
    t.author = "Oli Legg"     	    -- The author of the game (string)
    t.window.fullscreen = false -- Enable fullscreen (boolean)
    t.window.vsync = false      -- Enable vertical sync (boolean)
    t.window.fsaa = 16           -- The number of FSAA-buffers (number)
    t.window.msaa = 16           -- The number of samples to use with multi-sampled antialiasing (number)
    t.window.height = 1080      -- The window height (number)
    t.window.width = 1920       -- The window width (number)
    t.window.resizable = true         -- Let the window be user-resizable (boolean)
    t.window.minwidth = 800              -- Minimum window width if the window is resizable (number)
    t.window.minheight = 600             -- Minimum window height if the window is resizable (number)
    t.window.highdpi = true           -- Enable high-dpi mode for the window on a Retina display (boolean)
    t.window.srgb = true              -- Enable sRGB gamma correction when drawing to the screen (boolean)
    t.gammacorrect = true               -- Enable gamma-correct rendering, when supported by the system (boolean)
    math.randomseed(os.time()) --inserts the random module
end
