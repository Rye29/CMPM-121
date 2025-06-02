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
    local copy = cardDataTable[i]
    local offset = 20
    local newCard = CardClass:new(self.position.x, self.position.y, copy.name, copy.cost, copy.text, copy.flipped, copy.ability, copy.power)
    newCard.flipped = true
    local newCard2 = CardClass:new(self.position.x, self.position.y, copy.name, copy.cost, copy.text, copy.flipped, copy.ability, copy.power)
    newCard.location = "deck"
    newCard2.location = "deck"
    newCard2.flipped = true
    --newCard.name = "test "..tostring(i)
    table.insert(self.Cards, newCard)
    table.insert(self.Cards, newCard2)

  end
  ShuffleDeck(self.Cards)
end

function ShuffleDeck(tab)
    local i
    for i = #tab, 1, -1 do
      local j = math.random(i)
      tab[i], tab[j] = tab[j], tab[i]
    end
end