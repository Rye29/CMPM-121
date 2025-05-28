GameManagerClass = {}


function GameManagerClass:new(playerTable)
  local managerClass = {}
  
  setmetatable(managerClass, {__index = GameManagerClass})
  
  managerClass.Cycle = 1
  
  managerClass.players = playerTable
  managerClass.UserTurn = true
  managerClass.lastWinner = nil
  
  managerClass.waiting = false
  managerClass.waiter = 0
  managerClass.eventQueue = {}
  
  managerClass.playerPower = 0
  managerClass.aiPower = 0

  
  managerClass.Observers = {}
  local turnObserver = ObserverClass:new(managerClass)
  table.insert(managerClass.Observers, turnObserver)
  return managerClass
 end
 
function GameManagerClass:gameStart(CardIntel, VanillaIntel)
  self.Cycle = 3
  self.UserTurn = true
  for _, player in ipairs(self.players) do
    player.discardPile = {}
    player.activeCard = {}
    player.hand = {}
    player.deck.Cards = {}
    player.deck:populate(20, CardIntel)
    local j = 1
    for _, card in ipairs(VanillaIntel) do
      local newCard = CardClass:new(card.position.x, card.position.y, card.name, card.cost, card.text, card.flipped, card.ability, card.power)
      newCard.location = "deck"
      table.insert(player.deck.Cards, j, newCard)
      j = j + 1
    end
    for i=1, 3 do
      player:CardDraw()
    end
    player.manaStock = self.Cycle
    player.points = 0
    player.turnObserver = self.Observers[1]
  end
end

function GameManagerClass:update(dt)
  --print(tostring(dt))
  if self.UserTurn == true then
    self.players[1].grabber:update(self.players[1])
  end
  
  if self.UserTurn == nil then
    if self.waiting == false then
      self.eventQueue[1]()
      table.remove(self.eventQueue, 1)
    else
      --print("waiting")
      self:wait(0.75, dt)
    end
  end
  
end

function GameManagerClass:keyUpdate(key)
  if self.UserTurn == false then
    self.players[2]:inputUpdate(key)
  end
  
end

 
ObserverClass = {}
 
function ObserverClass:new(manager)
  local observerClass = {}
  observerClass.manager = manager
  setmetatable(observerClass, {__index = ObserverClass})
 
  
  
  return observerClass
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
    
    table.insert(manager.eventQueue, function() manager:flipCards(manager.players[1], false) end)
    table.insert(manager.eventQueue, function() manager:flipCards(manager.players[2], true) end)

      
    if first == 1 then
      table.insert(manager.eventQueue, function() manager:flipCards(manager.players[1], true) end)
      table.insert(manager.eventQueue, function() manager:playCards(manager.players[1], manager.players[2]) end)
      
      table.insert(manager.eventQueue, function() manager:flipCards(manager.players[2], true) end)
      table.insert(manager.eventQueue, function() manager:playCards(manager.players[2], manager.players[1]) end)

    else
      table.insert(manager.eventQueue, function() manager:flipCards(manager.players[2], true) end)
      table.insert(manager.eventQueue, function() manager:playCards(manager.players[2], manager.players[1]) end)
      
      table.insert(manager.eventQueue, function() manager:flipCards(manager.players[1], true) end)
      table.insert(manager.eventQueue, function() manager:playCards(manager.players[1], manager.players[2]) end)
    end
    table.insert(manager.eventQueue, function() manager:finishCycle() end)
  end
end

function aiBehaviour(manager)
  local card_count = math.floor(math.random(1,5))
    if card_count < 1 then
      card_count = 1
    end
    for i=1, card_count do
      local cos = 0
      print("ai iter")
      for _, card in ipairs(manager.players[2].activeCard) do
        cos = cos + card.cost
      end
      if #manager.players[2].activeCard == (4) or manager.players[2].hand[1].cost + cos > manager.players[2].manaStock then
        print("ai break")
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
  print("event finished")
  self.waiting = true
  print(tostring(self.waiting))
end

function GameManagerClass:flipCards(player, wait)
  for _, card in ipairs(player.activeCard) do
    card.flipped = not card.flipped
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
  elseif score3 < 0 then
    self.lastWinner = self.players[1]
    self.players[1].points = self.players[1].points + math.abs(score3)
  else
    self.lastWinner = nil
  end
  
  self.players[1]:CardDraw()
  self.players[2]:CardDraw()

  self.players[2]:returnHand(#self.players[2].activeCard)
  
  
  
  if #self.players[2].activeCard > 0 then
    self.players[2]:discardHand(#self.players[2].activeCard)
    print("discarded ai")
  end
  
  print("cycle finished!")
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