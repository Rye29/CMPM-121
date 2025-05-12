--card prototypes
require "scripts/card"
require "scripts/Vector"

return {
  
  testerClass = CardClass:new(
    0, 20, 
    "test", 
    1, 
    "test1", 
    false,
    function(a, b, c)
      print("TestAbility1"..tostring(a)..tostring(b)..tostring(c))
    end
  ),
  
  testerClass2 = CardClass:new(
    80, 20, 
    "test2", 
    2, 
    "test2", 
    false,
    function(a, b, c)
      print("TestAbility2"..tostring(a)..tostring(b)..tostring(c))
    end
  )
  
  
}