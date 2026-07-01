--[[ Block Drop Game
- green blocks drop at random speeds and random x values, starting above screen 
- special gold upgrade blocks appear at random intervals
- when upgrade clicked, slows all green blocks down for 2 seconds
- score increases for each block clicked
- when green blocks clicked, they respawn above screen at random x value
- if a green block falls off screen, game over
]] function love.load()
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

    -- variables related to upgrade being on, so that upgrade effect can end after 2 seconds
    upgradeOn = false
    upgradeTimer = 0

    -- variables related to if special block is on screen, allows for random spawning of new special blocks
    specialOn = false
    specialTimer = 0
    specialDelay = love.math.random(4, 8)

    specialStartX = 0
    specialStartY = 0

end

-- helper function to spawn new special blocks at random locations
function spawnSpecial()
    specialOn = true

    specialStartX = love.math.random(love.graphics.getWidth() - specialBrick:getWidth())
    specialStartY = math.random(love.graphics.getHeight() - specialBrick:getHeight())
end

function love.mousepressed(x, y, button, istouch)
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

            -- turns upgrade on when pressed, sets special on screen to false, resets timers and chooses a new random delay amount  
            upgradeOn = true
            specialOn = false
            SpecialTimer = 0
            SpecialDelay = love.math.random(4, 8)

        end
    end
end

function love.update(dt)

    fallRateUpgrade = 20 -- hard coded slow fall rate as upgrade

    -- handles the fall rate when upgrade active
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

    -- handles the upgrade timer, turns upgrade off after 2 seconds
    if upgradeOn then
        upgradeTimer = upgradeTimer + dt

        if upgradeTimer >= 2 then
            upgradeTimer = 0
            upgradeOn = false
        end
    end

    -- when special block isn't on screen, start counter to respawn another one
    if not specialOn then
        specialTimer = specialTimer + dt

        -- when timer meets random delay amount, spawn new special block,
        -- reset timer and choose another random delay amount
        if specialTimer >= specialDelay then
            spawnSpecial()
            specialTimer = 0
            specialDelay = love.math.random(4, 8)
        end
    end
end

function love.draw()

    love.graphics.setFont(love.graphics.newFont(24))

    -- gameover screen
    if gameOver then
        love.graphics.print('GAME OVER', 500, 500)
        love.graphics.print('SCORE: ' .. score, 500, 530)
        love.graphics.print('Press R to restart', 500, 560)
        return
    end

    love.graphics.print('SCORE: ' .. score, love.graphics.getWidth() - 150, love.graphics.getHeight() - 50)

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

