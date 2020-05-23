Powers = Class{}

function Powers:init()

  -- the 6 is ball skin and 9 is key skin
  self.skin = (math.random(1, 2)) == 1 and 10 or 7

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
