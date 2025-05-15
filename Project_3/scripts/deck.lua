require "scripts/Vector"
require "scripts/card"

DeckClass = {}


function DeckClass:new(xPos, yPos)
  local deckClass = {}
  
  setmetatable(deckClass, {__index = DeckClass})

  
  deckClass.position = Vector(xPos, yPos)
  deckClass.Cards = {}
  
  return deckClass
  
end

function DeckClass:populate(count, cardDataTable)
  for i = 1, count do
    local copy = cardDataTable[3]
    local offset = 20
    local newCard = CardClass:new(self.position.x + i*offset-offset, self.position.y, copy.name, copy.cost, copy.text, copy.flipped, copy.ability)
    newCard.location = "deck"
    table.insert(self.Cards, newCard)
  end
end