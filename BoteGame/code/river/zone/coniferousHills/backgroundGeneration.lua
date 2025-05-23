local function GetColourAt(x, y)
    local colour = {0.5,0.5,0.5}

    local distToEdge
    if getDistToEdge then
        distToEdge = getDistToEdge(x, y)
    else
        distToEdge = river:getDistToEdge(x, y)
    end


    if distToEdge < 0 then

        local noiseA = love.math.noise(y/300.01)/100
        local noiseB = love.math.noise(y/2000.01)/30
        local noiseC = love.math.noise(y/10000.01)/20
       -- noiseD = love.math.noise(y/20.01)/200

        local mega = quindoc.round(((1-distToEdge/-1500+noiseA+noiseB+noiseC))*1.96,1)/1.96

        colour = quindoc.clamp(mega,0.815,1)
        return {53*colour/255,81*colour/255,147*colour/255}
        
    else

        local p = 0
        
        --if p > 0.9 then p = 0 end

        if zones and zones.zone == "coniferousMountainside" then
            p = quindoc.clamp(riverGenerator:GetPercentageThrough(y)-0.2,0,1)
        end

        local elevation = distToEdge/(500+500*p)

        local noiseA = love.math.noise(y/1500.01) / 10
        local noiseB = love.math.noise(y/300.01) / 10
        local noiseC = love.math.noise(y/50.01) / 50

        if elevation < 0.05 then --riverbank
            colour = {0.85,0.9,0.25}
        elseif elevation < 0.10 +noiseA/10 then --near riverbank

            colour = {0.59,0.82,0.28}

        elseif elevation < 0.97*(3*p+1) + noiseB - noiseA then --main gtass
            
            --local snowPatch = 0.9*love.math.noise(2*x/1600.1,2*y/1600.1) + 0.1*love.math.noise(x/100.1,y/100.1)

            if love.math.noise(x/1000.1,y/1000.1) < 0.3 then
                colour = {0.4,0.63,0.18}
            else colour = {0.4,0.66,0.14} end


        elseif elevation < 1*(3*p+1) + noiseB - noiseA then --uppergrass
            colour = {0.36,0.63,0.07}
        else 
            if love.math.noise(x/1000.1,y/1000.1) < 0.3 then
                colour = {0.45,0.69,0.2}
            else colour = {0.45,0.72,0.14} end
        end

        return colour

    end    
end
    
return GetColourAt  