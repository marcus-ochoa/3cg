
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
    mana = 3
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
    mana = 3
  }

  board.locations = {
    {
      board.player.locations[LOCATIONS.A],
      board.opponent.locations[LOCATIONS.A]
    },
    {
      board.player.locations[LOCATIONS.B],
      board.opponent.locations[LOCATIONS.B]
    },
    {
      board.player.locations[LOCATIONS.C],
      board.opponent.locations[LOCATIONS.C]
    },
  }

  return board
end

function BoardClass:playerTurn()

end

function BoardClass:reveal()

end

function BoardClass:addMana(isPlayer, mana)
  local subject = isPlayer and self.player or self.opponent

  if (subject.mana + mana) < 0 then
    return false
  end

  subject.mana = subject.mana + mana
  return true
end

function BoardClass:stageCard(isPlayer, card)
  local subject = isPlayer and self.player or self.opponent
  subject.staged:addCard(card)
end

function BoardClass:unstageCard(isPlayer, card)
  local subject = isPlayer and self.player or self.opponent
  subject.staged:removeCard(card)
end