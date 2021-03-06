--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]
--[[
  TODO / My approch
  I had writen all steps I had taken for solving this assignment
	DEBUG THE RECOVER POINTS MISHAP
	CHANGE SIZE OF PADDLES
      decrease the paddle size - done
      increase paddle size - done
IMPLIMENT THE DIFFERENT POWERUP DOING DOWN - DONE
        generate the powers ups sprites - done
        make powers up class - done
        render the powers ups - done
	BALL POWER UPS - DONE
      impliment the inPlay function in ball class - done
      change Ball() to {Ball()} in play state - done
      produce more balls - done
      debug the health error - done
	KEY AND UNLOCKING THE BRICK
      take out the lock brick sprite - done
      implement the function for lock brick in brick class - done
      produce at least and at most one lock bricks - doing
      produce power up to unlock the brick
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = {params.ball}
    self.level = params.level
    self.powers = {}
    self.generateKeyPower = params.generateKeyPower
    self.recoverPoints = params.recoverPoints

    -- give ball random starting velocity
    for k, ball in pairs(self.ball) do
      ball.dx = math.random(-200, 200)
      ball.dy = math.random(-50, -60)
    end

    self.powerTimer = math.random(2,10)
    self.powerCounter = 0
end

function PlayState:update(dt)

    self.powerCounter = self.powerCounter + dt
    --creating the power up every 5 dt
    if self.powerTimer < self.powerCounter then
      self.powerTimer = math.random (2,10)
      self.powerCounter = 0
      temp = Powers(self.generateKeyPower)
      table.insert(self.powers, temp)
    end

    -- updating and deleting powers ups
    for k, power in pairs(self.powers) do
      power:update()

      if power:collides(self.paddle) == true then
          self:getPowerUp(power.skin)
          table.remove(self.powers, k)
          gSounds['powerup']:play()

      elseif power.y > self.paddle.y + 10 then
          table.remove(self.powers, k)
          gSounds['powerdown']:play()
      end
    end

    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)
    for k, ball in pairs(self.ball) do
      if ball.inPlay then
        ball:update(dt)
      end
    end
    for k, ball in pairs(self.ball) do
        if ball:collides(self.paddle) then
            -- raise ball above paddle in case it goes below it, then reverse dy
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy

            --
            -- tweak angle of bounce based on where it hits the paddle
            --

            -- if we hit the paddle on its left side while moving left...
            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))

          -- else if we hit the paddle on its right side while moving right...
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
          end

            gSounds['paddle-hit']:play()
        end
      end

    -- detect collision across all bricks with the ball
    for b, ball in pairs(self.ball) do
        for k, brick in pairs(self.bricks) do

          if ball.inPlay then

          -- only check collision if we're in play
              if brick.inPlay and ball:collides(brick) then
                  -- add to score
                  if not brick.lock then
                  self.score = self.score + (brick.tier * 200 + brick.color * 25)

                  -- trigger the brick's hit function, which removes it from play
                  brick:hit()
               end
                  -- if we have enough points, recover a point of health
                  if self.score > self.recoverPoints then
                      -- can't go above 3 health
                      self.health = math.min(3, self.health + 1)
                      -- multiply recover points by 2
                      self.recoverPoints = self.recoverPoints + 10000

                      -- increase the size of paddles
                      self.paddle:sizeIncrease()

                      -- play recover sound effect
                      gSounds['recover']:play()
                  end

              -- go to our victory screen if there are no more bricks left
                  if self:checkVictory() then
                      gSounds['victory']:play()

                      --reset the paddle sizes
                      self.paddle:sizeReset()
                      self.generateKeyPower = true
                      gStateMachine:change('victory', {
                          level = self.level,
                          paddle = self.paddle,
                          health = self.health,
                          score = self.score,
                          highScores = self.highScores,
                          ball = Ball(),
                          recoverPoints = self.recoverPoints,
                          generateKeyPower = self.generateKeyPower
                      })
                    end

                  --
                  -- collision code for bricks
                  --
                  -- we check to see if the opposite side of our velocity is outside of the brick;
                  -- if it is, we trigger a collision on that side. else we're within the X + width of
                  -- the brick and should check to see if the top or bottom edge is outside of the brick,
                  -- colliding on the top or bottom accordingly
                  --

                  -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                  -- so that flush corner hits register as Y flips, not X flips
                  if ball.x + 2 < brick.x and ball.dx > 0 then

                      -- flip x velocity and reset position outside of brick
                      ball.dx = -ball.dx
                      ball.x = brick.x - 8

                  -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                  -- so that flush corner hits register as Y flips, not X flips
                  elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then

                      -- flip x velocity and reset position outside of brick
                      ball.dx = -ball.dx
                      ball.x = brick.x + 32

                  -- top edge if no X collisions, always check
                  elseif ball.y < brick.y then

                      -- flip y velocity and reset position outside of brick
                      ball.dy = -ball.dy
                      ball.y = brick.y - 8

                  -- bottom edge if no X collisions or top collision, last possibility
                  else

                      -- flip y velocity and reset position outside of brick
                      ball.dy = -ball.dy
                      ball.y = brick.y + 16
                  end

              -- slightly scale the y velocity to speed up the game, capping at +- 150
                if math.abs(ball.dy) < 150 then
                    ball.dy = ball.dy * 1.02
                end

              -- only allow colliding with one brick, for corners
              break
            end
          end
      end
    end

  -- if ball goes below bounds, revert to serve state and decrease health
  function PlayState:checkGameOver()
     for b, ball in pairs(self.ball) do
       if ball.inPlay then
         return false
       end
     end

     return true
   end
    for b, ball in pairs(self.ball) do
      if ball.y >= VIRTUAL_HEIGHT and ball.inPlay then
          --self.health = self.health - 1
          ball.inPlay = false
          gSounds['hurt']:play()


          --[[if self.health == 0 then
              gStateMachine:change('game-over', {
                  score = self.score,
                  highScores = self.highScores
              })
          else
              -- decrease the size of paddles
              self.paddle:sizeDecrease()

              gStateMachine:change('serve', {
                  paddle = self.paddle,
                  bricks = self.bricks,
                  health = self.health,
                  score = self.score,
                  highScores = self.highScores,
                  level = self.level,
                  recoverPoints = self.recoverPoints
              })
          end]]
        if self:checkGameOver() then
              gSounds['hurt']:play()
              self.health = self.health - 1

              if self.health == 0 then
                  gStateMachine:change('game-over', {
                      score = self.score,
                      highScores = self.highScores
                  })

                else
                  --reset the paddle sizes
                  self.paddle:sizeDecrease()
                  gStateMachine:change('serve', {
                    paddle = self.paddle,
                    bricks = self.bricks,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    level = self.level,
                    recoverPoints = self.recoverPoints,
                    generateKeyPower = self.generateKeyPower
                  })
              end

          end
        end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    for k, power in pairs(self.powers) do
      power:render()
    end

    self.paddle:render()
    for k, ball in pairs(self.ball) do
      if ball.inPlay then
        ball:render()
      end
    end

    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end
    end

    return true
end
function PlayState:getPowerUp(skin)
  if skin == 7 then
    b = Ball(math.random(7))
    b.x = self.paddle.x + self.paddle.width / 2
    b.y = self.paddle.y
    b.dx = math.random(-200, 200)
    b.dy = math.random(-50, -60)
    table.insert(self.ball,b)
  else
    for k, brick in pairs(self.bricks) do
      if brick.lock then
        brick.lock = false
        self.generateKeyPower = false
      end
    end
  end
end

end
