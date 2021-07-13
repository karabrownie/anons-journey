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



-- game states
-- 0 title screen / main menu 
-- 1 intro / internal monologue 
-- 2 puzzle one 
-- 3 room one 

function love.keypressed(key)
  -- terminates the game if esc is pressed
  if key == "escape" then
    love.event.quit()
  end

end


function love.load()
  -- app window title
  love.window.setTitle(TITLE)

  -- initialize state machine
  STATE_MACHINE = StateMachine{
    ["title"] = function() return TitleScreenState() end,
    ["intro"] = function() return IntroState() end
  }

  -- set to first machine state
  STATE_MACHINE:change("title")

  -- initialize keyboard input
  love.keyboard.keysPressed = {}

end


function love.update(dt)

  STATE_MACHINE:update(dt)

end


function love.draw()
  
  STATE_MACHINE:render()

end