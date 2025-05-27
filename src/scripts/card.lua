
-- Native card sprite size is 70 x 95

-- === USED STARTER CODE FROM CLASS == 

CARD_SIZE = Vector(140, 180)

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}

CardClass = {}

function CardClass:new(cardDataClass)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)

  card.id = cardDataClass.id

  card.size = CARD_SIZE
  card.state = CARD_STATE.IDLE
  
  card.name = cardDataClass.name
  card.text = cardDataClass.text

  card.cost = cardDataClass.cost
  card.baseCost = cardDataClass.cost

  card.power = cardDataClass.power
  card.basePower = cardDataClass.power

  card.isFaceUp = true
  card.isPlayed = false

  card.container = nil
  
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

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(self.name, position.x, position.y - 8 + (self.size.y * (1/10)), self.size.x - 8, "center")
    love.graphics.printf("Cost: " .. self.cost, position.x, position.y - 8 + (self.size.y * (2/10)), self.size.x - 8, "center")
    love.graphics.printf("Power: " .. self.power, position.x, position.y - 8 + (self.size.y * (3/10)), self.size.x - 8, "center")
    love.graphics.printf(self.text, position.x + 8, position.y - 8 + (self.size.y * (5/10)), self.size.x - 8, "left")
  else
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", position.x, position.y, self.size.x, self.size.y, 6, 6)
    love.graphics.setColor(0.7, 0, 0.5, 1)
    love.graphics.rectangle("fill", position.x + 5, position.y + 5, self.size.x - 10, self.size.y - 10, 6, 6)
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

function CardClass:addPower(powerToAdd)
  if (self.power + powerToAdd) >= 0 then
      self.power = self.power + powerToAdd
    end
end