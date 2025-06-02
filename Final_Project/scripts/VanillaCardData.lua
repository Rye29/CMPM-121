--card prototypes
require "scripts/card"
require "scripts/Vector"

local beast = {}

woodCow = CardClass:new(
    0, 20, 
    "Wood Cow", 
    1, 
    "standard unit", 
    false,
    function(a, b, c)
      return
    end,
    1
  )

table.insert(beast, woodCow)


pegasus = CardClass:new(
    0, 20, 
    "Pegasus", 
    2, 
    "standard unit", 
    false,
    function(a, b, c)
      return
    end,
    2
  )

table.insert(beast, pegasus)


minotaur = CardClass:new(
    0, 20, 
    "Minotaur", 
    5, 
    "standard unit", 
    false,
    function(player1, player2, card)
      return
    end,
    9
  )

table.insert(beast, minotaur)

return beast