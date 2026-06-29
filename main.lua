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

    score = 0
    gameOver = false

    upgradeOn = false
    upgradeTimer = 0

    specialOn = false
    specialTimer = 0
    specialDelay = love.math.random(4, 8)

    specialStartX = 0
    specialStartY = 0

end

function spawnSpecial(dt)
    specialOn = true

    specialStartX = love.math.random(love.graphics.getWidth() - specialBrick:getWidth())
    specialStartY = math.random(love.graphics.getHeight() - specialBrick:getHeight())
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
        if specialOn and x >= specialStartX and x <= specialStartX + specialBrick:getWidth() and y >= specialStartY and
            y <= specialStartY + specialBrick:getHeight() then

            upgradeOn = true
            specialOn = false
            SpecialTimer = 0
            SpecialDelay = love.math.random(4, 8)

        end
    end
end

function love.update(dt) -- delta time as parameter
    -- upgradeTimer = upgradeTimer + dt
    -- specialTimer = specialTimer + dt

    fallRateUpgrade = 20

    -- handles the fall rate when active
    if upgradeOn then
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
    if upgradeOn then
        upgradeTimer = upgradeTimer + dt

        if upgradeTimer >= 2 then -- ends the upgrade after 2 seconds
            upgradeTimer = 0
            upgradeOn = false
        end
    end

    if not specialOn then
        specialTimer = specialTimer + dt

        if specialTimer >= specialDelay then
            spawnSpecial()
            specialTimer = 0
            specialDelay = love.math.random(4, 8)
        end
    end
end
function love.draw()

    love.graphics.setFont(love.graphics.newFont(24))

    if gameOver then
        love.graphics.print('GAME OVER', 500, 500)
        love.graphics.print('SCORE: ' .. score, 500, 530)
        love.graphics.print('Press R to restart', 500, 560)
        return
    end

    love.graphics.print('SCORE: ' .. score, love.graphics.getWidth() - 150, love.graphics.getHeight() - 50) -- check to see if font could be prettier

    for i, value in ipairs(startX) do
        love.graphics.draw(brickGuy, startX[i], startY[i]);
    end

    if specialOn and not upgradeOn then
        love.graphics.draw(specialBrick, specialStartX, specialStartY)
    end
end

function restartGame()
    love.load()
end

function love.keypressed(key)
    if key == "r" and gameOver then
        restartGame()
    end
end

