
-- ==========================
-- == CARD CONTAINER CLASS ==
-- ==========================

CARD_CONTAINER_TYPES = {
  LOCATION = 0,
  HAND = 1,
  DISCARD = 2,
  DECK = 3,
  STAGED = 4
}

CardContainerClass = {}

function CardContainerClass:new(isPlayerOwned, type, capacity, location)
  
  local cardContainer = {}
  local metadata = {__index = CardContainerClass}
  setmetatable(cardContainer, metadata)

  cardContainer.type = type
  cardContainer.cardTable = {}
  cardContainer.location = location
  cardContainer.capacity = capacity
  cardContainer.isPlayerOwned = isPlayerOwned

  return cardContainer
end

function CardContainerClass:moveCard(cardToMove, destContainer, prevContainer)

  local fromGrabber = prevContainer and true or false
  prevContainer = prevContainer or self
  
  if (#destContainer.cardTable >= destContainer.capacity) then
    print("Cannot move card to new location since its already full")
    return false
  end

  if (GameManager.gameState == GAME_STATE.PLAYER_TURN) or (GameManager.gameState == GAME_STATE.OPPONENT_TURN) then
    if (prevContainer.type == CARD_CONTAINER_TYPES.HAND) and (destContainer.type == CARD_CONTAINER_TYPES.LOCATION) then
      if not Board.addMana(destContainer.isPlayerOwned, -cardToMove.baseCost) then
        return false
      end
      Board.stageCard(self.isPlayerOwned, cardToMove)
    elseif (prevContainer.type == CARD_CONTAINER_TYPES.LOCATION) and (destContainer.type == CARD_CONTAINER_TYPES.HAND) then
      Board.addMana(destContainer.isPlayerOwned, cardToMove.baseCost)
      Board.unstageCard(self.isPlayerOwned, cardToMove)
    end
  end

  for i, card in ipairs(self.cardTable) do
    if card == cardToMove then
      table.insert(destContainer.cardTable, card)
      self.cardTable[i] = nil
      return true
    end
  end

  print("ERROR CARD NOT FOUND TO MOVE")
  return false
end

function CardContainerClass:removeCard(cardToRemove)
  for i, card in ipairs(self.cardTable) do
    if card == cardToRemove then
      self.cardTable[i] = nil
      return true
    end
  end

  print("ERROR CARD NOT FOUND TO REMOVE")
  return false
end

function CardContainerClass:addCard(cardToAdd)
  table.insert(self.cardTable, cardToAdd)
end