GameManagerClass = {}


function GameManagerClass:new(playerTable, score, notif)
  local managerClass = {}
  
  setmetatable(managerClass, {__index = GameManagerClass})
  
  managerClass.Cycle = 1
  
  managerClass.players = playerTable
  managerClass.UserTurn = true
  managerClass.lastWinner = nil
  managerClass.winner = " "
  managerClass.winScore = score
  
  managerClass.waiting = false
  managerClass.waiter = 0
  managerClass.eventQueue = {}
  
  managerClass.notification = notif
  
  managerClass.playerPower = 0
  managerClass.aiPower = 0

  
  managerClass.Observers = {}
  local turnObserver = ObserverClass:new(managerClass)
  table.insert(managerClass.Observers, turnObserver)
  
  managerClass.tutorial = false
  
  return managerClass
 end
 
 ObserverClass = {}
function ObserverClass:new(manager)
  local observerClass = {}
  observerClass.manager = manager
  setmetatable(observerClass, {__index = ObserverClass})
  return observerClass
end
 
function GameManagerClass:gameStart(CardIntel, VanillaIntel)
  self.Cycle = 1
  self.UserTurn = true
  for _, player in ipairs(self.players) do
    player.discardPile = {}
    player.activeCard = {}
    player.hand = {}
    player.deck.Cards = {}
    player.deck:populate(#CardIntel, CardIntel)
    local j = 1
    for _, card in ipairs(VanillaIntel) do
      local newCard = CardClass:new(card.position.x, card.position.y, card.name, card.cost, card.text, card.flipped, card.ability, card.power)
      newCard.location = "deck"
      table.insert(player.deck.Cards, j, newCard)
      j = j + 1
    end
    
    
    for i=1, 3 do
      player:CardDraw(false)
    end
    player.manaStock = self.Cycle
    player.points = 0
    player.turnObserver = self.Observers[1]
  end
  
  for _, card in ipairs(self.players[2].hand) do
    card.flipped = true
  end
  self.players[1]:CardDraw(false)

  self.winner = " "
end

function GameManagerClass:update(dt)
  
  if self.tutorial == true then
    return
  end
  
  if self.winner == " " then
    if self.UserTurn == true then
      self.players[1].grabber:update(self.players[1])
    elseif self.UserTurn == nil then
      for _, card in ipairs(player2.hand) do
        card.flipped = true
      end
      
      if self.waiting == false then
        self.eventQueue[1]()
        table.remove(self.eventQueue, 1)
      else
        self:wait(1.00, dt)
      end
    end
  end
end

function GameManagerClass:keyUpdate(key)
  if self.UserTurn == false then
    self.players[2]:inputUpdate(key)
  end
end

 

function ObserverClass:changeTurn()
  if manager.UserTurn == true then
    --ai behaviour
    manager.UserTurn = false
    aiBehaviour(manager)
  else
    --setup end of cycle
    manager.UserTurn = nil
    local first = 0
    if manager.lastWinner == nil then
      first = math.floor(math.random(0,2)+0.5)
    elseif manager.lastWinner == manager.players[1] then
      first = 1
    else
      first = 2
    end
    
    table.insert(manager.eventQueue, function() manager:flipCards(manager.players[1], true) end)

    
    if first == 1 then
      table.insert(manager.eventQueue, function() manager:flipCards(manager.players[1], true) end)
      table.insert(manager.eventQueue, function() manager:flipCards(manager.players[2], true) end)
      
      table.insert(manager.eventQueue, function() manager:playCards(manager.players[1], manager.players[2]) end)
      table.insert(manager.eventQueue, function() manager:playCards(manager.players[2], manager.players[1]) end)

    else
      table.insert(manager.eventQueue, function() manager:flipCards(manager.players[2], true) end)      
      table.insert(manager.eventQueue, function() manager:flipCards(manager.players[1], true) end)
      
      table.insert(manager.eventQueue, function() manager:playCards(manager.players[2], manager.players[1]) end)
      table.insert(manager.eventQueue, function() manager:playCards(manager.players[1], manager.players[2]) end)
      
    end
    table.insert(manager.eventQueue, function() manager:finishCycle() end)
  end
end

function aiBehaviour(manager)
  local card_count = math.floor(math.random(1,5))
  manager.players[2]:CardDraw(true)
    if card_count < 1 then
      card_count = 1
    end
    for i=1, card_count do
      local cost = 0
      for _, card in ipairs(manager.players[2].activeCard) do
        cost = cost + card.cost
      end
      if #manager.players[2].activeCard == (4) or manager.players[2].hand[1].cost + cost > manager.players[2].manaStock then
        break
      end
      
      manager.players[2]:setSelect(1)
      manager.players[2]:setSelectActive()
    end
    --tries to guarantee at least one card
    if #manager.players[2].activeCard < 1 then
      for i=1, #manager.players[2].hand do
        if manager.players[2].hand[i].cost < manager.players[2].manaStock then
          manager.players[2]:setSelect(i)
          manager.players[2]:setSelectActive()
          break
        end
      end
    end
    manager.players[2]:play()
end

function GameManagerClass:playCards(player1, player2)
  for _, card in ipairs(player1.activeCard) do
    card.flipped = false
    card.ability(player1,player2,card)
  end
  self:updatePlayerPowers(self.players[1], 1)
  self:updatePlayerPowers(self.players[2], 2)

  self.waiting = true
end

function GameManagerClass:flipCards(player, wait)
  for _, card in ipairs(player.activeCard) do
    card.flipped = not card.flipped
  end
  if self.players[1].activeCard[1] ~= nil then
    if self.players[1].activeCard[1].flipped== false then
      self:updatePlayerPowers(self.players[1], 1)
    end
  end
  if self.players[2].activeCard[1] ~= nil then
    if self.players[2].activeCard[1].flipped== false then
      self:updatePlayerPowers(self.players[2], 2)
    end
  end

  if wait then
    self.waiting = true
  end
end

function GameManagerClass:finishCycle()
  local score1 = 0
  local score2 = 0
  for _, card in ipairs(self.players[1].activeCard) do
    score1 = score1 + card.power
    card.power = card.basePower
  end
  for _, card in ipairs(self.players[2].activeCard) do
    score2 = score2 + card.power
    card.power = card.basePower

  end
  
  local score3 = score2 - score1
  
  if score3 > 0 then
    self.lastWinner = self.players[2]
    self.players[2].points = self.players[2].points + math.abs(score3)
    self.notification:activate("AI wins this round! They earned:\n"..tostring(math.abs(score3)).." points", 1, 3)
  elseif score3 < 0 then
    self.lastWinner = self.players[1]
    self.players[1].points = self.players[1].points + math.abs(score3)
    self.notification:activate("Player takes the round! They earned:\n"..tostring(math.abs(score3)).." points", 1, 3)
  else
    self.lastWinner = nil
    self.notification:activate("Tie! No points Awarded", 1, 3)

  end
  self.players[2]:returnHand(#self.players[2].activeCard)
  
  
  
  if #self.players[2].activeCard > 0 then
    self.players[2]:discardHand(#self.players[2].activeCard)
  end
  
  for _, card in ipairs(self.players[2].hand) do
    card.flipped = true
  end
  
  if self.players[1].points >= self.winScore then
    self.winner = "Player"
  elseif self.players[2].points >= self.winScore then
    self.winner = "AI"
  end
  
  self.playerPower = 0
  self.aiPower = 0
  
  self.players[1]:CardDraw(false)

  self.UserTurn = true
  self.Cycle = self.Cycle + 1
  for _, player in ipairs(self.players) do
    player.manaStock = self.Cycle
  end
end

function GameManagerClass:wait(waitTime, dt)
  self.waiter = self.waiter + dt
  if self.waiter >= waitTime then
    self.waiting = false
    self.waiter = 0
  end
end

function GameManagerClass:updatePlayerPowers(player, index)
  local playPower = 0
  for _, card in ipairs(player.activeCard) do
    playPower = playPower + card.power
  end
  
  if index == 1 then
    self.playerPower = playPower
  else
    self.aiPower = playPower
  end
end

function GameManagerClass:tutorialDraw()
  love.graphics.setColor(255/255, 204/255, 23/255, 1)
  love.graphics.rectangle("fill", 100, 50, 1080, 620, 5, 5)
  love.graphics.setColor(112/255, 54/225, 43/225, 1)
  love.graphics.rectangle("fill", 105, 55, 1070, 610, 5, 5)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Welcome to Challengers of Athens!\n-Using your M1 button, you can drag cards to and from your hand(blue background)", 120, 75)
  love.graphics.print("to your stage(red), discard(gray/black), or your deck(face down card) on the bottom side of the screen", 120, 115)
    
  love.graphics.print("-The stage(red) is where each player puts all cards they want to play for that round,", 120, 135)
  love.graphics.print("only limited to up to 4 cards and the current mana stock, which reflects the current turn cycle count,", 120, 150)
  love.graphics.print("each player may stage any combo of cards in their hand and press play but must either return them", 120, 165)
  love.graphics.print("to their hand, place the card in their deck, or discard after the round ends.\n-Cumulative card cost must not exceed mana stock in the upper left corner of your placemat.\nJust like the hand, you may drag cards to and from here during your turn.",120, 180)

  love.graphics.print("-The Grey pile is the discard pile: if you drag anything in here, you cannot get it back for\n the rest of the game so be cautious", 120, 250)
    
  love.graphics.print("-The face down card represents your deck where you'll automatically draw a card at\nthe begininng of each round. You may also insert a card into the bottom of it by\ndragging and releasing a card over it.", 120, 300)
    
  love.graphics.print("-Finally, the blue slots represent your hand. Cards automatically go here when drawn from the deck, if full any card draw is skipped.", 120, 370)
    
  love.graphics.print("-Each card has a power level(red number), a cost to be played(blue number), and an ability represented as text .", 120, 420)
    
  love.graphics.print("-During the staging phase, each player puts their cards upfront, facedown\nthen comes the action phase where both sides flip all their cards\neach card has an ability that's played when flipped face up,\neach player's cards' power is adjusted accordingly. Whovever has the most power\nwins that round and receives points based on how much more power the winner has.\nFor example: in a battle of 5 power vs 8 power, the winner receives 3 points.\nThis continues until one player reaches 20 points and is declared the winner", 120, 445)
  
  love.graphics.setColor(0.2, 0.2, 0.3, 1)
  love.graphics.rectangle("fill", 800, 60, 50, 80, 5, 5)
  love.graphics.setColor(0.3, 0, 0, 1)
  love.graphics.rectangle("fill", 950, 60, 50, 80, 5, 5)
  
  love.graphics.setColor(255/255, 204/255, 23/255, 1)
  love.graphics.rectangle("fill", 950, 180, 50, 80, 5, 5)
  love.graphics.setColor(128/255, 47/255, 29/255, 1)
  love.graphics.rectangle("fill", 955, 185, 40, 70, 5, 5)
  
  love.graphics.setColor(0.15, 0.15, 0.15, 1)
  love.graphics.rectangle("fill", 800, 180, 50, 80, 5, 5)
  
  love.graphics.setColor(0,0,0,1)
  love.graphics.line(855, 90, 945, 90)
  love.graphics.line(935, 85, 945, 90)
  love.graphics.line(935, 95, 945, 90)

  
  love.graphics.line(855, 110, 945, 110)
  love.graphics.line(855, 110, 865, 105)
  love.graphics.line(855, 110, 865, 115)

  
  love.graphics.line(825, 145, 825, 175)
  love.graphics.line(820, 165, 825, 175)
  love.graphics.line(830, 165, 825, 175)

  
  love.graphics.line(975, 145, 975, 175)
  love.graphics.line(970, 165, 975, 175)
  love.graphics.line(980, 165, 975, 175)


  love.graphics.line(950, 145, 850, 175)
  love.graphics.line(853, 165, 850, 175)
  love.graphics.line(858, 180, 850, 175)

  
  love.graphics.line(850, 145, 950, 175)
  love.graphics.line(943, 165, 950, 175)
  love.graphics.line(938, 180, 950, 175)

  love.graphics.setColor(255/255, 204/255, 23/255, 1)
  love.graphics.rectangle("fill", 900, 500, 100, 160, 5, 5)
  love.graphics.setColor(186/255, 108/255, 60/255,1)
  love.graphics.rectangle("fill", 905, 505, 90, 150, 5, 5)
  love.graphics.setColor(0/255, 0/255, 255/255, 1)
  love.graphics.print("3", 905, 505, 0, 1.5, 1.5)
  love.graphics.print("3 is the cost of mana\n from the stock", 1010, 530)

  love.graphics.setColor(255/255, 0/255, 0/255, 1)
  love.graphics.print("5", 980, 505, 0, 1.4, 1.4)
  love.graphics.print("5 is the power it contributes\nto the stage",  1010, 590)

  love.graphics.setColor(1,1,1, 1)
  love.graphics.print("Card Name", 910, 540, 0, 1.3, 1.3)
  love.graphics.print("Card Ability\ndescription", 910, 580)

  
  love.graphics.print("Press 'i' again to close", 115, 645)

end