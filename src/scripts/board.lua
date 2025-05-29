
BoardClass = {}

LOCATIONS = {
    A = 1,
    B = 2,
    C = 3
}

function BoardClass:new()
  local board = {}
  local metadata = {__index = BoardClass}
  setmetatable(board, metadata)

  board.player = {
    deck = CardContainerClass:new(true, CARD_CONTAINER_TYPES.DECK),
    hand = CardContainerClass:new(true, CARD_CONTAINER_TYPES.HAND, 7),
    discard = CardContainerClass:new(true, CARD_CONTAINER_TYPES.DISCARD),
    locations = {
      CardContainerClass:new(true, CARD_CONTAINER_TYPES.LOCATION, 4, LOCATIONS.A),
      CardContainerClass:new(true, CARD_CONTAINER_TYPES.LOCATION, 4, LOCATIONS.B),
      CardContainerClass:new(true, CARD_CONTAINER_TYPES.LOCATION, 4, LOCATIONS.C)
    },
    staged = CardContainerClass:new(true, CARD_CONTAINER_TYPES.STAGED),
    mana = 0,
    points = 0
  }

  board.opponent = {
    deck = CardContainerClass:new(false, CARD_CONTAINER_TYPES.DECK),
    hand = CardContainerClass:new(false, CARD_CONTAINER_TYPES.HAND, 7),
    discard = CardContainerClass:new(false, CARD_CONTAINER_TYPES.DISCARD),
    locations = {
      CardContainerClass:new(false, CARD_CONTAINER_TYPES.LOCATION, 4, LOCATIONS.A),
      CardContainerClass:new(false, CARD_CONTAINER_TYPES.LOCATION, 4, LOCATIONS.B),
      CardContainerClass:new(false, CARD_CONTAINER_TYPES.LOCATION, 4, LOCATIONS.C)
    },
    staged = CardContainerClass:new(false, CARD_CONTAINER_TYPES.STAGED),
    mana = 0,
    points = 0
  }

  board.round = 1

  return board
end

function BoardClass:getSubject(isPlayer)
  return isPlayer and self.player or self.opponent
end

function BoardClass:addMana(isPlayer, mana)
  local subject = self:getSubject(isPlayer)

  if (subject.mana + mana) < 0 then
    return false
  end

  subject.mana = subject.mana + mana
  return true
end

function BoardClass:setMana(isPlayer, mana)
  local subject = self:getSubject(isPlayer)
  subject.mana = mana
end

function BoardClass:drawCard(isPlayer)
  local subject = self:getSubject(isPlayer)
  subject.deck:moveCard(subject.hand)
  return true
end

function BoardClass:stageCard(isPlayer, card)
  local subject = self:getSubject(isPlayer)
  subject.staged:addCard(card)
end

function BoardClass:unstageCard(isPlayer, card)
  local subject = self:getSubject(isPlayer)
  subject.staged:removeCard(card)
end

function BoardClass:clearStaging()
  self.player.staged:clear()
  self.opponent.staged:clear()
end

function BoardClass:revealCards(isPlayer)
  local subject = self:getSubject(isPlayer)
  
  for _, card in ipairs(subject.staged.cardTable) do
    card:onReveal()
    self.player.locations[card.container.location]:callOnCardPlayedHere(card)
    self.opponent.locations[card.container.location]:callOnCardPlayedHere(card)
  end
end

function BoardClass:endTurn()
  for i = 1, 3 do
    self.player.locations[i]:callOnEndTurn()
    self.opponent.locations[i]:callOnEndTurn()

    local pointDiff = self.player.locations[i]:getTotalPower() - self.opponent.locations[i]:getTotalPower()
    if pointDiff > 0 then
      self.player.points = self.player.points + pointDiff
    else
      self.opponent.points = self.opponent.points - pointDiff
    end
  end
end

function BoardClass:discardCard(card)
  local subject = self:getSubject(card.container.isPlayerOwned)
  card:onDiscard()
  card.container:moveCard(subject.discard, card)
end

function BoardClass:reset()
  local subject = self:getSubject(true)
  subject.deck:clear()
  subject.hand:clear()
  subject.discard:clear()
  for _, location in ipairs(subject.locations) do
    location:clear()
  end
  subject.staged:clear()
  subject.mana = 0
  subject.points = 0

  subject = self:getSubject(false)
  subject.deck:clear()
  subject.hand:clear()
  subject.discard:clear()
  for _, location in ipairs(subject.locations) do
    location:clear()
  end
  subject.staged:clear()
  subject.mana = 0
  subject.points = 0

  self.round = 1
end

function BoardClass:isWinningAtLocation(isPlayer, location)
  local subject = self:getSubject(isPlayer)
  local opposer = self:getSubject(not isPlayer)
  return subject.locations[location]:getTotalPower() > opposer.locations[location]:getTotalPower()
end

