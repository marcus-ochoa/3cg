
GameSetter = {}

local function parseLine(line)
	local values = {}

  -- TAKEN FROM LUA DOCS, matches csv entries to data type
	for value in line:gmatch("[^,]+") do

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

  -- Loads card data into the global data classes
  for i = 2, #cardData do
    local cardVals = cardData[i]
    ---@diagnostic disable-next-line: deprecated
    local card = CardDataClass:new(i - 1, unpack(cardVals))
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

  -- Set player decks
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

  -- Deal inital hands
  for _ = 1, 3 do
    Board.player.deck:moveCard(Board.player.hand)
    Board.opponent.deck:moveCard(Board.opponent.hand)
  end
end

function GameSetter.initializeGame()
  loadCardData()
end

function GameSetter.resetGame()
  Board:reset()
  setGame()
end