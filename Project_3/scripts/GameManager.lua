GameManagerClass = {}


function GameManagerClass:new(playerTable)
  local managerClass = {}
  
  setmetatable(managerClass, {__index = GameManagerClass})
  managerClass.Cycle = 1
  managerClass.players = playerTable
  managerClass.UserTurn = true
  managerClass.lastWinner = nil
  managerClass.Observers = {}
  local turnObserver = ObserverClass:new(managerClass)
  table.insert(managerClass.Observers, turnObserver)
  return managerClass
 end
 
function GameManagerClass:gameStart(CardIntel)
  self.Cycle = 3
  self.UserTurn = true
  for _, player in ipairs(self.players) do
    player.discardPile = {}
    player.activeCard = {}
    player.hand = {}
    player.deck.Cards = {}
    player.deck:populate(20, CardIntel)
    for i=1, 10 do
      player:CardDraw()
    end
    player.manaStock = self.Cycle
    player.points = 0
    player.turnObserver = self.Observers[1]
  end
end

function GameManagerClass:update()
  if self.UserTurn == true then
    self.players[1].grabber:update(self.players[1])
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
    manager.UserTurn = false
  else
    manager.UserTurn = true
    manager.Cycle = manager.Cycle + 1
    for _, player in ipairs(manager.players) do
      player.manaStock = manager.Cycle
    end
  end
end