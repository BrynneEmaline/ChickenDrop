function love.load()
    math.randomseed(os.time())

    brickGuy = love.graphics.newImage("extra_character_a.png")
    specialBrick = love.graphics.newImage("extra_box_exclamation.png")

    startX = {love.math.random(0, love.graphics.getWidth() - brickGuy:getWidth()),
              love.math.random(0, love.graphics.getWidth() - brickGuy:getWidth()),
              love.math.random(0, love.graphics.getWidth() - brickGuy:getWidth()),
              love.math.random(0, love.graphics.getWidth() - brickGuy:getWidth()),
              love.math.random(0, love.graphics.getWidth() - brickGuy:getWidth())}

    startY = {0 - math.random(brickGuy:getHeight(), brickGuy:getHeight() * 2),
              0 - math.random(brickGuy:getHeight(), brickGuy:getHeight() * 2),
              0 - math.random(brickGuy:getHeight(), brickGuy:getHeight() * 2),
              0 - math.random(brickGuy:getHeight(), brickGuy:getHeight() * 2),
              0 - math.random(brickGuy:getHeight(), brickGuy:getHeight() * 2)}

    fallRate = {love.math.random(50, 200), love.math.random(50, 200), love.math.random(50, 200),
                love.math.random(50, 200), love.math.random(50, 200)}

    specialStartX = love.math.random(love.graphics.getWidth() - specialBrick:getWidth())
    specialStartY = math.random(love.graphics.getHeight() - specialBrick:getHeight())

    score = 0
    gameOver = false
    upgradeOn = false
    upgradeTimer = 0
    timer = 0
    timeToSpecialBrick = love.math.random(1, 2)
    --respawnSpecialTimer = love.math.random(1, 2)

end

function love.mousepressed(x, y, button, istouch) -- istouch is a boolean
    if button == 1 then
        for i, value in ipairs(startX) do
            if x >= startX[i] and x <= startX[i] + brickGuy:getWidth() and y >= startY[i] and y <= startY[i] +
                brickGuy:getHeight() then
                score = score + 1

                startY[i] = 0 - brickGuy:getHeight()
                startX[i] = love.math.random(0, love.graphics.getWidth() - brickGuy:getWidth())
                fallRate[i] = love.math.random(50, 200)
                break
            end
        end
        if x >= specialStartX and x <= specialStartX + specialBrick:getWidth() and y >= specialStartY and y <=
            specialStartY + specialBrick:getHeight() then

            upgradeOn = true
            specialStartX = love.math.random(love.graphics.getWidth() - specialBrick:getWidth())
            specialStartY = math.random(love.graphics.getHeight() - specialBrick:getHeight())

        end
    end
end

function love.update(dt) -- delta time as parameter
    timer = timer + dt
    fallRateUpgrade = 20

    -- handles how long the upgrade lasts
    if upgradeOn then
        upgradeTimer = upgradeTimer + dt
        for i, value in ipairs(startX) do
            startY[i] = startY[i] + fallRateUpgrade * dt;
        end
    else
        -- handles normal fall rate
        for i, value in ipairs(startX) do
            startY[i] = startY[i] + fallRate[i] * dt

            -- if the block falls off the screen the user loses
            if startY[i] > love.graphics.getHeight() then
                gameOver = true;
            end
        end
    end

    -- handles ending the upgrade, resets timers
    if upgradeTimer >= 5 then -- ends the upgrade after 5 seconds
        upgradeTimer = 0
        upgradeOn = false
        timer = 0
        timeToSpecialBrick = love.math.random(1, 2)
    end

    --[[ if specialOnScreen then
        specialOnScreenTimer = specialOnScreenTimer + dt
        if specialOnScreenTimer >= 5 then
            timer = 0
            timeToSpecialBrick = love.math.random(1, 2)
            specialOnScreen = false
        end
    end

    if not upgradeOn and timer >= timeToSpecialBrick then
        specialOnScreen = true
        specialOnScreenTimer = 0
    end
]]

end

function love.draw()

    if gameOver then
        love.graphics.print('GAME OVER', 500, 500)
        love.graphics.print('Press R to restart', 500, 530)
        return
    end

    love.graphics.print(score, 400, 300) -- check to see if font could be prettier
    love.graphics.print(timer, 200, 200)

    if timer > timeToSpecialBrick then
        love.graphics.draw(specialBrick, specialStartX, specialStartY)
    end

    for i, value in ipairs(startX) do
        love.graphics.draw(brickGuy, startX[i], startY[i]);
    end
end
