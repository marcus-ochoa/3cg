
-- ==================================
-- == CARD DISPLAYER CLASS ==
-- ==================================

CardDisplayerClass = {}

function CardDisplayerClass:new(xPos, yPos, xSize, ySize, layer, xCardOffset, yCardOffset, xCardTotalOffset, yCardTotalOffset, rows, interactable, cardContainer, fillEnabled, fillColor)
  
  local cardDisplayer = {}
  local metadata = {__index = CardDisplayerClass}
  setmetatable(cardDisplayer, metadata)

  cardDisplayer.cardContainer = cardContainer
  cardDisplayer.position = Vector(xPos, yPos)
  cardDisplayer.size = Vector(xSize, ySize)

  cardDisplayer.cardsTotalOffset = Vector(xCardTotalOffset, yCardTotalOffset)
  
  -- Offset from one card in the stack to the next
  cardDisplayer.cardIndividualOffset = Vector(xCardOffset, yCardOffset)

  -- Whether you can grab or release here
  cardDisplayer.interactable = interactable

  cardDisplayer.fillEnabled = fillEnabled
  cardDisplayer.fillColor = fillColor

  cardDisplayer.rows = rows

  UIManager:registerDrawable(cardDisplayer, layer)

  return cardDisplayer
end

function CardDisplayerClass:draw()

  -- Draws back fill if set
  if self.fillEnabled then
    love.graphics.setColor(self.fillColor or Colors.gray)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y)
  end

  for i, card in ipairs(self.cardContainer.cardTable) do
    card:draw(self:getCardPosition(i))
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

  -- Calculates card position based on number of cards present
  local row = self.rows - (cardIndex % self.rows)
  local col = math.ceil(cardIndex / self.rows)

  posOffset = Vector((col - 1) * self.cardIndividualOffset.x, (row - 1) * self.cardIndividualOffset.y)
  
  return self.position + self.cardsTotalOffset + posOffset
end

function CardDisplayerClass:updatePosition(x, y)
  self.position = Vector(x, y)
end