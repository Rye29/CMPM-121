require "scripts/Vector"

StackClass = {}
STACKTYPE = {DECK = 0, SUIT = 1}

spade = love.graphics.newImage("assets/spade.jpeg")
heart = love.graphics.newImage("assets/heart.jpeg")
club = love.graphics.newImage("assets/club.jpeg")
diamond = love.graphics.newImage("assets/diamond.jpeg")

function StackClass:new(xPos, yPos, Length, Height, stackType)
  local stackClass = {}
  stackClass.suite = nil
  stackClass.holding = {}
  stackClass.nextRank = 1
    
  setmetatable(stackClass, {__index = StackClass})
    
  stackClass.position = Vector(xPos, yPos)
  stackClass.size = Vector(Length, Height)
  stackClass.Type = stackType
    
  return stackClass
end


DeckClass = {}


function DeckClass:new(xPos, yPos, Length, Height)
  local instance = StackClass:new(xPos, yPos, Length, Height, 0)
  setmetatable(instance, {__index = DeckClass})

  instance.deckPointer = 1
  return instance
end

function DeckClass:draw()
  local Width = self.size.x
  local Height = self.size.y
  local card_scale = 0.03
  local card_thickness = 2
  
  love.graphics.setColor(0,0,0,1)
  love.graphics.rectangle("fill", self.position.x-card_thickness/2, self.position.y-card_thickness/2, Width+card_thickness, Height+card_thickness, 5, 5)
  love.graphics.setColor(1,1,1,1)
  love.graphics.rectangle("fill", self.position.x, self.position.y, Width, Height, 5, 5)
    
  love.graphics.setColor(0.2,0.8,0,1)
  love.graphics.rectangle("fill", self.position.x+5, self.position.y+5, Width-10, Height-10, 5, 5)
end

function DeckClass:deckDraw(deckTable, draw_pile)
  if #deckTable == 0 then
    return
  end
  if(draw_pile == 0) then
    draw_pile = {0, 0, 0}
  end
  for r = 1, 3 do
    if self.deckPointer > #deckTable then
      self.deckPointer = 1
    end
    draw_pile[r] = deckTable[self.deckPointer]
    self.deckPointer = self.deckPointer + 1
  end
  --update the deck positions
  for p = 1, #deckTable do
    deckTable[p].position = Vector(100 + (50*p), 1000)
  end
  --update draw pile positions
  for q = 1, #draw_pile do
    draw_pile[q].position = Vector(50, 100 + (100*q))
  end
end

function StackClass:draw()
  
  local Width = self.size.x
  local Height = self.size.y
  local card_scale = 0.03
  local card_thickness = 2
  
  
    love.graphics.setColor(12/255,116/255,21/255,1)
    love.graphics.rectangle("fill", self.position.x, self.position.y, Width, Height, 5, 5)
    love.graphics.setColor( 0, 0.5, 0, 1 )
    love.graphics.rectangle("fill", self.position.x+5, self.position.y+5, Width-10, Height-10, 5, 5)
    love.graphics.setColor(12/255,116/255,21/255,1)
    
    if self.suite == "S" then
        love.graphics.draw(spade, self.position.x + Width/2-11, self.position.y + Height/2 - 12, 0, card_scale, card_scale)
      elseif self.suite == "H" then
        love.graphics.draw(heart, self.position.x + Width/2-8, self.position.y + Height/2 - 5, 0, card_scale, card_scale)
      elseif self.suite == "C" then
        love.graphics.draw(club, self.position.x + Width/2-11, self.position.y + Height/2 - 12, 0, card_scale, card_scale)
      elseif self.suite == "D" then
        love.graphics.draw(diamond, self.position.x + Width/2-11, self.position.y + Height/2 - 12, 0, card_scale*0.5, card_scale*0.5)
      end
end

function StackClass:isOver(grabber)
  local mousePos = grabber.currentMousePos
  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  return isMouseOver
end

function StackClass:InputCheck(grabber)
  local mousePos = grabber.currentMousePos
  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  if isMouseOver and love.mouse.isDown(1) and not grabber.holding then
    return true
  else
    return false
  end
end

function DeckClass:InputCheck(grabber)
  local mousePos = grabber.currentMousePos
  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  if isMouseOver and love.mouse.isDown(1) and not grabber.holding then
    return true
  else
    return false
  end
end