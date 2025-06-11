require "scripts/Vector"

CardClass = {}


function CardClass:new(xPos, yPos, name, cost, text,flipped, a, power)
  local cardClass = {}

  
  setmetatable(cardClass, {__index = CardClass})
  
  cardClass.position = Vector(xPos, yPos)
  cardClass.drawOffset = Vector(0, 0)
  
  cardClass.name = name
  cardClass.cost = cost
  cardClass.power = power
  cardClass.basePower = power

  cardClass.cost = cost

  cardClass.text = text

  
  cardClass.size = Vector(80, 130)
  
  cardClass.flipped = flipped
  cardClass.location = nil
  
  cardClass.ability = a
  
  return cardClass
 end
 
function CardClass:draw()
  local Width = self.size.x
  local Height = self.size.y
  local card_scale = 0.03
  local card_thickness = 2
  local xVal = self.drawOffset.x+ self.position.x
  local yVal = self.drawOffset.y+ self.position.y

  love.graphics.setColor(0,0,0,1)
  love.graphics.rectangle("fill", xVal-card_thickness/2, yVal-card_thickness/2, Width+card_thickness, Height+card_thickness, 5, 5)
  love.graphics.setColor(255/255, 204/255, 23/255, 1)
  love.graphics.rectangle("fill", xVal, yVal, Width, Height, 5, 5)
  
  if not self.flipped then
    love.graphics.setColor(186/255, 108/255, 60/255,1)
    love.graphics.rectangle("fill", xVal+5, yVal+5, Width-10, Height-10, 5, 5)

    
    love.graphics.setColor(0,0,1,1)
    love.graphics.print(self.cost, xVal+5, yVal+5)
    
    love.graphics.setColor(1,0,0,1)
    love.graphics.print(self.power, xVal+65, yVal+5)
    
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(self.name, xVal+10, yVal+20)
    love.graphics.print(self.text, xVal+10, yVal+40, 0, 0.6, 0.6)

  else
    love.graphics.setColor(128/255, 47/255, 29/255, 1)
    love.graphics.rectangle("fill", xVal+5, yVal+5, Width-10, Height-10, 5, 5)
  end
end
  
function CardClass:setOffset(x, y)
  self.drawOffset.x = self.drawOffset.x + x
  self.drawOffset.y = self.drawOffset.y + y

end

function CardClass:containsPoint(x, y)
    return x >= self.position.x and x <= self.position.x + self.size.x and y >= self.position.y and y <= self.position.y + self.size.y
end

function CardClass:resetOffset()
  self.drawOffset.x = 0
  self.drawOffset.y = 0
end