local discordRPC = require "discord.discordRPC"
local appId = require "discord.applicationId"
local seconds_for_update = 2.0 --update rich presence on discord every 2.0 seconds.
deathsInSession = 0
gamestate = ""

-- config:
function discord_load()
    discordRPC.initialize(appId, true)
    local now = os.time(os.date("*t"))
    presence = {
        state = "Testing",
        details = "Fixing errors",
        startTimestamp = now,
        details = "Died "..deathsInSession.." times",
        smallImageKey = "dominant_male_512x512_jpg",
        smallImageText = "monkey",
        largeImageKey = "dominant_male_1024x1024_jpg",
        largeImageText = "monkey",
        state = gamestate
    }

    nextPresenceUpdate = 0
end

function discord_update()
    if nextPresenceUpdate < love.timer.getTime() then
        if deathsInSession == 0 then
            presence.details = "Deaths = 0 😎"
        elseif deathsInSession == 1 or deathsInSession == 2 then
            presence.details = "Deaths = "..deathsInSession.." 👍"
        elseif deathsInSession >= 100 then
            presence.details = "I suck. "..deathsInSession.." deaths! 😂"
        else
            presence.details = "Deaths = "..deathsInSession.." 💀"
        end
        presence.state = gamestate

        discordRPC.updatePresence(presence)
        nextPresenceUpdate = love.timer.getTime() + seconds_for_update
    end
    discordRPC.runCallbacks()
end

function discord_quit()
    discordRPC.shutdown()
end

--[[
state           must be a   string  (max length: 127)
details         must be a   string  (max length: 127)
startTimestamp  must be an  integer (52 bit, signed)
endTimestamp    must be an  integer (52 bit, signed)
largeImageKey   must be a   string  (max length: 31)
largeImageText  must be a   string  (max length: 127)
smallImageKey   must be a   string  (max length: 31)
smallImageText  must be a   string  (max length: 127)
partyId         must be a   string  (max length: 127)
partySize       must be an  integer (32 bit, signed)
partyMax        must be an  integer (32 bit, signed)
matchSecret     must be a   string  (max length: 127)
joinSecret      must be a   string  (max length: 127)
spectateSecret  must be a   string  (max length: 127)
instance        must be an  integer (8 bit, signed)
--]]


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

