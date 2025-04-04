-- load this locally, to b removed later :D
local riverZones = love.filesystem.load("code/river/riverData/" .. riverName .. "/zone.lua")()

local toLoad = {
    -- player skins
    {"image/player/default.png"},

    -- actual player code
    {"code/player/playerBoat.lua"},
    {"code/player/playerUi.lua"},

    {"save/highscore.lua", "run"},


    -- generation suff
    {"code/river/river.lua"},
    {"code/river/generator/riverGenerator.lua"},
    {"code/river/generator/riverCanvas.lua"},
    {"code/river/generator/obstacleSpawner.lua"},

    {"code/camera.lua"},
    {"code/inputManager.lua"},
    {"code/menu/keybinds.lua"},
    {"code/menu/pauseMenu.lua", "run"},
    {"code/menu/gameOverMenu.lua", "run"},


    -- add this obstacle here, all others need it to be already loaded
    {"obstacle/obstacle.lua", "run"},

    -- images
    {"image/ui/viginette.png", "blur"},
    {"image/ui/needle.png", "blur"},
    {"image/ui/speedometer.png", "blur"},
    {"image/ui/speedometerFront.png", "blur"},
    {"image/ui/speedometerFrontDamage.png", "blur"},
    {"image/ui/speedometerFrontVeryDamage.png", "blur"},
    {"image/ui/currentBar.png", "blur"},
    {"image/ui/current.png", "blur"},
    {"image/ui/ouchGlow.png", "blur"},
}

for i , value in pairs(riverZones) do
    -- add a falg to tell the code to add the obsticals to the loaded list later :/
    table.insert(toLoad, {"code/river/zone/" .. riverZones[i].zone .. "/obsticals.lua", "addObstacles"})
    table.insert(toLoad, {"code/river/zone/" .. riverZones[i].zone .. "/pathGeneration.lua"})
    table.insert(toLoad, {"code/river/zone/" .. riverZones[i].zone .. "/backgroundGeneration.lua", "run", "GetColourAt"})
    table.insert(toLoad, {"code/river/zone/" .. riverZones[i].zone .. "/backgroundGeneration.lua", "run", "GetColourAt"})
end

-- load this file in a more permenant position.
table.insert(toLoad, {"code/river/riverData/" .. riverName .. "/zone.lua"})
table.insert(toLoad, {"code/river/riverData/" .. riverName .. "/music.lua", "run"})
table.insert(toLoad, {"code/river/riverData/" .. riverName .. "/ambiance.lua", "run"})
table.insert(toLoad, {"code/river/riverData/" .. riverName .. "/obstacle.lua", "run"})



return toLoad