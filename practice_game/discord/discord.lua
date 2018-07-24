local discordRPC = require "discord.discordRPC"
local appId = require "discord.applicationId"
local seconds_for_update = 2.0 --update rich presence on discord every 2.0 seconds.
deathsInSession = 0

-- config:
function discord_load()
    discordRPC.initialize(appId, true)
    local now = os.time(os.date("*t"))
    presence = {
        state = "Testing",
        details = "Fixing errors",
        startTimestamp = now,
        deaths = deathsInSession
    }

    nextPresenceUpdate = 0
end

function discord_update()
    if nextPresenceUpdate < love.timer.getTime() then
        discordRPC.updatePresence(presence)
        nextPresenceUpdate = love.timer.getTime() + seconds_for_update
    end
    discordRPC.runCallbacks()
end

function discord_quit()
    discordRPC.shutdown()
end



--discord stuff
function discordRPC.ready(userId, username, discriminator, avatar)
    print(string.format("Discord: ready (%s, %s, %s, %s)", userId, username, discriminator, avatar))
end

function discordRPC.disconnected(errorCode, message)
    print(string.format("Discord: disconnected (%d: %s)", errorCode, message))
end

function discordRPC.errored(errorCode, message)
    print(string.format("Discord: error (%d: %s)", errorCode, message))
end

function discordRPC.joinGame(joinSecret)
    print(string.format("Discord: join (%s)", joinSecret))
end

function discordRPC.spectateGame(spectateSecret)
    print(string.format("Discord: spectate (%s)", spectateSecret))
end

function discordRPC.joinRequest(userId, username, discriminator, avatar)
    print(string.format("Discord: join request (%s, %s, %s, %s)", userId, username, discriminator, avatar))
    discordRPC.respond(userId, "yes")
end

