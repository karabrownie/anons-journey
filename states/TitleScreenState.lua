--[[
  programmer: Kara Brown
  date: 7.12.2021
  purpose: TitleScreenState machine state class.
           displays the main menu / title screen.
]]

TitleScreenState = Class{__includes = BaseState}


function TitleScreenState:init()
  local num_buttons = 5

  -- initialize fonts
  self.font = love.graphics.newFont("fonts/SpecialElite.ttf", 25)
  self.title_font = love.graphics.newFont("fonts/SpecialElite.ttf", 40)

  self.title_height = self.title_font:getHeight(TITLE)
  self.title_width = self.title_font:getWidth(TITLE)
  
  -- space between buttons
  self.margin = 15

  -- button width is one third of the window width
  local button_width = WW * (1/3)
  local button_height = 55
  self.total_height = (button_height + self.margin) * num_buttons

  -- x and y coordinates for button placement
  local bx = (WW * 0.5) - (button_width * 0.5)
  local bys = {}
  -- cursor to keep track of button y placements
  local y = self.title_height + self.margin

  -- determine the y placement for each button
  for i = 1, num_buttons, 1 do
    bys[i] = (WH * 0.5) - (self.total_height * 0.5) + y
    -- increment the height placement
    y = y + (button_height + self.margin)
  end

  -- make all the buttons that appear in the main menu
  self.buttons = {
    Button(
      "new game",
      function()
        state_machine:change("intro")
      end,
      bx,
      bys[1],
      button_width,
      button_height),
    Button(
      "load game",
      function()
        -- replace with actual code to load a game
        print("Loading game")
      end,
      bx,
      bys[2],
      button_width,
      button_height),
    Button(
      "controls",
      function()
        state_machine:change("controls")
      end,
      bx,
      bys[3],
      button_width,
      button_height),
    Button(
      "settings",
      function()
        -- replace with actual code to go to settings page
        print("Going to settings")
      end,
      bx,
      bys[4],
      button_width,
      button_height),
    Button(
      "exit",
      function()
        love.event.quit(0)
      end,
      bx,
      bys[5],
      button_width,
      button_height)
  }

end


function TitleScreenState:enter(enterparams)
  -- do nothing (for now)
end
 

function TitleScreenState:exit()
  -- do nothing (for now)
end
 

function TitleScreenState:update(dt)
  local mx, my = love.mouse.getPosition()
  
  -- if a button is clicked, call that button's functionality
  for i, button in ipairs(self.buttons) do
    local hot = mx > button.x and mx < button.x + button.width and
            my > button.y and my < button.y + button.height

    button.last = button.now
    button.now = love.mouse.isDown(1) -- 1 = left click
    -- and not button.last
    if button.now and hot then
      button.fn()
    end
  end

end


function TitleScreenState:render()
  -- set background color
  love.graphics.setBackgroundColor(unpack(BACK_COLOR))

  -- put the title on the screen
  love.graphics.print(
    TITLE,
    self.title_font,
    (WW * 0.5) - (self.title_width * 0.5),
    self.title_height
  )

  -- put each main menu button on the screen
  for i, button in ipairs(self.buttons) do
    button.last = button.now

    -- greyish rect
    local color = BUTTON_COLOR

    local mx, my = love.mouse.getPosition()
    local hot = mx > button.x and mx < button.x + button.width and
                my > button.y and my < button.y + button.height
    
    -- if the button is hot, highlight it
    if hot then
      color = HOT_COLOR
    end

    -- draw the rectangle
    love.graphics.setColor(unpack(color))
    love.graphics.rectangle(
      "fill",
      button.x,
      button.y,
      button.width,
      button.height
    )

    -- draw the black text in the rectangle
    love.graphics.setColor(unpack(BLACK))
    local textw = self.font:getWidth(button.label)
    local texth = self.font:getHeight(button.label)
    love.graphics.print(
      button.label,
      self.font,
      -- center the text in the rects
      (WW * 0.5) - (textw * 0.5),
      button.y + (texth * 0.5)
    )
  end

end

