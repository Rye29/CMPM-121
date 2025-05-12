--Brian Hudick
--CMPM 121 - UCSC Spring 2025
--Professor Zach Emerzian
--Project 3: CCG
--Credits to assets in README
--4-17-2025

--credits: vecteezy.com and creazilla.com for card suite vector art
require "scripts/card"
require "scripts/Vector"

CardIntel = require("scripts/CardData")


io.stdout:setvbuf("no")


screenWidth = 1280
screenHeight = 720
Card_List = {}


function love.load()

  love.window.setMode(screenWidth, screenHeight)
  love.window.setTitle("CMPM 121 Project 3: CCG - BHudick")
  
end
--|||||||--
--spacing--
--|||||||--
function love.draw()
  love.graphics.setBackgroundColor( 0, 0.5, 0, 1 )
  love.graphics.print("Casual Card Game", 10, 10)
  
  for _, card in pairs(CardIntel) do
    card:draw()
  end
end
--|||||||--
--spacing--
--|||||||--
function love.update(dt)
  
end

--|||||||--
--spacing--
--|||||||--
