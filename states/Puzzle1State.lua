--[[ 
programmer: Kara Brown
date: 7.14.2021
purpose: Puzzle1State state machine class.
         displays puzzle one - CBT thought replacement.
]]

-- need to fix the text of the choices fitting inside their boxes.
-- maybe look into plug ins that wrap text around? or just make the boxes
--  each have their own individual sizes instead of a uniform one.

Puzzle1State = Class{__includes = BaseState}

-- pre: table must have integer indexing
-- post: the number of times val appears in table
function count(table, val)
  local count = 0
  for i,item in ipairs(table) do
    if item == val then
      count = count + 1
    end
  end
  return count
end

function Puzzle1State:init() 
  -- keeps track of which prompt should be displayed
  self.current = 0

  -- initialize font
  self.font = love.graphics.newFont("fonts/SpecialElite.ttf", 20)

  -- initialize Anon's room (for background)
  self.room = love.graphics.newImage("images/room.png")

  -- initialize directions
  self.directions = "As thoughts pop into Anon's head, select the most balanced thought to replace it."

  -- initialize thought prompts and choices
  self.prompt = {
    "I'm completely worthless.",
    "No one cares about me.",
    "There's no reason to get up today."
  }
  self.choice = {
    {
      "I only hurt those around me.",
      "I am capable of doing good things.",
      "I need to be better to deserve good things."
    },
    {
      "Someone probably cares about me, I am just looking past it.",
      "If I cared about myself, someone might care about me.",
      "I would deserve to be cared about if I was better."
    },
    {
      "If I got up I could find more things that would make me feel worse than I do right now.",
      "If I got up I would proably just ruin people's day.",
      "If I got up I could do at least one good thing, even if it's just for myself."
    }
  }
  self.correct = {2, 1, 3}

  -- choice buttons
  self.choice_clicked = {}
  for i=1, #self.choice[1] do
    table.insert(self.choice_clicked, false)
  end
  self.cwidth = (self.font:getWidth(self.choice[1][1]) + self.font:getWidth(self.choice[2][1]) + self.font:getWidth(self.choice[3][1])) / 3
  self.cheight = (self.font:getHeight(self.choice[1][1]) + self.font:getHeight(self.choice[2][1]) + self.font:getHeight(self.choice[3][1])) / 3
  self.cx = (WW * 0.5) - (self.cwidth * 0.5)
  self.cy = {
    (WH * 0.4) - (self.cheight * 0.5),
    (WH * 0.5) - (self.cheight * 0.5),
    (WH * 0.6) - (self.cheight * 0.5)
  }
  
  -- keeps track of prompts correctly completed
  self.complete = {}
  for i=1, #self.prompt do
    table.insert(self.complete, false)
  end

  -- continue arrow button
  self.bimage = love.graphics.newImage("images/right_arrow.png")
  self.bs = 0.09 -- scaling factor
  self.bwidth = self.bimage:getWidth() * self.bs
  self.bheight = self.bimage:getHeight() * self.bs
  -- these can be changed depending on what else is displayed
  self.bx = (WW * 0.5) - (self.bwidth * 0.5)
  self.by = nil
  -- these keep track of button activity
  self.blast = false
  self.bnow = false

end

function Puzzle1State:enter() 
  -- do nothing (for now)
end

function Puzzle1State:exit()
  -- do nothing (for now)
end

function Puzzle1State:update() 
  local mx, my = love.mouse.getPosition()
  local arrow_hot = mx > self.bx and mx < self.bx + self.bwidth and
        my > self.by and my < self.by + self.bheight

  -- update arrow button status
  self.blast = self.bnow
  self.bnow = love.mouse.isDown(1) -- 1 = left click

  -- update choice buttons status
  if self.bnow and self.current ~= nil and self.current ~= 0 then
    if mx > self.cx and mx < self.cx + self.cwidth then
      for i=1, #self.choice[1] do
        if my > self.cy[i] and my < self.cy[i] + self.cheight then
          -- highight that button, unhighlight others, and break loop
          for j=1, #self.choice[1] do
            self.choice_clicked[j] = false
          end
          self.choice_clicked[i] = true
          break
        end
      end
    end
  end

  -- check if arrow has been clicked or enter pressed
  if (self.bnow and not self.blast and arrow_hot) or love.keyboard.wasPressed("return") then
    -- directions can just be passed
    if self.current == 0 then
      self.current = self.current + 1
    -- for the prompts, verify that a choice has been selected
    elseif self.current ~= nil then
      local selected = false
      for i=1, #self.choice[1] do
        if self.choice_clicked[i] then
          -- mark as selected
          selected = true
          -- if correct choice, change complete list value, otherwise, do nothing.
          if i == self.correct[self.current] then
            self.complete[self.current] = true
          end
        end
      end

      -- if a choice was selected, housekeeping and change prompts. 
      -- otherwise, don't change anything. want to continue to wait
      -- for them to select a choice before moving on.
      if selected then
        -- if all prompts have been completed, current is nil. 
        if count(self.complete, true) == #self.prompt then
          self.current = nil
        -- otherwise increment prompt to the next uncompleted one.
        else
          local valid = false
          self.current = self.current + 1
          while not valid do
            -- if current prompt is beyond scope, wrap around
            if self.current > #self.prompt then
              self.current = 1
            -- if current prompt is not complete, it is valid
            elseif not self.complete[self.current] then
              valid = true
            -- otherwise increment again to find next incomplete prompt
            else
              self.current = self.current + 1
            end
          end
        end

        -- unselect choices
        for i=1, #self.choice[1] do
          self.choice_clicked[i] = false
        end
      end
    end
  end

  -- if puzzle was completed, change to room1 state
  if self.current == nil then
    state_machine:change("room1")
  end
end

function Puzzle1State:render()
  -- clear background colors to white
  love.graphics.setColor(unpack(WHITE))

  -- set background as Anon's room
  love.graphics.draw(self.room)

  --love.graphics.setColor(unpack(WHITE))
  --love.graphics.print(count(self.complete, true), self.font, 0, 25)

  -- display directions
  if self.current == 0 then
    -- display the dirctions
    local width = self.font:getWidth(self.directions)
    local height = self.font:getHeight(self.directions)
    local x = (WW * 0.5) - (width * 0.5)
    local y = (WH * 0.5) - (height * 0.5)
    love.graphics.setColor(unpack(PINK1))
    love.graphics.rectangle(
      "fill",
      x,
      y,
      width,
      height
    )
    love.graphics.setColor(unpack(BLACK))
    love.graphics.print(
      self.directions,
      self.font,
      x,
      y
    )

    -- display arrow button
    love.graphics.setColor(unpack(PINK1))
    self.by = y + height + 8 -- 8 is an arbitrary mergin
    love.graphics.draw(self.bimage, self.bx, self.by, 0, self.bs, self.bs)

  -- display prompt and choices
  elseif self.current ~= nil then
    -- display the current prompt
    local prompt = self.prompt[self.current]
    local width = self.font:getWidth(prompt)
    local height = self.font:getHeight(prompt)
    local x = (WW * 0.5) - (width * 0.5)
    local y = (WH * 0.25) - (height * 0.5)
    love.graphics.setColor(unpack(PINK1))
    love.graphics.rectangle(
      "fill",
      x,
      y,
      width,
      height
    )
    love.graphics.setColor(unpack(BLACK))
    love.graphics.print(
      prompt,
      self.font,
      x,
      y
    )

    -- display the current choices
    for i=1, #self.choice[1] do
      if self.choice_clicked[i] then
        love.graphics.setColor(unpack(PINK2))
      else
        love.graphics.setColor(unpack(PINK1))
      end
      love.graphics.rectangle(
        "fill",
        self.cx,
        self.cy[i],
        self.cwidth,
        self.cheight
      )
      love.graphics.setColor(unpack(BLACK))
      love.graphics.print(
        self.choice[self.current][i],
        self.font,
        (WW * 0.5) - (self.font:getWidth(self.choice[self.current][i]) * 0.5),
        self.cy[i]
      )
    end

    -- display arrow button
    love.graphics.setColor(unpack(PINK1))
    self.by = (WH * 0.75) - (self.bheight * 0.5)
    love.graphics.draw(self.bimage, self.bx, self.by, 0, self.bs, self.bs)

    --love.graphics.setColor(unpack(WHITE))
    --love.graphics.print(self.current, self.font, 0, 0) 
  end


end
