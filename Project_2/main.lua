--Brian Hudick
--CMPM 121 - UCSC Spring 2025
--Professor Zach Emerzian
--Project 1: Solitaire
--Credits to assets in README
--4-17-2025

--credits: vecteezy.com and creazilla.com for card suite vector art
require "scripts/card"
require "scripts/Graber"
require "scripts/stacks"
require "scripts/button"
require "scripts/Observer"


io.stdout:setvbuf("no")


card_list = {}
deck = {}
draw_pile = {}
Suit_Stacks = {}
debug = false

Draw_Order = {Suit_Stacks, draw_pile}

screenWidth = 1280
screenHeight = 720
canClickDeck = true

Suites = {"S", "H", "C", "D"}
Ranks = {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"}
Card_Render_Order = {{}, {}, {}, {}}
Colors = {"B", "R"}


function love.load()
  love.window.setMode(screenWidth, screenHeight)
  love.window.setTitle("CMPM 121 Project 2: Solitaire - BHudick")
  grabber = GrabberClass:new()
  resetButton = ButtonClass:new(1200, 10, "reset", 60, 25)

  --creating the deck button
  deckButton = DeckClass:new(20, 40, 50, 80)
  
  winCon = ObserverClass:new()
  winObs = SubjectClass:new()
  winObs:subscribe(winCon)
  
  for s = 1, #Suites do
    local stack = StackClass:new(1100, 40+(100*(s-1)), 50, 80, 1)
    stack.suite = Suites[s]
    table.insert(Suit_Stacks, stack)
    table.insert(Draw_Order, stack.holding)
  end
  print("suite stack count: " .. tostring(#Suit_Stacks))
  table.insert(Draw_Order, grabber.grabbedItem)
  --initializing the cards
  local i = 50
  local j = 50
  
  local order_index = 1
  
  for _, suite in ipairs(Suites) do
    
    print(tostring(j))
    for _, rank in ipairs(Ranks) do
      local col = "B"
      if suite == 'H' or suite == 'D' then
        col = "R"
      end
      local card_instance = CardClass:new(i, j, suite, rank, col, false)
      table.insert(card_list, card_instance)
      table.insert(Card_Render_Order[order_index], card_instance)
      i = i + 50
    end
    i = 50
    j = j + 120
    order_index = order_index+1
  end
  
  --putting the cards in the tableau stacks
  local starting_stack_x = 900
  local starting_stack_y = 50
  
  ShuffleDeck(card_list)
  
  local k = 1
  local l = 7
  local m = 1
  
  for l = 7, 1, -1 do
    local st = StackClass:new(starting_stack_x - (l*60), starting_stack_y, 50, 80, 1)
    st.suite = "F"
    table.insert(Suit_Stacks, st)
    table.insert(Suit_Stacks[#Suit_Stacks].holding, card_list[m])
    print("peanuts")
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
  --  good implementation on track (m)
  local n = 1
  for m = m, (#card_list) do
    table.insert(deck, card_list[m])
    card_list[m].position = Vector(100 + (10*n), 1000)
    card_list[m].flipped = false
    card_list[m].isInDeck = true
    n = n + 1
  end
  
  if debug then
    for _, c in ipairs(card_list) do
      c.flipped = false
    end
  end
end
--|||||||--
--spacing--
--|||||||--
function love.draw()
  love.graphics.setBackgroundColor( 0, 0.5, 0, 1 )
  love.graphics.print("Solitaire", 10, 10)
  
  deckButton:draw()
  for _, drawable in ipairs(Draw_Order) do
    for _, C in ipairs(drawable) do
        
      C:draw();
      
      local chld = C.child
      while cld ~= nil do
        chld:draw()
        chld = chld.child
      end
      
    end
  end
  
  for i = 1, #card_list do
    if card_list[i].flipped then
      card_list[i]:draw()
    end
  end
  
  
  
  for i=#(Card_Render_Order[1]), 1, -1 do
    for j = 1, 4 do
      if not Card_Render_Order[j][i].flipped then
        Card_Render_Order[j][i]:draw()
      end
    end
  end
  
  for _, s in ipairs(Suit_Stacks) do
    if s.suite ~= "F" then
      for _, h in ipairs(s.holding) do
        h:draw()
      end
    end
  end
  
  
  local grab = grabber.grabbedItem[1]
  if grab ~= nil then
    grab:draw()
  end
  
  
  if(winCon.won == true) then
    love.graphics.setBackgroundColor( 0.5, 0, 0, 1 )
    love.graphics.print("You Win! Press 'Reset' to play again!", 440, 250, 0, 3, 3)
  end
  resetButton:draw()
  
  
  --debug lines (uncomment as needed for mouse position)
  --love.graphics.setColor(1, 1, 1, 1)
  --love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " .. tostring(grabber.currentMousePos.y))
end
--|||||||--
--spacing--
--|||||||--
function love.update(dt)
  selectCard();
  grabber:update(Suit_Stacks, Ranks, card_list, winObs, draw_pile)
  tableuUpdate()
  checkForMouseMoving()
  
  if deckButton:InputCheck(grabber) and canClickDeck then
    deckButton:deckDraw(deck, draw_pile)
    canClickDeck = false
  end
  
  if resetButton:checkForMouseOver() and canClickDeck and love.mouse.isDown(1) then
    gameReset()
    canClickDeck = false
  end
  
  if not love.mouse.isDown(1) then
    canClickDeck = true
  else
    canClickDeck = false
  end
  
end

--|||||||--
--spacing--
--|||||||--
--shuffles the deck at load time for true, pseudo-randomness
--  similar and good effecient way to shuffle (m)
function ShuffleDeck(tab)
    local i
    --math.randomseed(os.time)
    for i = #tab, 1, -1 do
      local j = math.random(i)
      tab[i], tab[j] = tab[j], tab[i]
    end
end
--|||||||--
--spacing--
--|||||||--
--takes three cards from the deck and puts them in a grabbable position
function selectCard()
  grabber.lastMoveValid = false;

  for _, c in ipairs(card_list) do
    --checks for grabbed card
    if c:currentState() == 2 then
      if grabber.grabbedItem[#grabber.grabbedItem] ~= c then
        table.insert(grabber.grabbedItem, c);
      end
    end
  end
  --draws selected card on top of all the rest
  local c
  for _, c in ipairs(deck) do
    local y = 1
    --removes card from the deck tracker if the card is from the deck
    for y=y, #deck do
      if deck[y] == c and c.isInDeck == false then
        table.remove(deck, y)
      end
    end
  end
  
end
--|||||||--
--spacing--
--|||||||--
function checkForMouseMoving()
  if grabber.currentMousePos == nil then
    return
  end
  
  for _, card in ipairs(card_list) do
    card:checkForMouseOver(grabber, canClickDeck)
  end
end
--|||||||--
--spacing--
--|||||||--
--makes the top card of the tableu stack  face up
function tableuUpdate()
  for m = 2, #card_list - 1 do
    if card_list[m] == grabber.LastCardGrabbed and grabber.lastMoveValid then
      card_list[m-1].flipped = false
      grabber.LastCardGrabbed = nil
    end
  end
end
--|||||||--
--spacing--
--|||||||--
  -- good gameReset idea that i forgot (m)
function gameReset()
  
  deck = {}
  draw_pile = {}
  grabber.grabbedItem = {}
  grabber.lastMoveValid = false
  
  for _, stacked in ipairs(Suit_Stacks) do
    stacked.nextRank = 1
    stacked.holding = {}
  end
  
  winCon:reset()
  
  for _, c in ipairs(card_list) do
    c.parent = nil
    c.isInDeck = false
  end
  ShuffleDeck(card_list)
  
  local starting_stack_x = 900
  local starting_stack_y = 50
  
  local k = 1
  local l = 7
  local m = 1
  
  local suit_stack_start = 5
  
  for l = 7, 1, -1 do
    
    table.insert(Suit_Stacks[suit_stack_start].holding, card_list[m])

    for k = 1, l do 
      if k ~= l then
        card_list[m].flipped = true
      else
        card_list[m].flipped = false
      end
      card_list[m].position = Vector(starting_stack_x - (l*60), starting_stack_y + ((k-1)*starting_stack_y))
      m=m+1
    end
    suit_stack_start = suit_stack_start + 1
  end
  
  
  --inserting the rest if the cards into the deck tracker
  local n = 1
  for m = m, (#card_list) do
    table.insert(deck, card_list[m])
    card_list[m].position = Vector(100 + (10*n), 1000)
    card_list[m].flipped = false
    card_list[m].isInDeck = true
    n = n + 1
  end
end
--|||||||--
--spacing--
--|||||||--
