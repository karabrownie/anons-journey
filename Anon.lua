--[[ 
  programmer: Kara Brown
  date: 7.28.2021
  purpose: Anon class.
]]

Anon = Class{}

function Anon:init()
  self.images = {
    love.graphics.newImage("images/anons/stand_front.png"),
    love.graphics.newImage("images/anons/walk_front1.png"),
    love.graphics.newImage("images/anons/walk_front2.png"),
    love.graphics.newImage("images/anons/stand_back.png"),
    love.graphics.newImage("images/anons/walk_back1.png"),
    love.graphics.newImage("images/anons/walk_back2.png"),
    love.graphics.newImage("images/anons/stand_left.png"),
    love.graphics.newImage("images/anons/walk_left1.png"),
    love.graphics.newImage("images/anons/walk_left2.png"),
    love.graphics.newImage("images/anons/stand_right.png"),
    love.graphics.newImage("images/anons/walk_right1.png"),
    love.graphics.newImage("images/anons/walk_right2.png")
  }

  self.animations = {
    stand_front = {1},
    stand_back = {4},
    stand_left = {7},
    stand_right = {10},
    walk_front = {2, 1, 3, 1},
    walk_back = {5, 4, 6, 4},
    walk_left = {8, 7, 9, 7},
    walk_right = {11, 10, 12, 10}
  }

  self.interval = 0.2
  self.speed = 3

  self.state = "stand_front"
  self.frames = self.animations[self.state]
  self.animation = Animation(self.frames, self.interval)
  self.image = self.images[self.animation:getCurrentFrame()]

  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
  self.scale = 1.6

  self.x = (WW * 0.5) - (self.width * 0.5)
  self.y = (WH * 0.5) - (self.height * 0.5)

  self.xoffset = 40
  self.yoffset = 70

end


function Anon:update(dt)
  local last_state = self.state
  -- check for change in state
  if love.keyboard.isDown("w") then
    self.state = "walk_back"
    self.y = self.y - self.speed
  elseif love.keyboard.isDown("a") then
    self.state = "walk_left"
    self.x = self.x - self.speed
  elseif love.keyboard.isDown("s") then
    self.state = "walk_front"
    self.y = self.y + self.speed
  elseif love.keyboard.isDown("d") then
    self.state = "walk_right"
    self.x = self.x + self.speed
  elseif last_state == "walk_back" then
    self.state = "stand_back"
  elseif last_state == "walk_left" then
    self.state = "stand_left"
  elseif last_state == "walk_front" then
    self.state = "stand_front"
  elseif last_state == "walk_right" then
    self.state = "stand_right"
  end

  -- adjust xy if going off screen
  if self.x < self.xoffset then
    self.x = self.xoffset
  elseif self.x > (WW - self.width - self.xoffset) then
    self.x = WW - self.width - self.xoffset
  elseif self.y < self.yoffset then
    self.y = self.yoffset
  elseif self.y > (WH - self.height - self.yoffset) then
    self.y = WH - self.height - self.yoffset
  end

  -- adjust frames if state changed
  self.frames = self.animations[self.state]

  -- update the current frame
  if last_state ~= self.state then
    self.animation = Animation(self.frames, self.interval)
  end
  self.animation:update(dt)
  self.image = self.images[self.animation:getCurrentFrame()]
end


function Anon:render()
  love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale)
end

