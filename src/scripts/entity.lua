
EntityClass = {}

function EntityClass:new()
  local entity = {}
  local metadata = {__index = EntityClass}
  setmetatable(entity, metadata)

  entity.deck = CardContainerClass:new(entity, CARD_CONTAINER_TYPES.DECK)
  entity.hand = CardContainerClass:new(entity, CARD_CONTAINER_TYPES.HAND, 7)
  entity.discard = CardContainerClass:new(entity, CARD_CONTAINER_TYPES.DISCARD)
  entity.locations = {
    CardContainerClass:new(entity, CARD_CONTAINER_TYPES.LOCATION, 4, LOCATIONS.A),
    CardContainerClass:new(entity, CARD_CONTAINER_TYPES.LOCATION, 4, LOCATIONS.B),
    CardContainerClass:new(entity, CARD_CONTAINER_TYPES.LOCATION, 4, LOCATIONS.C)
  }
  entity.staged = CardContainerClass:new(entity, CARD_CONTAINER_TYPES.STAGED)
  entity.mana = 0
  entity.points = 0

  return entity
end

function EntityClass:addMana(mana)
  if (self.mana + mana) < 0 then
    return false
  end

  self.mana = self.mana + mana
  return true
end

function EntityClass:setMana(mana)
  self.mana = mana
end

function EntityClass:drawCard()
  self.deck:moveCard(self.hand)
end

function EntityClass:stageCard(card)

  if self ~= card:getOwner() then
    print("ERROR: card does not belong to this entity")
    return
  end
  
  self.staged:addCard(card)
end

function EntityClass:unstageCard(card)

  if self ~= card:getOwner() then
    print("ERROR: card does not belong to this entity")
    return
  end

  self.staged:removeCard(card)
end

function EntityClass:clearStaging()
  self.staged:clear()
end

function EntityClass:discardCard(card)

  if self ~= card:getOwner() then
    print("ERROR: card does not belong to this entity")
    return
  end

  card:onDiscard()
  card.container:moveCard(self.discard, card)
end

function EntityClass:reset()

  self.deck:clear()
  self.hand:clear()
  self.discard:clear()

  for _, location in ipairs(self.locations) do
    location:clear()
  end

  self.staged:clear()
  self.mana = 0
  self.points = 0
end

function EntityClass:isWinningAtLocation(location)
  local opposition = Board:getOpposition(self)
  return self.locations[location]:getTotalPower() > opposition.locations[location]:getTotalPower()
end

