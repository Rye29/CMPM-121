--Brian Hudick
--CMPM 121 - UCSC Spring 2025
--Professor Zach Emerzian
--Project 3: CCG
--Credits to assets in README
--4-17-2025

--credits: vecteezy.com and creazilla.com for card suite vector art
require "scripts/card"
require "scripts/Vector"
require "scripts/deck"
require "scripts/player"



CardImport = require("scripts/CardData")

io.stdout:setvbuf("no")


screenWidth = 1280
screenHeight = 720
Card_List = {}


function love.load()

  love.window.setMode(screenWidth, screenHeight)
  love.window.setTitle("CMPM 121 Project 3: CCG - BHudick")
  
  CardIntel = {}
  for _, card in pairs(CardImport) do
    table.insert(CardIntel, card)
  end
  
  

  print(tostring(CardIntel) .. "hi")
 
  
  
  --x,y, activePos, handPos, deckPos, deckSize, discardOffest, handSize, CardPool
  player1 = UserClass:new(0, 430, 300, 10, 760, 20, 760, 7, CardIntel)
  player1.deck:populate(20, CardIntel)
  for i=1, 10 do
    player1:CardDraw()
  end
  player2 = AIClass:new(0, 0, 300, 10, 760, 20, 760, 7, CardIntel)
  player2.deck:populate(20, CardIntel)
  for i=1, 7 do
    player2:CardDraw()
  end

  
end
--|||||||--
--spacing--
--|||||||--
function love.draw()
  love.graphics.setBackgroundColor( 0, 0.5, 0, 1 )
  love.graphics.print("Casual Card Game", 10, 10)
  
  player1:draw()
  player2:draw()
  
end
--|||||||--
--spacing--
--|||||||--
function love.keypressed(key, scanCode, isRepeat)
  player2:inputUpdate(key)
  
  print(tostring(key))
end
--|||||||--
--spacing--
--|||||||--
function love.update(dt)
  player1.grabber:update(player1)
  --print()
end

--|||||||--
--spacing--
--|||||||--
