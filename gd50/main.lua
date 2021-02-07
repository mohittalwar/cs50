-- main.lua: equivalent to the main() function in C.

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

PADDLE_WIDTH = 8
PADDLE_HEIGHT = 32
PADDLE_SPEED = 140

BALL_SIZE = 4

LARGE_FONT = love.graphics.newFont(32)
SMALL_FONT = love.graphics.newFont(16)

push = require 'push'

-- Table: equivalent to dict() in python
player1 = {
    x = 10,
    y = 10,
    score = 0
}

player2 = {
    x = VIRTUAL_WIDTH - PADDLE_WIDTH - 10,
    y = VIRTUAL_HEIGHT - PADDLE_HEIGHT - 10,
    score = 0
}

ball = {
    x = 0,
    y = 0,
    dx = 0,
    dy = 0
}

-- State machine: title -> serve -> play
gameState = 'title'

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT)    
    resetBall()
end

-- Update
function love.update(dt)
    -- Move player1
    player1.y = getY(player1.y, dt, 'w', 's')

    -- Move player2
    player2.y = getY(player2.y, dt, 'up', 'down')

    if gameState ~= 'play' then
        return
    end

    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt

    if ball.x <= 0 then
        player2.score = player2.score + 1
        resetBall()
        gameState = 'serve'
    elseif ball.x >= VIRTUAL_WIDTH - BALL_SIZE then
        player1.score = player1.score + 1
        resetBall()
        gameState = 'serve'
    end

    if ball.y <= 0 or ball.y >= VIRTUAL_HEIGHT - BALL_SIZE then
        ball.dy = -ball.dy
    end

    if collides(player1, ball) then
        ball.dx = -ball.dx * 1.02
        ball.x = player1.x + PADDLE_WIDTH
    elseif collides(player2, ball) then
        ball.dx = -ball.dx * 1.02
        ball.x = player2.x - BALL_SIZE
    end
end

-- Input
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'enter' or key == 'return' then
        if gameState == 'title' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        end
    end 
end

-- Render
function love.draw()
    push:start()

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    if gameState == 'title' then
        love.graphics.setFont(LARGE_FONT)
        love.graphics.printf('Pre50 Pong', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(SMALL_FONT)
        love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT - 32, VIRTUAL_WIDTH, 'center')
    end
    if gameState == 'serve' then
        love.graphics.printf('Press Enter to Serve!', 0, VIRTUAL_HEIGHT - 32, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(LARGE_FONT)
    love.graphics.print(player1.score, VIRTUAL_WIDTH / 2 - 36, VIRTUAL_HEIGHT / 2 - 16)
    love.graphics.print(player2.score, VIRTUAL_WIDTH / 2 + 36, VIRTUAL_HEIGHT / 2 - 16)
    love.graphics.setFont(SMALL_FONT)

    love.graphics.rectangle('fill', player1.x, player1.y, PADDLE_WIDTH, PADDLE_HEIGHT)
    love.graphics.rectangle('fill', player2.x, player2.y, PADDLE_WIDTH, PADDLE_HEIGHT)
    love.graphics.rectangle('fill', ball.x, ball.y, BALL_SIZE, BALL_SIZE)
    push:finish()
end

function updateY(y, dt, upKey, downKey)
    if love.keyboard.isDown(upKey) then
        y = y - PADDLE_SPEED * dt
    end
    if love.keyboard.isDown(downKey) then
        y = y + PADDLE_SPEED * dt
    end
    if y <= 0 then
        y = 0
    end
    if y >= VIRTUAL_HEIGHT - PADDLE_HEIGHT then
        y = VIRTUAL_HEIGHT - PADDLE_HEIGHT
    end
    return y
end

function resetBall()
    ball.x = VIRTUAL_WIDTH / 2 - BALL_SIZE / 2
    ball.y = VIRTUAL_HEIGHT / 2 - BALL_SIZE / 2
    ball.dx = getRandomSpeed(60)
    ball.dy = getRandomSpeed(30)
end

function getRandomSpeed(n)
    delta = n + math.random(60)
    if math.random(2) == 1 then
        delta = -delta
    end
    return delta
end 

function collides(p, b)
    return not (p.x > b.x + BALL_SIZE or p.y > b.y + BALL_SIZE or b.x > p.x + PADDLE_WIDTH or b.y > p.y + PADDLE_HEIGHT)
end
