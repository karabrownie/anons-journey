-- programmer: Kara Brown
-- date: 6.30.2021
-- purpose: main file for anon's journey. executes the game
--          beginning from the title screen and keeps track
--          of game states

-- functionality for new game and controls need implementation.
-- functionality for load game and settings can be implemented
--  after summer 2021.

require "constants"
-- allows us to create class structures for sprites and objects
Class = require "class"
require "Button"
-- allows us to create game states
require "StateMachine"
require "states/TitleScreenState"
require "states/IntroState"
require "states/Puzzle1State"


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
  -- app window title
  love.window.setTitle(TITLE)

  -- initialize state machine
  STATE_MACHINE = StateMachine{
    ["title"] = function() return TitleScreenState() end,
    ["intro"] = function() return IntroState() end,
    ["puzzle1"] = function() return Puzzle1State() end
  }

  -- set to first machine state
  STATE_MACHINE:change("title")

  -- initialize keyboard input
  love.keyboard.keysPressed = {}

end


function love.update(dt)

  STATE_MACHINE:update(dt)

  love.keyboard.keysPressed = {}

end


function love.draw()
  
  STATE_MACHINE:render()

end