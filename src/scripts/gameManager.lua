
GAME_STATE = {
  MENU = 0,
  PLAYER_TURN = 1,
  OPPONENT_TURN = 2,
  REVEAL = 3,
  EVAL = 4,
  RESULT = 5
}

WIN_POINTS = 25

GameManagerClass = {}

function GameManagerClass:new()
  
  local gameManager = {}
  local metadata = {__index = GameManagerClass}
  setmetatable(gameManager, metadata)

  gameManager.gameState = GAME_STATE.MENU

  return gameManager
end

function GameManagerClass:updateGameState(newGameState)
  self.gameState = newGameState
  UIManager:updateGameState(newGameState)

  if self.gameState == GAME_STATE.MENU then
    GameSetter.resetGame()
  
  elseif self.gameState == GAME_STATE.PLAYER_TURN then
    Board:setMana(Board.round)
    Board:drawCard()
  
  elseif self.gameState == GAME_STATE.OPPONENT_TURN then

    -- Basic AI opponent card play by attempting to move cards in hand to random locations
    for _, card in ipairs(Board.opponent.hand.cardTable) do
      Board.opponent.hand:moveCard(Board.opponent.locations[love.math.random(3)], card)
    end

    Board.player.staged:setFaceUp(false)
    Board.opponent.staged:setFaceUp(false)
    self:updateGameState(GAME_STATE.REVEAL)

  elseif self.gameState == GAME_STATE.REVEAL then

    Board:revealCards(0.5)

  elseif self.gameState == GAME_STATE.EVAL then

    Board:clearStaging()

    Board:endTurn()
    Board.round = Board.round + 1

    -- Check win/loss state
    if (Board.player.points >= WIN_POINTS or Board.opponent.points >= WIN_POINTS) and Board.player.points ~= Board.opponent.points then
      if Board.player.points > Board.opponent.points then
        UIManager.textboxes.general.result.text = "YOU WIN"
      else
        UIManager.textboxes.general.result.text = "YOU LOSE"
      end
      self:updateGameState(GAME_STATE.RESULT)
    else
      self:updateGameState(GAME_STATE.PLAYER_TURN)
    end
  end
end

function GameManagerClass:closeGame()
  love.event.quit()
end