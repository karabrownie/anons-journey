--[[
  programmer: Kara Brown
  date: 7.13.2021
  purpose: ControlsScreenState machine state class.
           display the controls for the game.
]]

ControlsScreenState = Class{__includes = ControlsScreenState}

function ControlsScreenState:init() 
  -- initialize fonts
  self.font = love.graphics.newFont("fonts/SpecialElite.ttf", 20)
  self.title_font = love.graphics.newFont("fonts/SpecialElite.ttf", 30)

  self.title = "Controls"
  self.title_height = self.title_font:getHeight(self.title)
  self.title_width = self.title_font:getWidth(self.title)

  -- space between lines
  self.margin = 15

  self.controls = {
    "esc -> exit the app",
    "mouse -> interact with screen",
    "wasd -> move Anon",
    "enter (return) -> continue, interact with objects",
    --"q -> pause game"
  }
  self.control_height = self.font:getHeight(self.controls[1])
  
  -- back button
  self.btext = "Back"
  self.bwidth = self.font:getWidth(self.btext)
  self.bheight = self.font:getHeight(self.btext)
  self.bx = (WW * 0.5) - (self.bwidth * 0.5)
  self.blast = false
  self.bnow = false

  self.total_height = (self.title_height + self.margin) + ((self.control_height + self.margin) * #self.controls) + self.bheight
  local offset = (WH - self.total_height) * 0.5

  -- cursor to keep track of button y placements
  local y = self.title_height + self.margin + offset

  -- determine y positions
  self.title_y = offset
  self.ys = {}
  for i, control in ipairs(self.controls) do
    table.insert(self.ys, y)
    y = y + self.control_height + self.margin
  end
  self.by = y - self.control_height + self.bheight
  


end

function ControlsScreenState:enter() 
  -- do nothing (for now)
end

function ControlsScreenState:exit() 
  -- do nothing (for now)
end

function ControlsScreenState:update() 
  -- if back button is pressed, go back to title screen state
  local mx, my = love.mouse.getPosition()
  local hot = mx > self.bx and mx < self.bx + self.bwidth and
          my > self.by and my < self.by + self.bheight

  self.blast = self.bnow
  self.bnow = love.mouse.isDown(1) -- 1 = left click
  --and not self.blast
  if (self.bnow and hot) then
    STATE_MACHINE:change("title")
  end
end

function ControlsScreenState:render()
  -- set background color
  love.graphics.setBackgroundColor(unpack(BACK_COLOR))

  -- put title on screen
  love.graphics.print(
    self.title,
    self.title_font,
    (WW * 0.5) - (self.title_width * 0.5),
    self.title_y
  )

  -- put controls on screen
  for i, y in ipairs(self.ys) do
    love.graphics.print(
      self.controls[i],
      self.font,
      (WW * 0.5) - (self.font:getWidth(self.controls[i]) * 0.5),
      y
    )
  end

  -- put back button on screen
  love.graphics.setColor(unpack(BUTTON_COLOR))
  love.graphics.rectangle(
    "fill",
    self.bx,
    self.by,
    self.bwidth,
    self.bheight
  )
  love.graphics.setColor(unpack(BLACK))
  love.graphics.print(
    self.btext,
    self.font,
    self.bx,
    self.by
  )

end
