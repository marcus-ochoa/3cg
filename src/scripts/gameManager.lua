
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
end