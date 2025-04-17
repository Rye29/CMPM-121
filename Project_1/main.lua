--Brian Hudick
--credits: vecteezy.com and creazilla.com for card suite vector art
require "scripts/card"
require "scripts/Graber"
require "scripts/stacks"
io.stdout:setvbuf("no")


card_list = {}
deck = {}
draw_pile = {}
Suit_Stacks = {}
deckPointer = 1

screenWidth = 1280
screenHeight = 720
canClickDeck = true


Suites = {"S", "H", "C", "D"}
Ranks = {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"}
Colors = {"B", "R"}


function love.load()
  love.window.setMode(screenWidth, screenHeight)
  
  grabber = GrabberClass:new()
  
  
  --creating the deck button
  deckButton = StackClass:new(20, 40, 50, 80, 0)
  
  for s = 1, #Suites do
    local stack = StackClass:new(1100, 40+(100*(s-1)), 50, 80, 1)
    stack.suite = Suites[s]
    table.insert(Suit_Stacks, stack)
  end
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
  
  
  --inserting the rest if the cards into the deck tracker
  local n = 1
  for m = m, (#card_list) do
    table.insert(deck, card_list[m])
    card_list[m].position = Vector(100 + (10*n), 1000)
    card_list[m].flipped = false
    n = n + 1
  end
end
function love.draw()
  love.graphics.setBackgroundColor( 0, 0.5, 0, 1 )
  love.graphics.print("Solitaire", 10, 10)
  
  deckButton:draw()
  for _, suite in ipairs(Suit_Stacks) do
    suite:draw()
  end
  
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
    --removes card from the deck tracker if the card is from the deck
    for y=y, #deck do
      if deck[y] == selected_card then
        table.remove(deck, y)
      end
    end
    selected_card:draw()
  end
  --debug lines (uncomment as needed for mouse position)
  --love.graphics.setColor(1, 1, 1, 1)
  --love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " .. tostring(grabber.currentMousePos.y))
end

function love.update(dt)
  grabber:update()
  checkForMouseMoving()
  tableuUpdate()
  --checks to see if the deck has been pressed (could be more optimized)
  if deckButton:InputCheck(grabber) and canClickDeck then
    deckDraw()
    canClickDeck = false
  end
  
  if not love.mouse.isDown(1) then
    canClickDeck = true
  end
end
--shuffles the deck at load time for true, pseudo-randomness
function ShuffleDeck(tab)
    local i
    --math.randomseed(os.time)
    for i = #tab, 1, -1 do
      local j = math.random(i)
      tab[i], tab[j] = tab[j], tab[i]
    end
end
--takes three cards from the deck and puts them in a grabbable position
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
    deck[p].position = Vector(100 + (50*p), 1000)
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
--makes the top card of the tableu stack  face up
function tableuUpdate()
  for m = 2, #card_list - 1 do
    if card_list[m].state == 2 then
      card_list[m-1].flipped = false
    end
  end
end