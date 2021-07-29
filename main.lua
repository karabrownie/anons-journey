--[[
  programmer: Kara Brown
  date: 6.30.2021
  purpose: main file for anon's journey. executes the game
           beginning from the title screen and keeps track
           of game states

  - functionality for new game and controls need implementation.
  - functionality for load game and settings to be implemented
    after summer 2021.

  things to make prettier:
  - add title screen art / adjust colors
  - add controls screen art / adjust colors
  - add monologue art / adjust colors
]]

require "constants"
-- allows us to create class structures for sprites and objects
Class = require "class"
require "Button"
-- allows us to create game states
require "StateMachine"
require "states/TitleScreenState"
require "states/IntroState"
require "states/ControlsScreenState"
require "states/Puzzle1State"
require "states/Room1State"

require "Animation"
require "Anon"


-- game states
-- title -> title screen / main menu 
-- intro -> internal monologue 
-- puzzle1 -> puzzle one 
-- room1 -> room one 

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true
  -- terminates the game if esc is pressed
  if key == "escape" then
    love.event.quit()
  end

end

function love.keyboard.wasPressed(key)
  return love.keyboard.keysPressed[key]
end


function love.load()
  -- initialize window width and height
  WW = WINDOW_WIDTH
  WH = WINDOW_HEIGHT

  -- set window dimensions
  success = love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false, 
    resizable = false, 
    vsync = true
  })

  -- app window title
  love.window.setTitle(TITLE)

  -- initialize state machine
  state_machine = StateMachine{
    ["title"] = function() return TitleScreenState() end,
    ["intro"] = function() return IntroState() end,
    ["controls"] = function() return ControlsScreenState() end,
    ["puzzle1"] = function() return Puzzle1State() end,
    ["room1"] = function() return Room1State() end
  }

  -- set to first machine state
  state_machine:change("title")

  -- initialize keyboard input
  love.keyboard.keysPressed = {}

end


function love.update(dt)

  -- get the width and height of the window (if resizable)
  --WW = love.graphics.getWidth()
  --WH = love.graphics.getHeight()

  state_machine:update(dt)

  love.keyboard.keysPressed = {}

end


function love.draw()
  
  state_machine:render()

end