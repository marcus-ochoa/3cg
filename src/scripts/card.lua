
-- Native card sprite size is 70 x 95

-- === USED STARTER CODE FROM CLASS == 

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}

function CardClass:new(name, text, cost, power)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)

  card.size = Vector(70, 95)
  card.state = CARD_STATE.IDLE
  
  card.name = name
  card.text = text

  card.cost = cost
  card.baseCost = cost

  card.power = power
  card.basePower = power

  card.isFaceUp = true
  card.isPlayed = false
  
  return card
end

function CardClass:draw(position)

  -- Draw shadow if cards are not idle (light if mouse hovering, heavy if grabbed)
  if self.state ~= CARD_STATE.IDLE then
    love.graphics.setColor(0, 0, 0, 0.8)
    local offset = 4 * (self.state == CARD_STATE.GRABBED and 2 or 1)
    love.graphics.rectangle("fill", position.x + offset, position.y + offset, self.size.x, self.size.y, 6, 6)
  end

  love.graphics.setColor(1, 1, 1, 1)

  -- Draws face up or face down image
  if self.isFaceUp then
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", position.x, position.y, self.size.x, self.size.y, 6, 6)
  else
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", position.x, position.y, self.size.x, self.size.y, 6, 6)
  end
end

-- Checks if the mouse is over the card and updates state accordingly
function CardClass:checkForMouseOver(position, mousePosition)

  if (not self.isFaceUp) or (self.isPlayed) then
    self.state = CARD_STATE.IDLE
    return
  end

  local isMouseOver = 
    mousePosition.x > position.x and
    mousePosition.x < position.x + self.size.x and
    mousePosition.y > position.y and
    mousePosition.y < position.y + self.size.y

  self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
  return isMouseOver
end

function CardClass:setGrabbed()
  self.state = CARD_STATE.GRABBED
end

function CardClass:setReleased()
  self.state = CARD_STATE.IDLE
end

-- Sets card state back to idle from mouse over
function CardClass:setIdle()
  if self.state ~= CARD_STATE.GRABBED then
    self.state = CARD_STATE.IDLE
  end
end