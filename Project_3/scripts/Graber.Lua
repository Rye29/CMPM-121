require "scripts/Vector"
require "scripts/card"


GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.grabbedItem = nil
  grabber.previousPos = Vector(0, 0)
  grabber.holding = false
  return grabber
end

function GrabberClass:update(player)
  local mouseX, mouseY = love.mouse.getPosition()
  local buttonDown = love.mouse.isDown(1)
  if not buttonDown then
    if self.grabbedItem ~= nil then
      --validation function insert here
      self:validatePos(player, mouseX, mouseY)
      --print("hand: "..tostring(#player.hand))
      --print("active: "..tostring(#player.activeCard))

      --self:release(self.previousPos.x, self.previousPos.y)
    end
    
  else
    if self.holding then
      self.grabbedItem.position = Vector(mouseX, mouseY)
    else
      for _, card in ipairs(player.hand) do
        if card:containsPoint(mouseX, mouseY) and card.location ~= nil then
          self:grab(card, mouseX, mouseY)
          break
        end
      end
      
      for _, card in ipairs(player.activeCard) do
        if card:containsPoint(mouseX, mouseY) and card.location ~= nil then
          self:grab(card, mouseX, mouseY)
          break
        end
      end
      
      if player.playButton:checkForMouseOver() then
        player:play()
      end
    end
    
  end
  
  --print(self.holding)
end

function GrabberClass:grab(card, mX, mY)
  if not self.holding and card and card.location ~= "discard" and card.location ~= "deck" then
    self.grabbedItem = card
    self.previousPos.x, self.previousPos.y = card.position.x, card.position.y
    print(tostring(self.previousPos.x)..", "..tostring(self.previousPos.y))
    self.grabbedItem.position = Vector(mX, mY)
    self.holding = true
    return true
  end
  return false
end



function GrabberClass:release(x, y)
  if self.holding then
    self.grabbedItem.position.x = x
    self.grabbedItem.position.y = y
    self.grabbedItem = nil
    self.holding = false
    return true
  end
  return false
end

function GrabberClass:validatePos(player, mouseX, mouseY)
  --put in active slot
  if (player.activePos.x <= mouseX and player.activePos.x+360 >= mouseX) and (player.activePos.y <= mouseY and player.activePos.y+130 >= mouseY) then
    if self.grabbedItem.location ~= "active" then
      for i=1, #player.hand do
        if self.grabbedItem == player.hand[i] then
          if #player.activeCard >= 4 then
            break
          end
          local card = self.grabbedItem
          table.remove(player.hand, i)
          self:release(player.activePos.x + #player.activeCard*90, player.activePos.y)
          card.location = "active"
          table.insert(player.activeCard, card)
          
          --reposition the rest of the cards
          local j = 0
          for _, rem in ipairs(player.hand) do
            rem.position.x = player.handPos.x + (90*j)
            j = j + 1
          end
          
          return
        end
      end
    end
  end
  --put in hand
  if (player.handPos.x <= mouseX and player.handPos.x+630 >= mouseX) and (player.handPos.y <= mouseY and player.handPos.y+130 >= mouseY) then
    if self.grabbedItem.location ~= "hand" then
      for i=1, #player.activeCard do
        if self.grabbedItem == player.activeCard[i] then
          if #player.hand >= player.handSize then
            break
          end
          local card = self.grabbedItem
          table.remove(player.activeCard, i)
          self:release(player.handPos.x + #player.hand*90, player.handPos.y)
          card.location = "hand"
          table.insert(player.hand, card)
          
          
          --reposition the rest of the cards
          local j = 0
          for _, rem in ipairs(player.activeCard) do
            rem.position.x = player.activePos.x + (90*j)
            j = j + 1
          end
          return
        end
      end
    end
  end
  --put in discard
  self:insertPile(player.discardPile, player.discardPos, 0, player, "discard", mouseX, mouseY)

  
  --put in deck
  self:insertPile(player.deck.Cards, player.deckPos, 20, player, "deck", mouseX, mouseY)
  
  
  --nowhere valid
  self:release(self.previousPos.x, self.previousPos.y)
  
  
end

function GrabberClass:insertPile(targetPile, targetPos, targetPosOffset, player, finalLoc, mouseX, mouseY)
  if (targetPos.x <= mouseX and targetPos.x+80 >= mouseX) and (targetPos.y <= mouseY and targetPos.y+130 >= mouseY) then
    print("in ".. finalLoc)
    if self.holding then

      if self.grabbedItem.location == "hand" then
        for i=1, #player.hand do
          if self.grabbedItem == player.hand[i] then
            local card = self.grabbedItem
            table.remove(player.hand, i)
            self:release(targetPos.x+(#targetPile*targetPosOffset), targetPos.y)
            card.location = finalLoc
            table.insert(targetPile, card)
            --reposition the rest of the cards
            local j = 0
            for _, rem in ipairs(player.hand) do
              rem.position.x = player.handPos.x + (90*j)
              j = j + 1
            end
            return
          end
        end
        
      elseif self.grabbedItem.location == "active" then
        for i=1, #player.activeCard do
          if self.grabbedItem == player.activeCard[i] then
            local card = self.grabbedItem
            table.remove(player.activeCard, i)
            self:release(targetPos.x+(#targetPile*targetPosOffset), targetPos.y)
            card.location = finalLoc
            table.insert(targetPile, card)
            --reposition the rest of the cards
            local j = 0
            for _, rem in ipairs(player.activeCard) do
              rem.position.x = player.activePos.x + (90*j)
              j = j + 1
            end
            return
          end
        end
      end
    end
  end
  
  
end