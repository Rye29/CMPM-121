--card prototypes
require "scripts/card"
require "scripts/Vector"

local beast = {}

zeus = CardClass:new(
    0, 20, 
    "Zeus", 
    4, 
    "This cards power\ndoubles if it's\nthe only one\nstaged", 
    false,
    function(player1, player2, cardSelf)
      if #player1.activeCard == 1 then
        cardSelf.power = cardSelf.power * 2
      end
    end,
    6
  )
  
table.insert(beast, zeus)

apollo = CardClass:new(
    0, 20, 
    "Apollo", 
    5, 
    "Discard the first\ncard in your\nopponent's stage", 
    false,
    function(player1, player2, cardSelf)
      player2:discardHand(1)
    end,
    0
  )
  
table.insert(beast, apollo)

hades = CardClass:new(
    0, 20, 
    "Hades", 
    4, 
    "Gain +1 power for\neach card in your\ndiscard pile.", 
    false,
    function(player1, player2, cardSelf)
      cardSelf.power = cardSelf.power + #player1.discardPile
    end,
    5
  )
  
table.insert(beast, hades)

hydra = CardClass:new(
    0, 20, 
    "Hydra", 
    2, 
    "+2 power for every\ncard the enemy has\nthat has more power\nthan the hydra", 
    false,
    function(player1, player2, cardSelf)
      for _, card in ipairs(player2.activeCard) do
        if card.power > cardSelf.basePower then
          cardSelf.power = cardSelf.power + 2
        end
      end
    end,
    2
  )
  
table.insert(beast, hydra)
  
artemis = CardClass:new(
    0, 20, 
    "Artemis", 
    5, 
    "Gain +5 power if\nthere is exactly\none enemy card", 
    false,
    function(player1, player2, cardSelf)
      if #player2.activeCard == 1 then
        cardSelf.power = cardSelf.power + 5
      end
    end,
    3
  )
  
table.insert(beast, artemis)

demeter = CardClass:new(
    0, 20, 
    "Demeter", 
    2, 
    "Both players draw\na card", 
    false,
    function(player1, player2, cardSelf)
      player1:CardDraw(false)
      player2:CardDraw(false)
    end,
    1
  )

table.insert(beast, demeter)

hercules = CardClass:new(
    0, 20, 
    "Hercules", 
    6, 
    "Power triples if\nenemy has at least\n10 score more\nthan user", 
    false,
    function(player1, player2, cardSelf)
      if player2.points - player1.points >= 10 then
        cardSelf.power = cardSelf.power * 3
      end
    end,
    5
  )
  
table.insert(beast, hercules)


medusa = CardClass:new(
    0, 20, 
    "Medusa", 
    4, 
    "Lower the power\nof your opponent's\ncards by 1 each", 
    false,
    function(player1, player2, cardSelf)
      for _, card in ipairs(player2.activeCard) do
        card.power = card.power - 1
      end
    end,
    1
  )

table.insert(beast, medusa)


jason = CardClass:new(
    0, 20, 
    "Jason", 
    3, 
    "+3 power for this\ncard if the golden\nfleece is in play\non either side", 
    false,
    function(player1, player2, cardSelf)
      for _, card in ipairs(player1.activeCard) do
        if card.name == "Golden Fleece" then
          cardSelf.power = cardSelf.power + 3
          return
        end
      end
      
      for _, card in ipairs(player2.activeCard) do
        if card.name == "Golden Fleece" then
          cardSelf.power = cardSelf.power + 3
          return
        end
      end
    end,
    3
  )

table.insert(beast, jason)

fleece = CardClass:new(
    0, 20, 
    "Gold Fleece", 
    3, 
    "+1 power for all\ncards the side this\nis played", 
    false,
    function(player1, player2, cardSelf)
      for _, card in ipairs(player1.activeCard) do
        if card ~= cardSelf then
          card.power = card.power + 1
        end
      end
    end,
    1
  )

table.insert(beast, fleece)



return beast