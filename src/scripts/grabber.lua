
-- === USED STARTER CODE FROM CLASS == 

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.cardContainer = CardContainerClass:new(Board.player, CARD_CONTAINER_TYPES.GRABBER, 1)
  grabber.cardDisplayer = CardDisplayerClass:new(0, 0, CARD_SIZE.x, CARD_SIZE.y, 3, 0, 0, 0, 0, 1, false, grabber.cardContainer, false)
  grabber.prevCardContainer = nil

  return grabber
end

-- Check over all buttons and cards to update states and update grabbed pile position
function GrabberClass:onMouseMoved(x, y)

  for _, button in ipairs(UIManager.clickables) do
    button:checkForMouseOver(x, y)
  end

  for _, cardDisplayer in ipairs(UIManager.cardDisplayers.interactables) do
    cardDisplayer:checkForMouseOverCard(x, y)
  end

  self.cardDisplayer:updatePosition(x, y)
end

-- Check over all buttons and piles to interact
function GrabberClass:onMousePressed(x, y)

  for _, button in ipairs(UIManager.clickables) do
    if button:checkForMouseOver(x, y) then
      button:click()
      return
    end
  end

  -- If over a grabbable card, add it to the grabbed container
  for _, cardDisplayer in ipairs(UIManager.cardDisplayers.interactables) do
    local card = cardDisplayer:checkForMouseOverCard(x, y)
    if card ~= nil then
      card:setGrabbed()
      cardDisplayer.cardContainer:moveCard(self.cardContainer, card)
      self.prevCardContainer = cardDisplayer.cardContainer
      return
    end
  end
end

-- Releases cards
function GrabberClass:onMouseReleased(x, y)
  
  -- Nothing to release if you aren't holding anything
  if #self.cardContainer.cardTable <= 0 then
    return
  end

  self.cardContainer.cardTable[1]:setReleased()

  for _, cardDisplayer in ipairs(UIManager.cardDisplayers.interactables) do
    if cardDisplayer:checkForMouseOverRegion(x, y) then
      if self.cardContainer:moveCard(cardDisplayer.cardContainer, self.cardContainer.cardTable[1], self.prevCardContainer) then
        return
      end
      break
    end
  end

  self.cardContainer:moveCard(self.prevCardContainer, self.cardContainer.cardTable[1], self.prevCardContainer)
end