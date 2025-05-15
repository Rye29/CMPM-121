require "scripts/Vector"
require "scripts/deck"
require "scripts/card"



PlayerClass = {}


function PlayerClass:new(xPos, yPos, activeCardOffsetX, handOffsetX, deckOffsetX, maxDeckCards, maxHandSize, CardPool)
  local playerClass = {}
  setmetatable(playerClass, {__index = PlayerClass})
  
  playerClass.position = Vector(xPos, yPos)
  
  playerClass.activeCard = nil
  playerClass.activePos = Vector(xPos+activeCardOffsetX, yPos+10)

  playerClass.hand = {}
  playerClass.handPos = Vector(xPos+handOffsetX, yPos+150)
  playerClass.handSize = maxHandSize
    
  playerClass.deck = DeckClass:new(xPos+deckOffsetX, yPos+10)
  playerClass.deckPos = Vector(xPos+deckOffsetX, yPos+10)
  playerClass.discardPile = {}

  
  playerClass.manaStock = 0
  playerClass.points = 0
  
  
  return playerClass
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