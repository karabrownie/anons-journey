--[[ 
programmer: Kara Brown
date: 7.14.2021
purpose: Puzzle1State state machine class.
         displays puzzle one - CBT thought replacement.
]]

Puzzle1State = Class{__includes = BaseState}

function Puzzle1State:init() end

function Puzzle1State:enter() end

function Puzzle1State:exit() end

function Puzzle1State:update() end

function Puzzle1State:render() 
  -- set background color
  love.graphics.setBackgroundColor(unpack(BACK_COLOR))
end
