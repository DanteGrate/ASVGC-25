local font = love.graphics.newFont(100)

local storedHealth = player.health

local UI = {}

local currentColours = {
    {0, 199/255, 0},
    {180/255, 199/255, 0},
    {233/255, 132/255, 0},
    {199/255, 52/255, 0},

    {116/255, 63/255, 48/255},

}

function UI:Update(dt)
    if storedHealth > player.health then
        storedHealth = math.max(storedHealth - dt*3, player.health)
    end
    updateZoneTitles(dt)
end

function UI.Draw()
    local player = player
    local love = love

    local sox = ((love.graphics.getWidth()/screenScale) - 1920) /2
    local soy = ((love.graphics.getHeight()/screenScale) - 1080) /2

    -- UiLock, false     Side, False
    local x, y = 10, 1070 + soy

    local side = 0

    local scale = ((settings.graphics.uiScale.value) + 0.5)/4


    if settings.graphics.zoneTitles.value then
        drawZoneTitle()
    end

    if settings.graphics.uiSide.value then
        if settings.graphics.uiLock.value then
            x = 1910
        else
            x = 1910 + sox
        end
    
        side = 1
    elseif not settings.graphics.uiLock.value then
        x = -sox + 10
    end

    if settings.graphics.uiLock.value then
        y = 1070
    end

    if player.health < 3 and uiSineCounter then 
        love.graphics.setColor(1,1,1,0.5*math.sin(uiSineCounter*3)/player.health)
        love.graphics.draw(assets.image.ui.ouchGlow, x+12.5, y+12.5, 0, scale, scale, assets.image.ui.ouchGlow:getWidth()*side, assets.image.ui.ouchGlow:getHeight()) 
        love.graphics.setColor(1,1,1,1)
    end

    local tweendHealth = math.floor(storedHealth) + tweens.sineInOut(storedHealth%1)

    local healthColour = {.9,.1,.2}
    if player.health == 1 and math.sin(uiSineCounter*30) > 0 then
        healthColour = {1,0.6,0.6}
    elseif tweendHealth and tweendHealth > player.health and math.sin(uiSineCounter*30) > 0 then
        healthColour = {1,0.6,0.6}
    end

    love.graphics.draw(assets.image.ui.currentBar, x, y, 0, scale, scale, assets.image.ui.currentBar:getWidth()*side + 520 - 1040*(1-side), assets.image.ui.currentBar:getHeight())
    love.graphics.draw(assets.image.ui.speedometer, x, y, 0, scale, scale, assets.image.ui.speedometer:getWidth()*side, assets.image.ui.speedometer:getHeight())

    for i = 1,riverGenerator:GetZone(player.y).currentIcons or 1 do
        love.graphics.setColor(currentColours[i])
        if side == 1 then
            love.graphics.draw(assets.image.ui.current, x, y, 0, scale, scale, 1580 - (i*120), assets.image.ui.currentBar:getHeight())
        else
            love.graphics.draw(assets.image.ui.current, x, y, 0, scale, -scale, -830 - (i*120))
        end
    end

    for i = riverGenerator:GetZone(player.y).currentIcons or 1, 4 do
        love.graphics.setColor(currentColours[5])
        if side == 1 then
            love.graphics.draw(assets.image.ui.current, x, y, 0, scale, scale, 1580 - (i*120), assets.image.ui.currentBar:getHeight())
        else
            love.graphics.draw(assets.image.ui.current, x, y, 0, scale, -scale, -830 - (i*120))
        end
    end

    love.graphics.setColor(healthColour)

    local angle1 = math.rad(35 - ((215 + 35)*(1-math.max(tweendHealth/player.maxHealth,0))))
    local angle2 = -math.rad(215)
    love.graphics.arc("fill", x - 480*scale + 960*(1-side)*scale, y - 320*scale, 480*scale, angle1, angle2)

    love.graphics.setColor(healthColour)
    local angle1 = math.rad((35 - ((215 + 35)*(1-math.max((player.health/player.maxHealth),0)))))
    local angle2 = -math.rad(215)
    love.graphics.arc("fill", x - 480*scale + 960*(1-side)*scale, y - 320*scale, 480*scale, angle1, angle2)
    love.graphics.setColor(1,1,1)
    
    if player.health < 2 then
        love.graphics.draw(assets.image.ui.speedometerFrontVeryDamage, x, y, 0, scale, scale, assets.image.ui.speedometer:getWidth()*side, assets.image.ui.speedometer:getHeight())
    elseif player.health < 3 then
        love.graphics.draw(assets.image.ui.speedometerFrontDamage, x, y, 0, scale, scale, assets.image.ui.speedometer:getWidth()*side, assets.image.ui.speedometer:getHeight())
    else love.graphics.draw(assets.image.ui.speedometerFront, x, y, 0, scale, scale, assets.image.ui.speedometer:getWidth()*side, assets.image.ui.speedometer:getHeight()) end

    local playerSpeedPercentage = (player.speed/player.maxSpeed)
    local dir = playerSpeedPercentage*math.rad(210) - math.rad(30)

    local randShakeX = 0
    local randShakeY = 0
    
    if player.speed > player.autoSpeed then
        local percentageOver = (player.speed-player.autoSpeed)/(player.maxSpeed-player.autoSpeed) 
        randShakeX = math.random(-100,100)/20 * (percentageOver)*scale
        randShakeY = math.random(-100,100)/20 * (percentageOver)*scale

        love.graphics.setColor(1,1,0.5+0.5*(1-percentageOver))
    end

    love.graphics.draw(assets.image.ui.needle, x - 480*scale + 960*(1-side)*scale + randShakeX, y - 320*scale + randShakeY, dir, scale, scale, (assets.image.ui.needle:getWidth())-32, assets.image.ui.needle:getHeight()/2)
end

return UI