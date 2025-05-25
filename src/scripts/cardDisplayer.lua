
-- ==================================
-- == CARD DISPLAYER CLASS ==
-- ==================================

CardDisplayerClass = {}

function CardDisplayerClass:new(xPos, yPos, xSize, ySize, xCardOffset, yCardOffset, interactable, cardContainer, fillEnabled, fillColor)
  
  local cardDisplayer = {}
  local metadata = {__index = CardDisplayerClass}
  setmetatable(cardDisplayer, metadata)

  cardDisplayer.cardContainer = cardContainer
  cardDisplayer.position = Vector(xPos, yPos)
  cardDisplayer.size = Vector(xSize, ySize)

  cardDisplayer.cardsTotalOffset = nil
  -- Offset from one card in the stack to the next
  cardDisplayer.cardIndividualOffset = Vector(xCardOffset, yCardOffset)

  -- Whether you can grab or release here
  cardDisplayer.interactable = interactable

  cardDisplayer.fillEnabled = fillEnabled
  cardDisplayer.fillColor = fillColor

  return cardDisplayer
end

function CardDisplayerClass:draw()

  -- Draws back fill if set
  if self.fillEnabled then
    love.graphics.setColor(self.fillColor or {0.5, 0.5, 0.5, 1})
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y)
  end

  for _, card in ipairs(self.cardContainer.cardTable) do
    local cardPosition = self.position + self.cardsTotalOffset + ((#self.stack - 1) * self.cardIndividualOffset)
    card:draw(cardPosition)
  end
end

-- Check if mouse over the stack (for releasing)
function CardDisplayerClass:checkForMouseOverRegion(x, y)
  if not self.interactable then
    return false
  end

  local isMouseOver = 
    x > self.position.x and
    x < self.position.x + self.size.x and
    y > self.position.y and
    y < self.position.y + self.size.y
  
  return isMouseOver
end

-- Check if mouse is over cards from bottom to top (for grabbing)
function CardDisplayerClass:checkForMouseOverCard(x, y)
  if not self.interactable then
    return nil
  end

  for i, card in ipairs(self.cardContainer.cardTable) do
    if card:checkForMouseOver(self:getCardPosition(i), Vector(x, y)) then
      return card
    end
  end

  return nil
end

function CardDisplayerClass:getCardPosition(cardIndex)
  return self.position + self.cardsTotalOffset + ((cardIndex - 1) * self.cardIndividualOffset)
end

function CardDisplayerClass:updatePosition(x, y)
  self.position = Vector(x, y)
end