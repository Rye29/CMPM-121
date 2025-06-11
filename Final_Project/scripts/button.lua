require "scripts/Vector"


ButtonClass = {}

function ButtonClass:new(xPos, yPos, text, sizeX, sizeY)
  local buttonClass = {}
  
  setmetatable(buttonClass, {__index = ButtonClass})
  
  buttonClass.position = Vector(xPos, yPos)
  buttonClass.Text = text
  
  buttonClass.size = Vector(sizeX, sizeY)
  return buttonClass
end

function ButtonClass:draw()
  love.graphics.setColor(1,1,1,1)
  love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y)
  love.graphics.setColor(0,0,0,1)
  love.graphics.print(self.Text, self.position.x+2, self.position.y+2);

end

function ButtonClass:checkForMouseOver()
  local mousePos = Vector(love.mouse.getX(), love.mouse.getY())
  local isMouseOver =
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
    
  return isMouseOver
end