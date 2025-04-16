--Brian Hudick
--credits: vecteezy.com and creazilla.com for card suite vector art
require "card"
require "Graber"
io.stdout:setvbuf("no")


card_list = {}
deck = {}
draw_pile = {}
deckPointer = 1

screenWidth = 1280
screenHeight = 720


Suites = {"S", "H", "C", "D"}
Ranks = {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"}
Colors = {"B", "R"}


function love.load()
  love.window.setMode(screenWidth, screenHeight)
  
  grabber = GrabberClass:new()
  
  --initializing the cards
  local i = 50
  local j = 50
  for _, suite in ipairs(Suites) do
    
    print(tostring(j))
    for _, rank in ipairs(Ranks) do
      local card_instance = CardClass:new(i, j, suite, rank, "B", false)
      table.insert(card_list, card_instance)
      i = i + 50
    end
    i = 50
    j = j + 120
  end
  
  --putting the cards in the tableau stacks
  local starting_stack_x = 900
  local starting_stack_y = 50
  
  ShuffleDeck(card_list)
  
  local k = 1
  local l = 7
  local m = 1
  for l = 7, 1, -1 do
    for k = 1, l do 
      if k ~= l then
        card_list[m].flipped = true
      else
        card_list[m].flipped = false
      end
      card_list[m].position = Vector(starting_stack_x - (l*60), starting_stack_y + ((k-1)*starting_stack_y))
      m=m+1
    end
  end
  
  local n = 1
  for m = m, (#card_list) do
    table.insert(deck, card_list[m])
    card_list[m].position = Vector(100 + (10*n), 600)
    card_list[m].flipped = false
    n = n + 1
  end
end
function love.draw()
  love.graphics.setBackgroundColor( 0, 0.5, 0, 1 )
  love.graphics.print("Solitaire", 10, 10)
  
  local selected_card = nil
  
  for _, c in ipairs(card_list) do
    --checks for grabbed card
    if c:currentState() == 2 then
      selected_card = c
    end
    c:draw()
  end
  
  --draws selected card on top of all the rest
  if selected_card ~= nil then
    local y = 1
    for y=y, #deck do
      if deck[y] == selected_card then
        table.remove(deck, y)
      end
    end
    selected_card:draw()
  end
  --debug lines
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " .. tostring(grabber.currentMousePos.y))
end

function love.update(dt)
  grabber:update()
  checkForMouseMoving()
end

function love.keypressed(key, scancode, isrepeat)
  if key == "w" then
    deckDraw()
  end
end


function ShuffleDeck(tab)
    local i
    --math.randomseed(os.time)
    for i = #tab, 1, -1 do
      local j = math.random(i)
      tab[i], tab[j] = tab[j], tab[i]
    end
end

function deckDraw()
  if #deck == 0 then
    return
  end
  
  draw_pile = {}
  for r = 1, 3 do
    if deckPointer > #deck then
      deckPointer = 1
    end
    table.insert(draw_pile, deck[deckPointer])
    deckPointer = deckPointer + 1
  end
  --update the deck positions
  for p = 1, #deck do
    deck[p].position = Vector(100 + (50*p), 600)
  end
  
  --update draw pile positions
  for q = 1, #draw_pile do
    draw_pile[q].position = Vector(50, 100 + (50*q))
  end
end

function checkForMouseMoving()
  if grabber.currentMousePos == nil then
    return
  end
  
  for _, card in ipairs(card_list) do
    card:checkForMouseOver(grabber)
  end
end