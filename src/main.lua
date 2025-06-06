-- Marcus Ochoa
-- CMPM 121 - 3CG

io.stdout:setvbuf("no")

require "scripts.vector"
require "scripts.colors"
require "scripts.gameManager"
require "src.scripts.uiManager"
require "scripts.board"
require "scripts.grabber"
require "scripts.gameSetter"

require "scripts.cardContainer"
require "scripts.cardDisplayer"
require "scripts.card"
require "scripts.cardDataClass"
require "scripts.cardBehaviors"
require "scripts.textbox"
require "scripts.button"

function love.load()

  -- Window setup
  love.window.setMode(1920, 1080, {fullscreen=true})
  love.window.setTitle("I'm Gonna Snap")
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)

  GameManager = GameManagerClass:new()
  Board = BoardClass:new()
  UIManager = UIManagerClass:new()
  UIManager:setup()
  Grabber = GrabberClass:new()
  CardDataClasses = {}

  GameSetter.initializeGame()
  GameManager:updateGameState(GAME_STATE.MENU)
end

-- Draw UI
function love.draw()
  UIManager:draw()
end

function love.update()
  UIManager:update()
end

-- Tie engine mouse events to the grabber
function love.mousereleased(x, y, button)
  if button == 1 then
    Grabber:onMouseReleased(x, y)
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    Grabber:onMousePressed(x, y)
  end
end

function love.mousemoved(x, y)
  Grabber:onMouseMoved(x, y)
end
