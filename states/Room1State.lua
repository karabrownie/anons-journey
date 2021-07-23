--[[ 
programmer: Kara Brown
date: 7.22.2021
purpose: Room1State state machine class.
         displays room one - Anon's bedroom.
]]

Room1State = Class{__includes = BaseState}

function Room1State:init() 

  -- initialize font
  self.font = love.graphics.newFont("fonts/SpecialElite.ttf", 20)

  -- initialize Anon's room (for background)
  self.room = love.graphics.newImage("images/room.png")

end

function Room1State:enter() 
  -- do nothing (for now)
end

function Room1State:exit() 
  -- do nothing (for now)
end

function Room1State:update() 

end

function Room1State:render() 
  -- clear background colors to white
  love.graphics.setColor(unpack(WHITE))

  -- set background as Anon's room
  love.graphics.draw(self.room)


end