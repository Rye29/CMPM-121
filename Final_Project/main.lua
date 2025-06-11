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
require "scripts/Graber"
require "scripts/GameManager"
require "scripts/notification"


CardImport = require("scripts/CardData")
VanillaImport = require("scripts/VanillaCardData")
io.stdout:setvbuf("no")


screenWidth = 1280
screenHeight = 720
font = love.graphics.newFont("greek.ttf", 15)

Card_List = {}


function love.load()

  love.window.setMode(screenWidth, screenHeight)
  love.graphics.setFont(font)
  love.window.setTitle("CMPM 121 Project Final: Challengers of Athens")
  
  CardIntel = {}
  VanillaIntel = {}
  for _, card in pairs(CardImport) do
    table.insert(CardIntel, card)
  end
  
  for _, card in pairs(VanillaImport) do
    table.insert(VanillaIntel, card)
  end
   
  notif = NotificationClass:new(980, 320, 330, 70)
  
  player1 = UserClass:new(0, 430, 300, 10, 760, 20, 760, 7, CardIntel, notif)
  player2 = AIClass:new(0, 0, 300, 10, 760, 20, 760, 7, CardIntel, notif)
  
  manager = GameManagerClass:new({player1, player2}, 20, notif)

  manager:gameStart(CardIntel, VanillaIntel)
  
end





function love.draw()
  love.graphics.setBackgroundColor( 112/255, 54/225, 43/225, 1 )
  love.graphics.print("Challengers of Athens", 10, 10)
  
  player1:draw()
  player1.playButton:draw()
  player2:draw()
  
  love.graphics.setColor(1,1,1)
  if manager.UserTurn == true then
    love.graphics.print("Staging: player", 10, 350, 0, 2, 2)
  elseif manager.UserTurn == false then
    love.graphics.print("Staging: ai", 10, 350, 0, 2, 2)
  else
    love.graphics.print("Action phase" , 10, 350, 0, 2, 2)
  end
  
  player1.grabber:draw()
  
  love.graphics.setColor(1,1,1,1)
  love.graphics.print("Player Power: "..tostring(manager.playerPower), 400, 400, 0, 1.5, 1.5)
  love.graphics.print("AI Power: "..tostring(manager.aiPower) , 430, 310, 0, 1.5, 1.5)
  
  notif:draw()
  
  if manager.tutorial == true then
    manager:tutorialDraw()
  else
    love.graphics.print("Press 'i' for a tutorial/controls" , 5, 415)
  end
  
  if manager.winner ~= " " then
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(manager.winner.." has won! Press 'r' to play again!" , 300, 350, 0, 3, 3)
  end
end




function love.update()
  dt = love.timer.getDelta()
  manager:update(dt)
end





function love.keypressed(key)
  if manager.winner ~= " " then
    if key == 'r' then
      manager:gameStart(CardIntel, VanillaIntel)
    end
  end
end




function love.keyreleased(key)
   if key == "i" then
      manager.tutorial = not manager.tutorial
   end
end