require "scripts/Vector"
require "scripts/Graber"


spade = love.graphics.newImage("assets/spade.jpeg")
heart = love.graphics.newImage("assets/heart.jpeg")
club = love.graphics.newImage("assets/club.jpeg")
diamond = love.graphics.newImage("assets/diamond.jpeg")

CardClass = {}
 
 CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}
 
 function CardClass:new(xPos, yPos, Suite, Rank, Color, Flipped)
   local cardClass = {}

   
   setmetatable(cardClass, {__index = CardClass})
   
   cardClass.position = Vector(xPos, yPos)
   cardClass.suite = Suite
   cardClass.rank = Rank
   cardClass.color = Color
   
   cardClass.size = Vector(50, 80)
   
   cardClass.state = CARD_STATE.IDLE
   cardClass.flipped = true
   cardClass.parent = nil
   
   return cardClass
 end
 
 function CardClass:draw()
    local Width = self.size.x
    local Height = self.size.y
    local card_scale = 0.03
    local card_thickness = 2

    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill", self.position.x-card_thickness/2, self.position.y-card_thickness/2, Width+card_thickness, Height+card_thickness, 5, 5)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill", self.position.x, self.position.y, Width, Height, 5, 5)
    if self.flipped == false then

      if self.color == "B" then
        love.graphics.setColor(0,0,0,1)
      else
        love.graphics.setColor(1,0,0,1)
      end
      love.graphics.print(self.rank, self.position.x, self.position.y)
      love.graphics.print(self.rank, self.position.x+Width-10, self.position.y+Height-15)
      love.graphics.setColor(1,1,1,1)
      if self.suite == "S" then
        love.graphics.draw(spade, self.position.x + Width/2-11, self.position.y + Height/2 - 12, 0, card_scale, card_scale)
      elseif self.suite == "H" then
        love.graphics.draw(heart, self.position.x + Width/2-8, self.position.y + Height/2 - 5, 0, card_scale, card_scale)
      elseif self.suite == "C" then
        love.graphics.draw(club, self.position.x + Width/2-11, self.position.y + Height/2 - 12, 0, card_scale, card_scale)
      else
        love.graphics.draw(diamond, self.position.x + Width/2-11, self.position.y + Height/2 - 12, 0, card_scale*0.5, card_scale*0.5)
        
      end
    else
      love.graphics.setColor(0.2,0.8,0,1)
      love.graphics.rectangle("fill", self.position.x+5, self.position.y+5, Width-10, Height-10, 5, 5)
    end
    
  end
  
 function CardClass:checkForMouseOver(grabber, canGrab)
  if self.state == CARD_STATE.GRABBED then
    if not love.mouse.isDown(1) then
      self.state = CARD_STATE.IDLE
      grabber.holding = false
      --print("Release")
      return
    end
    local copy_location = grabber.currentMousePos
    self.position = copy_location
    --print("Grabbed")
    return
  end
    self.position = self.position
    
  local mousePos = grabber.currentMousePos
  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  
  --self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
  if self.parent ~= nil then
    self.position = Vector(self.parent.position.x, self.parent.position.y + 20)
  end
  if isMouseOver and love.mouse.isDown(1) and not grabber.holding and self.flipped == false and canGrab then
    self.state = CARD_STATE.GRABBED
    grabber.holding = true
  else if isMouseOver then
    self.state = CARD_STATE.MOUSE_OVER
  else
    self.state = CARD_STATE.IDLE
  end
end
end
function CardClass:currentState()
  return self.state
end