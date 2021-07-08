-- programmer: Kara Brown
-- file: main.lua
-- date: 6.30.2021
-- purpose: main file for anon's journey. 
--          displays the main menu

-- functionality for new game and controls need implementation.
-- functionality for load game and settings can be implemented
--  after summer 2021.

BACK_COLOR = {0.27, 0.27, 0.27, 1.0}
BUTTON_COLOR = {0.4, 0.4, 0.5, 1.0}
HOT_COLOR = {0.8, 0.8, 0.9, 1.0}
BLACK = {0, 0, 0, 1}

local
function newButton(text, fn)
  return {
    text = text,
    fn = fn,
    now = false,
    last = false
  }
end

local title = "Anon's Journey"
local buttons = {}
local font = nil

function love.load()

  font = love.graphics.newFont("fonts/SpecialElite.ttf", 25)
  title_font = love.graphics.newFont("fonts/SpecialElite.ttf", 40)

  table.insert(buttons, newButton(
    "new game",
    function()
      -- replace with actual code to start a new game
      print("Making new game")
    end))

  table.insert(buttons, newButton(
    "load game",
    function()
      -- replace with actual code to load a game
      print("Loading game")
    end))

  table.insert(buttons, newButton(
    "controls",
    function()
      -- replace with actual code to go to controls page
      print("Going to controls")
    end))

  table.insert(buttons, newButton(
    "settings",
    function()
      -- replace with actual code to go to settings page
      print("Going to settings")
    end))

  table.insert(buttons, newButton(
    "exit",
    function()
      love.event.quit(0)
    end))

end

function love.update(dt)
end


function love.draw()
  -- set background color
  love.graphics.setBackgroundColor(unpack(BACK_COLOR))

  -- get the width and height of the window
  local ww = love.graphics.getWidth()
  local wh = love.graphics.getHeight()

  -- button width is one third of the window width
  local button_width = ww * (1/3)
  local button_height = 55
  local margin = 15
  local total_height = (button_height + margin) * #buttons

  -- put the title on the screen
  local title_height = font:getHeight(title)
  local title_width = font:getWidth(title)
  love.graphics.print(
    title,
    title_font,
    (ww * 0.5) - (title_width * 0.8),
    title_height
  )

  local cursor_y = title_height + margin

  -- put each main menu button on the screen
  for i, button in ipairs(buttons) do
    button.last = button.now

    -- button width and height
    local bx = (ww * 0.5) - (button_width * 0.5)
    local by = (wh * 0.5) - (total_height * 0.5) + cursor_y

    -- greyish rect
    local color = BUTTON_COLOR
    local mx, my = love.mouse.getPosition()
    local hot = mx > bx and mx < bx + button_width and
                my > by and my < by + button_height
    
    -- if the button is hot, highlight it
    if hot then
      color = HOT_COLOR
    end

    -- if button is clicked, call that button's functionality
    button.now = love.mouse.isDown(1) -- 1 = left click
    if button.now and not button.last and hot then
      button.fn()
    end

    love.graphics.setColor(unpack(color))
    love.graphics.rectangle(
      "fill",
      bx,
      by,
      button_width,
      button_height
    )
 
    -- black text
    love.graphics.setColor(unpack(BLACK))
    local textw = font:getWidth(button.text)
    local texth = font:getHeight(button.text)
    love.graphics.print(
      button.text,
      font,
      -- center the text in the rects
      (ww * 0.5) - (textw * 0.5),
      by + (texth * 0.5)
    )

    -- increment the height placement
    cursor_y = cursor_y + (button_height + margin)
  end
end