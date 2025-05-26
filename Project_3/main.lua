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
require "scripts/GameManager"


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

  player2 = AIClass:new(0, 0, 300, 10, 760, 20, 760, 7, CardIntel)
  
  manager = GameManagerClass:new({player1, player2})
  
  manager:gameStart(CardIntel)
end
--|||||||--
--spacing--
--|||||||--
function love.draw()
  love.graphics.setBackgroundColor( 0, 0.5, 0, 1 )
  love.graphics.print("Casual Card Game", 10, 10)
  
  player1:draw()
  player1.playButton:draw()
  player2:draw()
  
end
--|||||||--
--spacing--
--|||||||--
function love.keypressed(key, scanCode, isRepeat)
  manager:keyUpdate(key)
  if(key == "[") and manager.UserTurn then
    player1:play()
  end
  
  if(key == "]") and not manager.UserTurn then
    player2:play()
  end
  print(tostring(key))
end
--|||||||--
--spacing--
--|||||||--
function love.update(dt)
  manager:update()
  --print()
end

--|||||||--
--spacing--
--|||||||--
