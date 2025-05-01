
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
  
  -- TODO: eventually check if release position is invalid and if it is
  -- return the heldObject to the grabPosition
  if #self.grabbedItem == 0 then
    return
  end
  --release doesnt stop, add something to fix that in main (like remove from self.grabbedItem on release)
  local releasePos = self.grabPos
  for _, s in ipairs(stackStack) do
    if s:isOver(self) and (s.suite == self.grabbedItem[#self.grabbedItem].suite or s.suite == "F") and (rankRead[s.nextRank] == self.grabbedItem[#self.grabbedItem].rank or s.suite == "F") then
      self.lastMoveValid = true;
      grabber.grabbedItem[#self.grabbedItem].isInDeck = false

      table.insert(s.holding, self.grabbedItem[#self.grabbedItem])
      s.nextRank = s.nextRank + 1
      releasePos = s.position
      self.grabbedItem[#self.grabbedItem].parent = nil
    end
  end
  
  for _, c in ipairs(cardList) do
    if c:currentState() == 1 then
      if c.color ~= self.grabbedItem[#self.grabbedItem].color then
        local n = 1
        for _, d in ipairs(rankRead) do
          if rankRead[n] == self.grabbedItem[#self.grabbedItem].rank then
            break
          end
          n = n + 1
        end
        
        if n ~= #rankRead and c.rank == rankRead[n+1] and not c.flipped then
          releasePos = Vector(c.position.x, c.position.y+40)
          
          if self.grabbedItem[#self.grabbedItem].parent ~= nil then
            self.grabbedItem[#self.grabbedItem].parent.child = nil
            self.grabbedItem[#self.grabbedItem].parent = nil

          end
          
          self.grabbedItem[#self.grabbedItem].parent = c
          c.child = self.grabbedItem[#self.grabbedItem]
          self.lastMoveValid = true
          self.grabbedItem[#self.grabbedItem].isInDeck = false
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