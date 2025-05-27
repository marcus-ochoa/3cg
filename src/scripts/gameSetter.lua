
GameSetter = {}

local function parseLine(line)
	local values = {}

	for value in line:gmatch("[^,]+") do -- Note: We won't match empty values.
		-- Convert the value string to other Lua types in a "smart" way.
		if     tonumber(value)  then  table.insert(values, tonumber(value)) -- Number.
		elseif value == "true"  then  table.insert(values, true)            -- Boolean.
		elseif value == "false" then  table.insert(values, false)           -- Boolean.
		else                          table.insert(values, value)           -- String.
		end
	end

	return values
end

local function loadCardData()
  local filename = "cardData.csv"

  local cardData = {}

  for line in love.filesystem.lines(filename) do
    table.insert(cardData, parseLine(line))
  end

  for i = 2, #cardData do
    local cardVals = cardData[i]
    local card = CardDataClass:new(i, cardVals[1], cardVals[2], cardVals[3], cardVals[4])
    table.insert(CardDataClasses, card)
  end
end

local function shuffle(t)
    for i = #t, 2, -1 do
        local j = love.math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

local function setDecks()
  local cardPool = {}

  for i = 1, #CardDataClasses do
    table.insert(cardPool, i)
    table.insert(cardPool, i)
  end

  shuffle(cardPool)

  for i = 1, 20 do
    local cardData = CardDataClasses[cardPool[i]]
    Board.player.deck:addCard(CardClass:new(cardData))
  end

  shuffle(cardPool)

  for i = 1, 20 do
    local cardData = CardDataClasses[cardPool[i]]
    Board.opponent.deck:addCard(CardClass:new(cardData))
  end
end

local function setGame()
  setDecks()

  for _ = 1, 3 do
    Board.player.deck:moveCard(Board.player.hand)
    Board.opponent.deck:moveCard(Board.opponent.hand)
  end
end

function GameSetter.initializeGame()
  loadCardData()
  setGame()
end

function GameSetter.resetGame()
  loadCardData()

  Board:reset(true)
  Board:reset(false)

  setGame()
end