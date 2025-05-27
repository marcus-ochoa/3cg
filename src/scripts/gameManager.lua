
GAME_STATE = {
  MENU = 0,
  PLAYER_TURN = 1,
  OPPONENT_TURN = 2,
  REVEAL = 3,
  RESULT = 4
}

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

  print("Game state updated: " .. self.gameState)
  UIManager:updateGameState(newGameState)

  if self.gameState == GAME_STATE.MENU then
    print("chillin in menu")
  
  elseif self.gameState == GAME_STATE.PLAYER_TURN then
    Board:addMana(true, 1)
    Board:addMana(false, 1)
  
  elseif self.gameState == GAME_STATE.OPPONENT_TURN then
    for _, card in ipairs(Board.opponent.hand.cardTable) do
      Board.opponent.hand:moveCard(Board.opponent.locations[love.math.random(3)], card)
    end

    Board.player.staged:setFaceUp(false)
    Board.opponent.staged:setFaceUp(false)
  end

end