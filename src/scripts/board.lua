
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

  board.player = EntityClass:new()
  board.opponent = EntityClass:new()
  board.round = 1

  return board
end

function BoardClass:getOpposition(entity)
  return (entity == self.player) and self.opponent or self.player
end

function BoardClass:getWinningEntity()
  if self.player.points > self.opponent.points then
    return self.player
  end

  if self.opponent.points > self.player.points then
    return self.opponent
  end

  return nil
end

function BoardClass:setMana(mana)
  self.player:setMana(mana)
  self.opponent:setMana(mana)
end

function BoardClass:drawCard()
  self.player:drawCard()
  self.opponent:drawCard()
end

function BoardClass:clearStaging()
  self.player:clearStaging()
  self.opponent:clearStaging()
end

function BoardClass:endTurn()
  for i = 1, 3 do

    -- Calls end turn event for all cards
    self.player.locations[i]:callOnEndTurn()
    self.opponent.locations[i]:callOnEndTurn()

    -- Adds round result to total score
    local pointDiff = self.player.locations[i]:getTotalPower() - self.opponent.locations[i]:getTotalPower()
    if pointDiff > 0 then
      self.player.points = self.player.points + pointDiff
    else
      self.opponent.points = self.opponent.points - pointDiff
    end
  end
end

function BoardClass:reset()
  self.player:reset()
  self.opponent:reset()
  self.round = 1
end
