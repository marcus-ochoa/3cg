
UIManagerClass = {}

function UIManagerClass:new()
  local uiManager = {}
  local metadata = {__index = UIManagerClass}
  setmetatable(uiManager, metadata)

  uiManager.drawables = {
    {},
    {},
    {}
  }

  uiManager.clickables = {}

  return uiManager
end

function UIManagerClass:setup()
  
  self.cardDisplayers = {
    interactables = {
      CardDisplayerClass:new(200, 875, CARD_SIZE.x * 7 + 80, CARD_SIZE.y + 20, 1, 10 + CARD_SIZE.x, 0, 10, 10, 1, true, Board.player.hand, true),
      CardDisplayerClass:new(100, 450, CARD_SIZE.x * 2 + 30, CARD_SIZE.y * 2 + 30, 1, 10 + CARD_SIZE.x, 10 + CARD_SIZE.y, 10, 10, 2, true, Board.player.locations[LOCATIONS.A], true),
      CardDisplayerClass:new(550, 450, CARD_SIZE.x * 2 + 30, CARD_SIZE.y * 2 + 30, 1, 10 + CARD_SIZE.x, 10 + CARD_SIZE.y, 10, 10, 2, true, Board.player.locations[LOCATIONS.B], true),
      CardDisplayerClass:new(1000, 450, CARD_SIZE.x * 2 + 30, CARD_SIZE.y * 2 + 30, 1, 10 + CARD_SIZE.x, 10 + CARD_SIZE.y, 10, 10, 2, true, Board.player.locations[LOCATIONS.C], true),
    },
    other = {
      CardDisplayerClass:new(100, 25, CARD_SIZE.x * 2 + 30, CARD_SIZE.y * 2 + 30, 1, 10 + CARD_SIZE.x, 10 + CARD_SIZE.y, 10, 10, 2, false, Board.opponent.locations[LOCATIONS.A], true),
      CardDisplayerClass:new(550, 25, CARD_SIZE.x * 2 + 30, CARD_SIZE.y * 2 + 30, 1, 10 + CARD_SIZE.x, 10 + CARD_SIZE.y, 10, 10, 2, false, Board.opponent.locations[LOCATIONS.B], true),
      CardDisplayerClass:new(1000, 25, CARD_SIZE.x * 2 + 30, CARD_SIZE.y * 2 + 30, 1, 10 + CARD_SIZE.x, 10 + CARD_SIZE.y, 10, 10, 2, false, Board.opponent.locations[LOCATIONS.C], true),
    }
  }

  self.buttons = {
    submit = ButtonClass:new(1300, 1000, 100, 50, 1, GameManager, GameManager.updateGameState, {GAME_STATE.OPPONENT_TURN}, "submit"),
    restart = ButtonClass:new(850, 600, 100, 50, 3, GameManager, GameManager.updateGameState, {GAME_STATE.MENU}, "restart"),
    start = ButtonClass:new(850, 600, 100, 50, 3, GameManager, GameManager.updateGameState, {GAME_STATE.PLAYER_TURN}, "start"),
  }

  self.textboxes = {
    general = {
      playerMana = TextboxClass:new(1300, 900, 100, 50, 1, "mana", false),
      playerPoints = TextboxClass:new(1500, 600, 150, 50, 1, "points", false),
      opponentPoints = TextboxClass:new(1500, 200, 150, 50, 1, "opp points", false),
      menu = TextboxClass:new(0, 0, 1800, 1100, 2, "IM GONNA SNAP\n(a Marvel Snap-pish game)", true, {0.7, 0, 0.5, 1}),
      result = TextboxClass:new(0, 0, 1800, 1100, 2, "YOU SOMETHING", true, {0.7, 0, 0.5, 1}),
    },
    playerLocations = {
      TextboxClass:new(420, 600, 100, 50, 1, "placeholder", false),
      TextboxClass:new(870, 600, 100, 50, 1, "placeholder", false),
      TextboxClass:new(1320, 600, 100, 50, 1, "placeholder", false)
    },
    opponentLocations = {
      TextboxClass:new(420, 200, 100, 50, 1, "placeholder", false),
      TextboxClass:new(870, 200, 100, 50, 1, "placeholder", false),
      TextboxClass:new(1320, 200, 100, 50, 1, "placeholder", false)
    },
    totalLocations = {
      TextboxClass:new(420, 410, 100, 50, 1, "placeholder", false),
      TextboxClass:new(870, 410, 100, 50, 1, "placeholder", false),
      TextboxClass:new(1320, 410, 100, 50, 1, "placeholder", false)
    }
  }

end

function UIManagerClass:update()
  
  self.textboxes.general.playerMana.text = "Mana: " .. tostring(Board.player.mana)
  self.textboxes.general.playerPoints.text = "Player Points: " .. tostring(Board.player.points)
  self.textboxes.general.opponentPoints.text = "Opponent Points: " .. tostring(Board.opponent.points)

  for i, location in ipairs(Board.player.locations) do
    self.textboxes.playerLocations[i].text = location:getTotalPower()
  end

  for i, location in ipairs(Board.opponent.locations) do
    self.textboxes.opponentLocations[i].text = location:getTotalPower()
  end

  for i, locationTextbox in ipairs(self.textboxes.totalLocations) do
    locationTextbox.text = Board.player.locations[i]:getTotalPower() - Board.opponent.locations[i]:getTotalPower()
  end
end

function UIManagerClass:draw()
  for _, layer in ipairs(self.drawables) do
    for _, drawable in ipairs(layer) do
      drawable:draw()
    end
  end
end

function UIManagerClass:registerDrawable(drawable, layer)
  if type(drawable.draw) ~= "function" then
    print("ERROR: trying to register drawable without draw function")
  end
  
  table.insert(self.drawables[layer], drawable)
end

function UIManagerClass:registerClickable(clickable)
  if type(clickable.click) ~= "function" then
    print("ERROR: trying to register drawable without draw function")
  end
  
  table.insert(self.clickables, clickable)
end

function UIManagerClass:setCardsInteractable(isInteractable)
  for _, displayer in ipairs(self.cardDisplayers.interactables) do
    displayer.interactable = isInteractable
  end
end

function UIManagerClass:updateGameState(newGameState)
  
  if (newGameState == GAME_STATE.MENU) then
    self:setCardsInteractable(false)
    self.buttons.submit.active = false
    self.buttons.restart.active = false
    self.buttons.start.active = true
    self.textboxes.general.result.active = false
    self.textboxes.general.menu.active = true
  
  elseif newGameState == GAME_STATE.PLAYER_TURN then
    self:setCardsInteractable(true)
    self.buttons.submit.active = true
    self.buttons.start.active = false
    self.textboxes.general.menu.active = false
  
  elseif newGameState == GAME_STATE.OPPONENT_TURN then
    self:setCardsInteractable(false)
    self.buttons.submit.active = false

  elseif newGameState == GAME_STATE.RESULT then
    self.buttons.restart.active = true
    self.textboxes.general.result.active = true
  end

end





