Powers = Class{}

function Powers:init()

  -- the 6 is ball skin and 9 is key skin
  self.skin = (math.random(1, 2)) == 1 and 10 or 7

  -- setting random x
  self.x = math.random(0, VIRTUAL_WIDTH-100)

  self.dy = 0.5
  self.y = 0
end

function Powers:update(dt)
    -- powers up falling down
    self.y = self.y + self.dy
end

function Powers:render()
    love.graphics.draw(gTextures['main'], gFrames['powers'][self.skin],
        self.x, self.y)
end
