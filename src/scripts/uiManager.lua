
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
    submit = ButtonClass:new(1300, 1000, 100, 50, 1, GameManager, GameManager.updateGameState, {GAME_STATE.OPPONENT_TURN}, "SUBMIT"),
    menu = ButtonClass:new(1420, 1000, 100, 50, 1, GameManager, GameManager.updateGameState, {GAME_STATE.MENU}, "MENU"),
    restart = ButtonClass:new(910, 600, 100, 50, 3, GameManager, GameManager.updateGameState, {GAME_STATE.MENU}, "RESTART"),
    start = ButtonClass:new(910, 600, 100, 50, 3, GameManager, GameManager.updateGameState, {GAME_STATE.PLAYER_TURN}, "START"),
    exit = ButtonClass:new(910, 700, 100, 50, 3, GameManager, GameManager.closeGame, {}, "EXIT"),
  }

  self.textboxes = {
    general = {
      playerMana = TextboxClass:new(1310, 900, 80, 80, 1, "mana", true, Colors.purple, true, nil, -26),
      playerPoints = TextboxClass:new(1500, 600, 100, 100, 1, "points", true, Colors.purple, true, nil, -26),
      opponentPoints = TextboxClass:new(1500, 200, 100, 100, 1, "opp points", true, Colors.purple, true, nil, -26),
      menu = TextboxClass:new(0, 0, 1920, 1080, 2, "I'M GONNA SNAP\n(a Marvel Snap-pish game)", true, Colors.purple, false, Fonts.vast, -200),
      result = TextboxClass:new(0, 0, 1920, 1080, 2, "YOU [RESULT]", true, Colors.film),
    },
    playerLocations = {
      TextboxClass:new(430, 600, 50, 50, 1, "placeholder", true, Colors.purple, true, nil, -16),
      TextboxClass:new(880, 600, 50, 50, 1, "placeholder", true, Colors.purple, true, nil, -16),
      TextboxClass:new(1330, 600, 50, 50, 1, "placeholder", true, Colors.purple, true, nil, -16)
    },
    opponentLocations = {
      TextboxClass:new(430, 200, 50, 50, 1, "placeholder", true, Colors.purple, true, nil, -16),
      TextboxClass:new(880, 200, 50, 50, 1, "placeholder", true, Colors.purple, true, nil, -16),
      TextboxClass:new(1330, 200, 50, 50, 1, "placeholder", true, Colors.purple, true, nil, -16)
    },
    totalLocations = {
      TextboxClass:new(430, 409, 50, 50, 1, "placeholder", true, Colors.purple, true, nil, -16),
      TextboxClass:new(880, 409, 50, 50, 1, "placeholder", true, Colors.purple, true, nil, -16),
      TextboxClass:new(1330, 409, 50, 50, 1, "placeholder", true, Colors.purple, true, nil, -16)
    }
  }

end

function UIManagerClass:update()
  
  -- Updating general board info
  self.textboxes.general.playerMana.text = "MANA\n" .. tostring(Board.player.mana)
  self.textboxes.general.playerPoints.text = "PLYR PTS\n" .. tostring(Board.player.points)
  self.textboxes.general.opponentPoints.text = "OPP PTS\n" .. tostring(Board.opponent.points)

  -- Updating player location powers
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
  
  -- Draw all objects in the drawables table
  for _, layer in ipairs(self.drawables) do
    for _, drawable in ipairs(layer) do
      drawable:draw()
    end
  end
end

function UIManagerClass:registerDrawable(drawable, layer)

  -- Ensures object can be drawn and adds it to the draw table
  if type(drawable.draw) ~= "function" then
    print("ERROR: trying to register drawable without draw function")
  end
  
  table.insert(self.drawables[layer], drawable)
end

function UIManagerClass:registerClickable(clickable)

  -- Ensures object can be drawn and adds it to the click table
  if type(clickable.click) ~= "function" then
    print("ERROR: trying to register drawable without draw function")
  end
  
  table.insert(self.clickables, clickable)
end

function UIManagerClass:setCardsInteractable(isInteractable)

  -- Sets interactability of all interactable card displayers
  for _, displayer in ipairs(self.cardDisplayers.interactables) do
    displayer.interactable = isInteractable
  end
end

function UIManagerClass:updateGameState(newGameState)
  
  -- Called from game manager to update ui accordingly
  if (newGameState == GAME_STATE.MENU) then
    self:setCardsInteractable(false)
    self.buttons.submit.active = false
    self.buttons.restart.active = false
    self.buttons.menu.active = false
    self.buttons.start.active = true
    self.buttons.exit.active = true
    self.textboxes.general.result.active = false
    self.textboxes.general.menu.active = true
  
  elseif newGameState == GAME_STATE.PLAYER_TURN then
    self:setCardsInteractable(true)
    self.buttons.submit.active = true
    self.buttons.menu.active = true
    self.buttons.start.active = false
    self.buttons.exit.active = false
    self.textboxes.general.menu.active = false
  
  elseif newGameState == GAME_STATE.OPPONENT_TURN then
    self:setCardsInteractable(false)
    self.buttons.submit.active = false

  elseif newGameState == GAME_STATE.REVEAL then
    self.buttons.menu.active = false

  elseif newGameState == GAME_STATE.RESULT then
    self.buttons.restart.active = true
    self.textboxes.general.result.active = true
  end
end
