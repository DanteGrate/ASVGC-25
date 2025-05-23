music = {} --table for music functions and variables

local crossFadeSpeed
local musicTracks
local zoneMusicTarget
local lastZone = ""

function music.unload()
    if musicTracks then
        for i = 1, #musicTracks do
            musicTracks[i].track:stop()
        end
    end

    musicTracks = nil --this MUST be nil and not empty table!! for now.
end

function music.load()
    local data = love.filesystem.load("code/river/riverData/" .. riverName .. "/music.lua")()

    dante.printTable(data)
  
    crossFadeSpeed = data.data.crossFadeSpeed
    if musicTracks == nil then
        musicTracks = data.data.tracks 
    end
    zoneMusicTarget = data.zones

    --Actually update the music tracks instantly, might remove later
    music.manager(0)
end

function music.manager(dt)
    --play the actual music
    if settings then
        if not musicTracks[1].track:isPlaying() and settings.audio.musicVolume.value > 0 then
            --play all tracks at once to avoid desync
            for i = 1, #musicTracks do
                musicTracks[i].volume = quindoc.clamp(musicTracks[i].volume,0.001,1)
                musicTracks[i].track:setVolume(musicTracks[i].volume*settings.audio.musicVolume.value*0.5*settings.audio.masterVolume.value)
                musicTracks[i].track:play()
            end

            --music.bar = -1
            --music.beat = 1
            --music.lastBar = 0
            --music.firstFrameInBar = true   

        elseif musicTracks[1].track:isPlaying() and settings.audio.musicVolume.value <= 0 and settings.audio.masterVolume.value <= 0  then
            for i = 1, #musicTracks do
                musicTracks[i].track:stop()
            end
        end

        --so this manager manages the other managers. dunno enough about buisness to tell you what that role is called
        local currentZoneName
        if zones and type(zones[1]) == "table" then
            currentZoneName = zones[1].displayName
        elseif zones then
            currentZoneName = zones.displayName
        end
        if currentZoneName ~= lastZone then
            if zoneMusicTarget[currentZoneName] then
                local targets = quindoc.runIfFunc(zoneMusicTarget[currentZoneName])
                if targets then
                    for i = 1,#targets do
                        if musicTracks[i] then

                            musicTracks[i].targetVolume = targets[i] --or musicTracks[i].targetVolume
                        end
                    end
                end
            end
            lastZone = currentZoneName
        end


        for i = 1, #musicTracks do
    --        if musicTracks[i].drumTrack == nil then
            if musicTracks[i].volume ~= musicTracks[i].targetVolume then
                musicTracks[i].volume = quindoc.clamp(musicTracks[i].volume+(crossFadeSpeed*dt)*quindoc.sign(musicTracks[i].targetVolume-musicTracks[i].volume),0.001,1)
            end
        
            musicTracks[i].track:setVolume(musicTracks[i].volume*settings.audio.musicVolume.value*0.5)

    --        elseif music.firstFrameInBar then
    --            musicTracks[i].track:setVolume(musicTracks[i].volume*settings.audio.musicVolume.value)
    --        end

        end

        --[[

        i had an epic system where drum beats would only start on the first beat of the bar.....
        but all this ended up being useless because gamespeed screws everything up
        once i can figure out how to update the counter regardless of gamespeed, pausing etc this can be re-enabled

        --bpm calculations
        if music.bar == -1 then
            music.bar = 1
        else
            music.beat = music.beat + dt*(music.bpm/60)/(gameSpeed or 1)
        end
        
        if music.beat >= music.beatsPerBar+1 then
            music.bar = music.bar + 1
            music.beat = 1
            music.firstFrameInBar = true   
        else
            music.firstFrameInBar = false
        end]]
    end
    
end