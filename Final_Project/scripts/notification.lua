require "scripts/Vector"
NotificationClass = {}
function NotificationClass:new(xPos, yPos, length, height)
  local notificationClass = {}

  
  setmetatable(notificationClass, {__index = NotificationClass})

  notificationClass.position = Vector(xPos, yPos)
  notificationClass.visible = true
  notificationClass.text = "sample text"
  
  notificationClass.timer = 0
  notificationClass.scale = 1

  notificationClass.active = false
  notificationClass.size = Vector(length, height)
  
  return notificationClass
 end
 
function NotificationClass:activate(text, textScale, time)
  self.active = true
  self.timer = time
  self.scale = textScale
  self.text = text
end
 
function NotificationClass:draw()
  if self.active == false then
    return
  end
  
  love.graphics.setColor(1,1,1,1)
  love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y)
  love.graphics.setColor(0,0,0,1)
  love.graphics.print(self.text, self.position.x, (self.position.y+self.size.y/2)-15, 0, self.scale, self.scale)
  
  love.graphics.print("!", self.position.x+self.size.x*3/4, self.position.y + self.size.y*1/4, 0, 4, 4)

  
  if self.timer > 0 then
    self.timer = self.timer - love.timer.getDelta()
  else
    self.active = false
  end 
end