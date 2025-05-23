local leaderRockShape = love.physics.newCircleShape(25*3)

local leaderRockImages = {}

for i = 1, 5 do
    local image = love.graphics.newImage("image/obstacle/bigRock/bigRock"..i..".png")
    table.insert(leaderRockImages,image)
end

for i = 1,#leaderRockImages do
    leaderRockImages[i]:setFilter("nearest", "nearest")
end

local leaderRockObstacle = setmetatable({}, { __index = Obstacle }) 
leaderRockObstacle.__index = leaderRockObstacle

leaderRockObstacle.xFunc = function()
    return math.random(600,700)*(math.random(0,1)*2-1)
end

function leaderRockObstacle:New(x, y)
    local obj = Obstacle:New(x, y, leaderRockShape)
    setmetatable(obj, self)
    obj.image = leaderRockImages[math.random(1, #leaderRockImages)]

    obj.dir = math.rad(math.random(1,360))    

    --CODE FOR DOING AN ACTION ON OBSTACLE SPAWN GOES HERE

    local chainLengthCoefficient = currentPlayerPos.chainLengthCoefficient

    obj.debugTable = {}

    table.insert(obj.debugTable, {x=obj.x,y=obj.y})

    local angle = math.rad(360-math.random(15,35)) 

    if obj.x > 0 then
        angle = math.rad(360-math.random(145,165)) 
    end

    local chainLength = 10-- math.random(2,5)
    local chainDiff = 0
    local inheritChainDiff = 150
    local tempDiff = 0

    local x = obj.x
    local y = obj.y

    local startX = x

    if chainLength > 0 then
        for i = 1, chainLength do

            local randNum = math.random(1,6)
            local obsToInsert = nil

            if randNum == 1 or randNum == 2 then

                chainDiff = math.random(200,250)*chainLengthCoefficient
                obsToInsert = assets.obstacle.hugeRock

            elseif randNum == 3 or randNum == 4 then

                chainDiff = math.random(140,170)*chainLengthCoefficient
                obsToInsert = assets.obstacle.bigRock

            else

                chainDiff = math.random(75,90)*chainLengthCoefficient
                obsToInsert = assets.obstacle.rock

            end

            x = x+(chainDiff+inheritChainDiff)*math.cos(angle)
            y = y+(chainDiff+inheritChainDiff)*math.sin(angle)

            table.insert(obstacles, obsToInsert:New(x,y))
            --angle = angle + 0.01

            inheritChainDiff = chainDiff

            angle = angle + math.rad(math.random(-10,10))

            table.insert(obj.debugTable, {x=x,y=y})

            if math.abs(x) > math.abs(startX) then 
                break
            end

        end
    end
    
    return obj
end

function leaderRockObstacle:Update(no, dt)
    if self.body then

        --CODE FOR UPDATING OBSTACLE GOES HERE

        Obstacle.Update(self, no, dt)
    end
end

function leaderRockObstacle:Draw(no)
    local img = self.image
    love.graphics.draw(img, self.x, self.y, self.dir, 3, 3, img:getWidth()/2, img:getHeight()/2)

end

function leaderRockObstacle:DrawHitbox()
    if self.fixture:getUserData().hasCollided then
        love.graphics.setColor(1,0,0)
    end

    love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())

    if self.fixture:getUserData().hasCollided then
        love.graphics.setColor(1,1,1)
    end

    
    for i = 1, #self.debugTable - 1 do
        love.graphics.line(self.debugTable[i].x,self.debugTable[i].y, self.debugTable[i+1].x,self.debugTable[i+1].y)
    end


end

return leaderRockObstacle