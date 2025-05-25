
UIManagerClass = {}

function UIManagerClass:new()
  local uiManager = {}
  local metadata = {__index = UIManagerClass}
  setmetatable(uiManager, metadata)

  uiManager.gameState = GAME_STATE.MENU
  uiManager.board = BoardClass:new();

  uiManager.cardDisplayers = {
    interactables = {
      CardDisplayerClass:new(Board.player.hand),
      CardDisplayerClass:new(Board.player.locations[LOCATIONS.A]),
      CardDisplayerClass:new(Board.player.locations[LOCATIONS.B]),
      CardDisplayerClass:new(Board.player.locations[LOCATIONS.C]),
    },
    other = {
      CardDisplayerClass:new(Board.opponent.locations[LOCATIONS.A]),
      CardDisplayerClass:new(Board.opponent.locations[LOCATIONS.B]),
      CardDisplayerClass:new(Board.opponent.locations[LOCATIONS.C]),
    }
  }

  uiManager.buttons = {
    ButtonClass:new(),
    ButtonClass:new()
  }

  return uiManager
end

