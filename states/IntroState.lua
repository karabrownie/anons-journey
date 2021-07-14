--[[ 
programmer: Kara Brown
date: 7.12.2021
purpose: IntroState state machine class.
        displays the intro internal monologue and
        button to continue into puzzle1 state.
]]


IntroState = Class{__includes = BaseState}

function IntroState:init()
  -- keeps track of which monologue text should be displayed
  self.current = 1

  -- initialize font
  self.font = love.graphics.newFont("fonts/SpecialElite.ttf", 25)

  -- initialize monologue text
  self.text = {
    "I don’t want to get out of bed . . . I can’t.",
    "I feel so lonely . . . Will it always be like this?\nIt’s been like this for so long.",
    "Every day feels the same - long and painful.\nMaybe if I got out of bed I would feel a little better.",
    "Maybe not . . ."
  }
  self.num_text = #self.text

  -- continue arrow button
  self.bimage = love.graphics.newImage("images/right_arrow.png")
  self.bsx = 0.09 -- scaling factors
  self.bsy = 0.09 -- scaling factors
  self.bwidth = self.bimage:getWidth() * self.bsx
  self.bheight = self.bimage:getHeight() * self.bsy
  self.bx = (ww * 0.5) - (self.bwidth * 0.5)
  self.by = wh - (self.bheight * 1.1)
  self.blast = false
  self.bnow = false
  
end

function IntroState:update(dt)
  -- if button or enter was clicked, increment the text to render
  local mx, my = love.mouse.getPosition()
  local hot = mx > self.bx and mx < self.bx + self.bwidth and
          my > self.by and my < self.by + self.bheight

  self.blast = self.bnow
  self.bnow = love.mouse.isDown(1) -- 1 = left click
  if (self.bnow and not self.blast and hot) or love.keyboard.wasPressed("return") then
    self.current = self.current + 1
  end

  -- if out of text to render, switch to puzzle1
  if self.current > self.num_text then
    STATE_MACHINE:change("puzzle1")
  end
end

function IntroState:render()
  -- set background color
  love.graphics.setBackgroundColor(unpack(BACK_COLOR))

  -- check that something should be displaying
  if self.current <= self.num_text then

    -- disaplay monologue text
    love.graphics.setColor(unpack(BLACK))
    love.graphics.print(
      self.text[self.current],
      self.font,
      (ww * 0.5) - (self.font:getWidth(self.text[self.current]) * 0.5),
      (wh * 0.5) - (self.font:getHeight(self.text[self.current]) * 0.7)
    )

    -- display continue button (a right facing arrow)
    love.graphics.setColor(unpack(BACK_COLOR))
    love.graphics.draw(self.bimage, self.bx, self.by, 0, self.bsx, self.bsy)

  end


end

function IntroState:enter()

end

function IntroState:exit()

end