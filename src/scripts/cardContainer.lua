
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

function CardContainerClass:new(isPlayerOwned, type, capacity, location)
  
  local cardContainer = {}
  local metadata = {__index = CardContainerClass}
  setmetatable(cardContainer, metadata)

  cardContainer.type = type
  cardContainer.cardTable = {}
  cardContainer.location = location
  cardContainer.capacity = capacity or 100
  cardContainer.isPlayerOwned = isPlayerOwned

  return cardContainer
end

function CardContainerClass:moveCard(destContainer, cardToMove, prevContainer)

  prevContainer = prevContainer or self

  if cardToMove == nil then
    if #self.cardTable <= 0 then return end
    cardToMove = self.cardTable[#self.cardTable]
  end
  
  if (#destContainer.cardTable >= destContainer.capacity) then
    print("Cannot move card to new location since its already full")
    return false
  end

  if (GameManager.gameState == GAME_STATE.PLAYER_TURN) or (GameManager.gameState == GAME_STATE.OPPONENT_TURN) then
    if (prevContainer.type == CARD_CONTAINER_TYPES.HAND) and (destContainer.type == CARD_CONTAINER_TYPES.LOCATION) then
      if not Board:addMana(destContainer.isPlayerOwned, -cardToMove.baseCost) then
        return false
      end
      Board:stageCard(self.isPlayerOwned, cardToMove)
    elseif (prevContainer.type == CARD_CONTAINER_TYPES.LOCATION) and (destContainer.type == CARD_CONTAINER_TYPES.HAND) then
      Board:addMana(destContainer.isPlayerOwned, cardToMove.baseCost)
      Board:unstageCard(self.isPlayerOwned, cardToMove)
    end
  end

  for i, card in ipairs(self.cardTable) do
    if card == cardToMove then
      card.container = destContainer
      table.insert(destContainer.cardTable, card)
      table.remove(self.cardTable, i)
      return true
    end
  end

  print("ERROR CARD NOT FOUND TO MOVE")
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

  print("ERROR CARD NOT FOUND TO REMOVE")
  return false
end

function CardContainerClass:addCard(cardToAdd)

  if (#self.cardTable >= self.capacity) then
    print("Cannot add card to container since its already full")
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