require "scripts/Vector"
require "scripts/deck"
require "scripts/card"
require "scripts/Graber"
require "scripts/button"
require "scripts/notification"


PlayerClass = {}


function PlayerClass:new(xPos, yPos, activeCardOffsetX, handOffsetX, deckOffsetX, maxDeckCards, discardOffest, maxHandSize, CardPool, notif)
  local playerClass = {}
  setmetatable(playerClass, {__index = PlayerClass})
  
  playerClass.position = Vector(xPos, yPos)
  playerClass.notification = notif
    
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
  playerClass.discardPile = {}
  playerClass.discardPos = Vector(xPos+discardOffest, yPos+150)
  
  playerClass.userUI = nil

  playerClass.manaStock = 0
  playerClass.points = 0
  
  
  return playerClass
end


UserClass = PlayerClass:new(0, 0, 0, 0, 0, 0, 0, 0, {}, nil)

function UserClass:new(xPos, yPos, activeCardOffsetX, handOffsetX, deckOffsetX, maxDeckCards, discardOffest, maxHandSize, CardPool, notif)
  self.position = Vector(xPos, yPos)
  self.activePos = Vector(xPos+activeCardOffsetX, yPos+10)
  self.handPos = Vector(xPos+handOffsetX, yPos+150)
  self.deckPos = Vector(xPos+deckOffsetX, yPos+10)
  self.discardPos = Vector(xPos+discardOffest, yPos+150)
  self.deck.position = self.deckPos
  self.notification = notif
  
  self.handSize = maxHandSize
  self.deckSize = maxDeckCards
  self.userUI = true
  
  self.grabber = GrabberClass:new()
  self.playButton = ButtonClass:new(self.position.x+150, self.position.y+40, "Play Hand", 65, 20)
  return self
end

--resimplify this
AIClass = PlayerClass:new(0, 0, 0, 0, 0, 0, 0, 0, {}, nil)

function AIClass:new(xPos, yPos, activeCardOffsetX, handOffsetX, deckOffsetX, maxDeckCards, discardOffest, maxHandSize, CardPool, notif)
  self.position = Vector(xPos, yPos)
  self.activePos = Vector(xPos+activeCardOffsetX, yPos+10)
  self.handPos = Vector(xPos+handOffsetX, yPos+150)
  self.deckPos = Vector(xPos+deckOffsetX, yPos+10)
  self.discardPos = Vector(xPos+discardOffest, yPos+150)
  self.deck.position = self.deckPos
  self.notification = notif
  self.userUI = nil
  self.handSize = maxHandSize
  self.deckSize = maxDeckCards
  return self
end


function PlayerClass:CardDraw(flipped)
  if #(self.hand) < self.handSize then
    local card = self.deck.Cards[1]
    table.insert(self.hand, card)
    table.remove(self.deck.Cards, 1)
    card = self.hand[#self.hand]
    card.location = "hand"
    card.position.x = self.handPos.x + (90*#self.hand-90)
    card.position.y = self.handPos.y
    card.flipped = flipped

    
  else
    print("hand is full")
  end
end



function PlayerClass:draw()
  local width, height = love.graphics.getDimensions()
  local borderWidth = 5
  --main board
  love.graphics.setColor(65/255, 33/255, 28/255, 1)
  love.graphics.rectangle("fill", self.position.x, self.position.y, width, height*0.4, 5, 5)
  love.graphics.setColor(131/255, 66/255, 53/255, 1)
  love.graphics.rectangle("fill", self.position.x+borderWidth, self.position.y+borderWidth, width-(borderWidth*2), height*0.4-(borderWidth*2), 5, 5)

  --active slot
  love.graphics.setColor(0.3, 0, 0, 1)
  for i=0, 3 do 
    love.graphics.rectangle("fill", self.activePos.x+90*i, self.activePos.y, 80, 130, 5, 5)
  end

  --hand slots
  love.graphics.setColor(0.2, 0.2, 0.3, 1)

  for i = 0, self.handSize-1 do
    love.graphics.rectangle("fill", self.handPos.x+90*i, self.handPos.y, 80, 130, 5, 5)
  end
  
  --score/mana
  love.graphics.setColor(255/255, 204/255, 23/255, 1)
  love.graphics.print(("Mana: "..tostring(self.manaStock)), self.position.x+5, self.position.y+5, 0, 1.4, 1.4)
  love.graphics.print(("Points: "..tostring(self.points)), self.position.x+1180, self.position.y+260, 0, 1.4, 1.4)
  
  if self.userUI ~= nil then
    local cost = 0
    for _, card in ipairs(self.activeCard) do
      cost = cost + card.cost
    end
    love.graphics.print(("Cost: "..tostring(cost)), self.position.x+5, self.position.y+45, 0, 1.4, 1.4)
  end

  --deck pile
  love.graphics.setColor(0, 0, 0.3, 1)
  love.graphics.rectangle("fill", self.deckPos.x, self.deckPos.y, 80, 130, 5, 5)
  
  --discard pile
  love.graphics.setColor(0.15, 0.15, 0.15, 1)
  love.graphics.rectangle("fill", self.discardPos.x, self.discardPos.y, 80, 130, 5, 5)
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.print(("Discard: "..tostring(#self.discardPile)), self.discardPos.x+90, self.discardPos.y+110, 0, 1.4, 1.4)
  love.graphics.print(("Deck: "..tostring(#self.deck.Cards)), self.discardPos.x+90, self.discardPos.y+90, 0, 1.4, 1.4)
  love.graphics.print(("Hand: "..tostring(#self.hand)), self.discardPos.x+90, self.discardPos.y+70, 0, 1.4, 1.4)

  
  for _, card in pairs(self.deck.Cards) do
    card:draw()
  end
  
  for _, card in pairs(self.hand) do
    card:draw()
  end
  
  for _, card in pairs(self.activeCard) do
    card:draw()
  end
  
  for _, card in pairs(self.discardPile) do
    card:draw()
    break
  end

  return
end

function PlayerClass:validateActive()
  local total = 0
  for _, card in ipairs(self.activeCard) do
    total = total + card.cost
  end
  
  return (total <= self.manaStock)
end

function PlayerClass:play()
  if self:validateActive() then
    print("turn ended, next player!")
    self.turnObserver:changeTurn()
  else
    print("hand invalid")
    self.notification:activate("Not Enough Mana", 1, 2)
  end
end

--AI Functionality

function AIClass:inputUpdate(key)
  if key == "w" then
    self:setSelectActive()
  elseif key == "r" then
    self:returnHand(1)
  elseif key == "i" then
    self:insertDeck(1)
  elseif key == "d" then
    self:discardHand(1)
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
  elseif key == "l" then
    print(tostring(self:validateActive()))
  else
    print("no key binded")
  end
end

function AIClass:setSelect(index)
  if index > #self.hand then
    self.selectedCard = nil
    return
  end
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

function AIClass:setSelectActive()
  
  if self.selectedCard ~= nil and #self.activeCard < 4 then
    
    --put the selected card in the active slot
    self.selectedCard:resetOffset()
    
    self.selectedCard.position.x = self.activePos.x + #self.activeCard*90
    self.selectedCard.position.y = self.activePos.y
    self.selectedCard.location = "active"
    
    table.insert(self.activeCard, self.selectedCard)
    
    table.remove(self.hand, self.selectedIndex)
    
    self.selectedIndex = nil
    self.selectedCard = nil
    --reposition the rest of the cards
    local i = 0
    for _, card in ipairs(self.hand) do
      card.position.x = self.handPos.x + (90*i)
      i = i + 1
    end
    
  end
end

function AIClass:returnHand(count)
  local cardCount = count
  if(count > #self.activeCard) then
    cardCount = #self.activeCard
  end
  
  if #(self.activeCard) == 0 or #(self.hand) == self.handSize then
    print("hand empty, nothing to return or hand is full")
    return
  end
  print("function seco")
  for i=1, cardCount do
    local card = self.activeCard[i]
    card.location = "hand"
    card.position.x = self.handPos.x + 90*#self.hand
    card.position.y = self.handPos.y
    table.insert(self.hand, card)
    if #self.hand == self.handSize then
      break
    end
  end
  
  for i=1, cardCount do
    table.remove(self.activeCard, 1)
  end
  
  --reposition the rest of the cards
  local i = 0
  for _, card in ipairs(self.activeCard) do
    card.position.x = self.activePos.x + (90*i)
    i = i + 1
  end
end

function PlayerClass:discardHand(count)
  local cardCount = count
  if(count > #self.activeCard) then
    cardCount = #self.activeCard
  end
  if #(self.activeCard) == 0 then
    print("hand empty, nothing to discard")
    return
  end
  print("function delta")
  for i=1, cardCount do
    local card = self.activeCard[i]
    card.location = "discard"
    card.position.x = self.discardPos.x
    card.position.y = self.discardPos.y
    table.insert(self.discardPile, card)
    card.flipped = true
  end
  
  for i=1, cardCount do
    table.remove(self.activeCard, 1)
  end
  
  --reposition the rest of the cards
  local i = 0
  for _, card in ipairs(self.activeCard) do
    card.position.x = self.activePos.x + (90*i)
    i = i + 1
  end
end

function PlayerClass:insertDeck(count)
  local cardCount = count
  if(count > #self.activeCard) then
    cardCount = #self.activeCard
  end
  if #(self.activeCard) == 0 then
    print("hand empty, nothing to insert")
    return
  end
  print("function epsilon")
  for i=1, cardCount do
    local card = self.activeCard[i]
    card.location = "deck"
    card.position.x = self.deckPos.x
    card.position.y = self.deckPos.y
    table.insert(self.deck.Cards, card)
  end
  
  for i=1, cardCount do
    table.remove(self.activeCard, 1)
  end
  
  --reposition the rest of the cards
  local i = 0
  for _, card in ipairs(self.activeCard) do
    card.position.x = self.activePos.x + (90*i)
    i = i + 1
  end
end