--card prototypes
require "scripts/card"
require "scripts/Vector"

local beast = {}

testerClass = CardClass:new(
    0, 20, 
    "test", 
    1, 
    "test1TextDesc", 
    false,
    function(a, b, c)
      print("TestAbility1"..tostring(a)..tostring(b)..tostring(c))
    end
  )
table.insert(beast, testerClass)


testerClass2 = CardClass:new(
    0, 20, 
    "test2", 
    2, 
    "test2TextDesc", 
    false,
    function(a, b, c)
      print("TestAbility2"..tostring(a)..tostring(b)..tostring(c))
    end
  )
table.insert(beast, testerClass2)


testerClass3 = CardClass:new(
    0, 20, 
    "test3", 
    3, 
    "test3TextDesc", 
    false,
    function(a, b, c)
      print("TestAbility3"..tostring(a)..tostring(b)..tostring(c))
    end
  )
table.insert(beast, testerClass3)

return beast