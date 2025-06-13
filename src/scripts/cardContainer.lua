
-- ==========================
-- == CARD CONTAINER CLASS ==
-- ==========================

CARD_CONTAINER_TYPES = {
  LOCATION = 0,
  HAND = 1,
  DISCARD = 2,
  DECK = 3,
  STAGED = 4,
  GRABBER = 5,
}

CardContainerClass = {}

function CardContainerClass:new(entity, type, capacity, location)
  
  local cardContainer = {}
  local metadata = {__index = CardContainerClass}
  setmetatable(cardContainer, metadata)

  cardContainer.type = type
  cardContainer.cardTable = {}
  cardContainer.location = location
  cardContainer.capacity = capacity or 100
  cardContainer.entity = entity

  return cardContainer
end

function CardContainerClass:moveCard(destContainer, cardToMove, prevContainer)

  prevContainer = prevContainer or self

  if cardToMove == nil then
    if #self.cardTable <= 0 then return end
    cardToMove = self.cardTable[#self.cardTable]
  end
  
  if destContainer:isFullCheck() then
    return false
  end

  -- If in the staging phase, add and subtract mana appropriately
  if (GameManager.gameState == GAME_STATE.PLAYER_TURN) or (GameManager.gameState == GAME_STATE.OPPONENT_TURN) then
    if (prevContainer.type == CARD_CONTAINER_TYPES.HAND) and (destContainer.type == CARD_CONTAINER_TYPES.LOCATION) then
      if not destContainer.entity:addMana(-cardToMove.baseCost) then
        return false
      end
      cardToMove:stage()
    elseif (prevContainer.type == CARD_CONTAINER_TYPES.LOCATION) and (destContainer.type == CARD_CONTAINER_TYPES.HAND) then
      destContainer.entity:addMana(cardToMove.baseCost)
      cardToMove:unstage()
    end
  end

  -- Actually move card
  for i, card in ipairs(self.cardTable) do
    if card == cardToMove then
      card.container = destContainer
      table.insert(destContainer.cardTable, card)
      table.remove(self.cardTable, i)
      return true
    end
  end

  return false
end

function CardContainerClass:removeCard(cardToRemove)
  for i, card in ipairs(self.cardTable) do
    if card == cardToRemove then
      card.container = nil
      table.remove(self.cardTable, i)
      return true
    end
  end
  
  return false
end

function CardContainerClass:addCard(cardToAdd)

  if self:isFullCheck() then
    return false
  end

  cardToAdd.container = self
  table.insert(self.cardTable, cardToAdd)
  return true
end

function CardContainerClass:getTotalPower()
  local powerSum = 0

  for _, card in ipairs(self.cardTable) do
    if card.isPlayed then
      powerSum = powerSum + card.power
    end
  end

  return powerSum
end

function CardContainerClass:clear()
  self.cardTable = {}
end

function CardContainerClass:setFaceUp(isFaceUp)
  for _, card in ipairs(self.cardTable) do
    card.isFaceUp = isFaceUp
  end
end

function CardContainerClass:addPower(powerToAdd)
  for _, card in ipairs(self.cardTable) do
    card:addPower(powerToAdd)
  end
end

function CardContainerClass:addPower(powerToAdd)
  for _, card in ipairs(self.cardTable) do
    card:addPower(powerToAdd)
  end
end

function CardContainerClass:setPower(powerToSet)
  for _, card in ipairs(self.cardTable) do
    card.power = powerToSet
  end
end

function CardContainerClass:getNumberOfCards()
  return #self.cardTable
end

function CardContainerClass:isFullCheck()
  return #self.cardTable >= self.capacity
end

function CardContainerClass:getPlayedCards()
  local playedCardTable = {}

  for _, card in ipairs(self.cardTable) do
    if card.isPlayed then
      table.insert(playedCardTable, card)
    end
  end

  return playedCardTable
end

function CardContainerClass:callOnEndTurn()
  for _, card in ipairs(self.cardTable) do
    card:onEndTurn()
  end
end

function CardContainerClass:callOnCardPlayedHere(cardPlayed)
  for _, card in ipairs(self.cardTable) do
    card:onCardPlayedHere(cardPlayed)
  end
end