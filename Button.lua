--[[
programmer: Kara Brown
date: 7.13.2021
purpose: button class
]]

Button = Class{}


function Button:init(label, fn, x, y, width, height)
  self.label = label
  self.fn = fn
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  now = false
  last = false
end