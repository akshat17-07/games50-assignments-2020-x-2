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
Powers = Class{}

function Powers:init(keyRequired)

  if keyRequired then
    -- the 6 is ball skin and 9 is key skin
    self.skin = (math.random(1, 2)) == 2 and 10 or 7
 else
   self.skin = 7
 end
  -- setting random x
  self.x = math.random(0, VIRTUAL_WIDTH-100)

  self.dy = 1
  self.y = 0

  self. height = 16
  self. width = 16
end

function Powers:update(dt)
    -- powers up falling down
    self.y = self.y + self.dy
end

function Powers:render()
    love.graphics.draw(gTextures['main'], gFrames['powers'][self.skin],
        self.x, self.y)
end

function Powers:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    -- if the above aren't true, they're overlapping
    return true

end
