require "scripts/Vector"
require "scripts/stacks"
require "scripts/Observer"

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.grabbedItem = {}
  
  grabber.previousMousePos = nil
  grabber.currentMousePos = nil
  grabber.LastCardGrabbed = nil
  
  grabber.grabPos = nil  
  grabber.lastMoveValid = false;
  
  -- NEW: we'll want to keep track of the object (ie. card) we're holding
  grabber.holding = false
  return grabber
end

function GrabberClass:update(stackStack, rankRead, cardList, subject)
  self.currentMousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )
  
  -- Click (just the first frame)
  if love.mouse.isDown(1) and self.grabPos == nil and #self.grabbedItem ~= 0 then
    self:grab()
  end
  -- Release
  if not love.mouse.isDown(1) and self.grabPos ~= nil then
    self:release(stackStack, rankRead, cardList, subject)
    local completedStacks = 0
    
    for _, s in ipairs(stackStack) do
      if(s.nextRank >= 14 and s.suite ~= "F") then
        completedStacks = completedStacks + 1
        if completedStacks == 4 then
          subject:notifyWin(subject.observers[1])
          break
        end
      end
    end
    
  end  
end

function GrabberClass:grab()
  self.LastCardGrabbed = self.grabbedItem[#self.grabbedItem]
  self.grabPos = self.grabbedItem[#self.grabbedItem].position
  print("GRAB - " .. tostring(self.grabPos))
end
function GrabberClass:release(stackStack, rankRead, cardList, subject)
  --function completes if theres nothing grabbed
  if #self.grabbedItem == 0 then
    return
  end
  
  local grabbedCard = self.grabbedItem[#self.grabbedItem];
  local releasePos = self.grabPos
  --grabbed card is dropped over a stack
  for _, s in ipairs(stackStack) do
    --the stack is of the same suite and its one rank above the top card OR the stack is on the tableu
    if s:isOver(self) and (s.suite == grabbedCard.suite or s.suite == "F") and (rankRead[s.nextRank] == grabbedCard.rank or s.suite == "F") then
      --if the stack is on the tableu and it's occupied or the grabbed card isn't a King, move is invalid
      if((s.suite == "F" and #s.holding > 0) or (s.suite == "F" and grabbedCard.rank ~= "K")) then
        break
      end
      --if the card was previously in a tableu stack, remove it from that stack before appending to the new one
      for _, j in ipairs(stackStack) do
        if j.suite == "F" and j ~= s then
          if #j.holding == 1 then
            if grabbedCard == j.holding[1] then
              table.remove(j.holding, 1)
            end
          end
        end
      end
      
      --move is valid and appends to the stack
      self.lastMoveValid = true;
      grabbedCard.isInDeck = false
      table.insert(s.holding, grabbedCard)
      
      --increments the stack rank tracker
      s.nextRank = s.nextRank + 1
      releasePos = s.position
      grabbedCard.parent = nil
      --snaps to the new stack
      self.grabbedItem[#self.grabbedItem].position = releasePos
      self.grabPos = nil
      self.grabbedItem = {}
      print("RELEASE - " .. tostring(self.lastMoveValid).. "peanut")
      return
    end
  end
  --grabbed card is dropped over another card
  for _, c in ipairs(cardList) do
    --is over a card
    if c:currentState() == 1 then
      --card is opposite color
      if c.color ~= grabbedCard.color then
        local n = 1
        --gets rank index
        for _, d in ipairs(rankRead) do
          if rankRead[n] == grabbedCard.rank then
            break
          end
          n = n + 1
        end
        --card is not flipped and is one rank above grabbed card
        if n ~= #rankRead and c.rank == rankRead[n+1] and not c.flipped then
          releasePos = Vector(c.position.x, c.position.y+40)
          --clears grabbed cards prior parent
          if grabbedCard.parent ~= nil then
            grabbedCard.parent.child = nil
            grabbedCard.parent = nil
          end
          --assigns grabbed card's new parent and the card dropped on gains a new child
          grabbedCard.parent = c
          c.child = grabbedCard
          self.lastMoveValid = true
          grabbedCard.isInDeck = false
          --removes grabbed card from tableu stack if previously inside one
          for _, s in ipairs(stackStack) do
            if s.suite == "F" then
              if #s.holding == 1 then
                
                if grabbedCard == s.holding[1] then
                  table.remove(s.holding, 1)
                  break
                end
              end
            end
          end
          break
        end
      end
      c.state = 0;
    end
  end
  
  self.grabbedItem[#self.grabbedItem].position = releasePos
  self.grabPos = nil
  self.grabbedItem = {}
  print("RELEASE - " .. tostring(self.lastMoveValid)..tostring(love.mouse.getX()))
  return
  
end