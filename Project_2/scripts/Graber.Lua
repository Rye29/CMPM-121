
require "scripts/Vector"
require "scripts/stacks"

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

function GrabberClass:update(stackStack, rankRead, cardList)
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
    self:release(stackStack, rankRead, cardList)
  end  
end

function GrabberClass:grab()
  self.LastCardGrabbed = self.grabbedItem[#self.grabbedItem]
  self.grabPos = self.grabbedItem[#self.grabbedItem].position
  print("GRAB - " .. tostring(self.grabPos))
end
function GrabberClass:release(stackStack, rankRead, cardList)
  if #self.grabbedItem == 0 then
    return
  end
  
  local grabbedCard = self.grabbedItem[#self.grabbedItem];
  local releasePos = self.grabPos
  
  for _, s in ipairs(stackStack) do
    if s:isOver(self) and (s.suite == grabbedCard.suite or s.suite == "F") and (rankRead[s.nextRank] == grabbedCard.rank or s.suite == "F") then
      
      if(s.suite == "F" and #s.holding > 0) then
        break
      end
      
      for _, j in ipairs(stackStack) do
        if j.suite == "F" and j ~= s then
          if #j.holding == 1 then
            if grabbedCard == j.holding[1] then
              table.remove(j.holding, 1)
            end
          end
        end
      end
      self.lastMoveValid = true;

      
      grabbedCard.isInDeck = false

      table.insert(s.holding, grabbedCard)
      s.nextRank = s.nextRank + 1
      releasePos = s.position
      grabbedCard.parent = nil
      
      self.grabbedItem[#self.grabbedItem].position = releasePos
      self.grabPos = nil
      self.grabbedItem = {}
      print("RELEASE - " .. tostring(self.lastMoveValid).. "peanut")
      return
    end
  end
  
  for _, c in ipairs(cardList) do
    if c:currentState() == 1 then
      if c.color ~= grabbedCard.color then
        local n = 1
        for _, d in ipairs(rankRead) do
          if rankRead[n] == grabbedCard.rank then
            break
          end
          n = n + 1
        end
        
        if n ~= #rankRead and c.rank == rankRead[n+1] and not c.flipped then
          releasePos = Vector(c.position.x, c.position.y+40)
          
          if grabbedCard.parent ~= nil then
            grabbedCard.parent.child = nil
            grabbedCard.parent = nil
          end
          
          grabbedCard.parent = c
          c.child = grabbedCard
          self.lastMoveValid = true
          grabbedCard.isInDeck = false
          
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