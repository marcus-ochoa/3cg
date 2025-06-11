
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

  board.revealCoroutine = nil

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

function BoardClass:revealCards(revealTime)
  
  local winningEntity = self:getWinningEntity()

  -- Choose who to reveal first randomly if tied
  if winningEntity == nil then
    winningEntity = (love.math.random(2) == 2) and self.player or self.opponent
  end

  local losingEntity = self:getOpposition(winningEntity)

  -- Coroutine to reveal cards on both sides with given reveal time between cards
  self.revealCoroutine = coroutine.create(function ()

    local timer = 0

    while timer < revealTime do
        timer = timer + coroutine.yield()
    end
    timer = 0
    
    for _, card in ipairs(winningEntity.staged.cardTable) do
      card:onReveal()
      
      -- Calls card played here event for all cards at the location
      self.player.locations[card.container.location]:callOnCardPlayedHere(card)
      self.opponent.locations[card.container.location]:callOnCardPlayedHere(card)

      while timer < revealTime do
        timer = timer + coroutine.yield()
      end
      timer = 0
    end

    for _, card in ipairs(losingEntity.staged.cardTable) do
      card:onReveal()

      -- Calls card played here event for all cards at the location
      self.player.locations[card.container.location]:callOnCardPlayedHere(card)
      self.opponent.locations[card.container.location]:callOnCardPlayedHere(card)

      while timer < revealTime do
        timer = timer + coroutine.yield()
      end
      timer = 0
    end

    while timer < revealTime do
        timer = timer + coroutine.yield()
    end
    timer = 0

    GameManager:updateGameState(GAME_STATE.EVAL)
  end)
end

function BoardClass:update(dt)

  -- Continue the reveal coroutine if it is yielded and pass in dt for calculations
  if self.revealCoroutine and coroutine.status(self.revealCoroutine) ~= "dead" then
    coroutine.resume(self.revealCoroutine, dt)
    return
  end

  self.revealCoroutine = nil
end
