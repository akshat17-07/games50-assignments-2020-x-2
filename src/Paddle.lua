--[[
    GD50
    Breakout Remake

    -- Paddle Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a paddle that can move left and right. Used in the main
    program to deflect the ball toward the bricks; if the ball passes
    the paddle, the player loses one heart. The Paddle can have a skin,
    which the player gets to choose upon starting the game.
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
Paddle = Class{}

--[[
    Our Paddle will initialize at the same spot every time, in the middle
    of the world horizontally, toward the bottom.
]]
function Paddle:init(skin)
    -- x is placed in the middle
    self.x = VIRTUAL_WIDTH / 2 - 32

    -- y is placed a little above the bottom edge of the screen
    self.y = VIRTUAL_HEIGHT - 32

    -- start us off with no velocity
    self.dx = 0


    -- the variant is which of the four paddle sizes we currently are; 2
    -- is the starting size, as the smallest is too tough to start with
    self.size = 2

    -- starting dimensions
    self.width = self.size * 32
    self.height = 16

    -- the skin only has the effect of changing our color, used to offset us
    -- into the gPaddleSkins table later
    self.skin = skin

end

-- increase the size of paddle when funtion called
function Paddle:sizeIncrease()
    -- insure max size = 4
    self.size = math.min(4, self.size+1)
    self.width = self.size * 32
end

-- decrease the size of paddle when funtion called
function Paddle:sizeDecrease()
    -- insure min size = 1
    self.size = math.max(1, self.size-1)
    self.width = self.size * 32
end

-- reset the size
function Paddle:sizeReset()
    -- reset to 2
    self.size = 2
    self.width = self.size * 32
end

function Paddle:update(dt)
    -- keyboard input
    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0
    end

    -- math.max here ensures that we're the greater of 0 or the player's
    -- current calculated Y position when pressing up so that we don't
    -- go into the negatives; the movement calculation is simply our
    -- previously-defined paddle speed scaled by dt
    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    -- similar to before, this time we use math.min to ensure we don't
    -- go any farther than the bottom of the screen minus the paddle's
    -- height (or else it will go partially below, since position is
    -- based on its top left corner)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

--[[
    Render the paddle by drawing the main texture, passing in the quad
    that corresponds to the proper skin and size.
]]
function Paddle:render()
    love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.skin - 1)],
        self.x, self.y)
end
