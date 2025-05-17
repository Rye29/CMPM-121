require "scripts/Vector"
require "scripts/deck"
require "scripts/card"



PlayerClass = {}


function PlayerClass:new(xPos, yPos, activeCardOffsetX, handOffsetX, deckOffsetX, maxDeckCards, maxHandSize, CardPool)
  local playerClass = {}
  setmetatable(playerClass, {__index = PlayerClass})
  
  playerClass.position = Vector(xPos, yPos)
  
  playerClass.activeCard = {}
  playerClass.selectedCard = nil
  playerClass.activePos = Vector(xPos+activeCardOffsetX, yPos+10)
  playerClass.selectedIndex = nil

  playerClass.hand = {}
  playerClass.handPos = Vector(xPos+handOffsetX, yPos+150)
  playerClass.handSize = maxHandSize
    
  playerClass.deck = DeckClass:new(xPos+deckOffsetX, yPos+10)
  playerClass.deckPos = Vector(xPos+deckOffsetX, yPos+10)
  playerClass.deckSize = maxDeckCards
  playerClass.deckPointer = 1
  playerClass.discardPile = {}

  
  playerClass.manaStock = 0
  playerClass.points = 0
  
  
  return playerClass
end


function PlayerClass:CardDraw()
  if #(self.hand) < self.handSize and self.deckPointer < self.deckSize then
    local card = self.deck.Cards[self.deckPointer]
    card.location = "hand"
    card.position.x = self.handPos.x + (90*#self.hand)
    card.position.y = self.handPos.y

    table.insert(self.hand, card)
    self.deckPointer = self.deckPointer + 1
  else
    print("hand is full")
  end
end

function PlayerClass:inputUpdate(key)
  if key == "w" then
    print("ws in chat")
    self:setSelectActive()
  elseif key == "1" then
    self:setSelect(1)
  elseif key == "2" then
    self:setSelect(2)
  elseif key == "3" then
    self:setSelect(3)
  elseif key == "4" then
    self:setSelect(4)
  elseif key == "5" then
    self:setSelect(5)
  elseif key == "6" then
    self:setSelect(6)
  elseif key == "7" then
    self:setSelect(7)
  else
    print("no key binded")
  end
end


function PlayerClass:setSelect(index)
  if self.selectedCard ~= nil then
    if self.hand[index] == nil then
      print("slot empty")
      return
    end
    self.selectedCard:resetOffset()
    self.selectedCard = self.hand[index]
    self.hand[index]:setOffset(0, -20)
    self.selectedIndex = index
    print("yeah")
  else
    if self.hand[index] == nil then
      print("slot empty")
      return
    end
    
    self.selectedCard = self.hand[index]
    self.hand[index]:setOffset(0, -20)
    self.selectedIndex = index

    print("yeah")
  end
end

function PlayerClass:setSelectActive()
  if self.selectedCard ~= nil then
    
    --put the selected card in the active slot
    self.selectedCard:resetOffset()
    
    self.selectedCard.position = self.activePos
    self.selectedCard.location = "active"
    
    table.insert(self.activeCard, self.selectedCard)
    
    table.remove(self.hand, self.selectedIndex)
    
    self.selectedIndex = nil
    
    --reposition the rest of the cards
    local i = 0
    for _, card in ipairs(self.hand) do
      card.position.x = self.handPos.x + (90*i)
      i = i + 1
    end
    
  end
end



function PlayerClass:draw()
  local width, height = love.graphics.getDimensions()
  local borderWidth = 5
  --main board
  love.graphics.setColor(0, 0.3, 0, 1)
  love.graphics.rectangle("fill", self.position.x, self.position.y, width, height*0.4, 5, 5)
  love.graphics.setColor(0, 0.5, 0, 1)
  love.graphics.rectangle("fill", self.position.x+borderWidth, self.position.y+borderWidth, width-(borderWidth*2), height*0.4-(borderWidth*2), 5, 5)

  --active slot
  love.graphics.setColor(0, 0.3, 0, 1)
  love.graphics.rectangle("fill", self.activePos.x, self.activePos.y, 80, 130, 5, 5)

  --hand slots
  love.graphics.setColor(0.3, 0, 0, 1)
  for i = 0, self.handSize-1 do
    love.graphics.rectangle("fill", self.handPos.x+90*i, self.handPos.y, 80, 130, 5, 5)
  end
  
  --score/mana
  love.graphics.print(("Mana: "..tostring(self.manaStock)), self.position.x+5, self.position.y+5, 0, 1.4, 1.4)
  love.graphics.print(("Points: "..tostring(self.points)), self.position.x+1200, self.position.y+260, 0, 1.4, 1.4)

  --deck pile
  love.graphics.setColor(0, 0, 0.3, 1)
  love.graphics.rectangle("fill", self.deckPos.x, self.deckPos.y, 80, 130, 5, 5)
  
  for _, card in pairs(self.deck.Cards) do
    card:draw()
  end


  return
end