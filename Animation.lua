--[[ 
  programmer: Colton Ogden, cogden@cs50.harvard.edu
  adapted by: Kara Brown
  date: 7.28.2021
  purpose: Animation class.
]]

Animation = Class{}

function Animation:init(frames, interval)
  self.frames = frames
  self.interval = interval
  self.timer = 0
  self.current_frame = 1
end

function Animation:update(dt)
  -- if there is more than one frame to use, update it
  if #self.frames > 1 then
    self.timer = self.timer + dt

    if self.timer > self.interval then
      self.timer = self.timer % self.interval
      self.current_frame = math.max(1, (self.current_frame + 1) % (#self.frames + 1))
    end
  end

end

function Animation:getCurrentFrame()
  return self.frames[self.current_frame]
end