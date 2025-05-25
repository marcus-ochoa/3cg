
ButtonClass = {}

function ButtonClass:new(xPos, yPos, xSize, ySize, owner, event, text)
  local button = {}
  local metadata = {__index = ButtonClass}
  setmetatable(button, metadata)

  button.position = Vector(xPos, yPos)
  button.size = Vector(xSize, ySize)
  button.active = true;
  button.mouseOver = false;
  button.text = text

  -- Owner and function to call when button pressed
  button.owner = owner
  button.event = event

  return button
end

function ButtonClass:draw()

  if not self.active then
    return
  end

  -- Draw shadow if mouse over button
  if self.mouseOver then
    love.graphics.setColor(0, 0, 0, 0.8)
    local offset = 4
    love.graphics.rectangle("fill", self.position.x + offset, self.position.y + offset, self.size.x, self.size.y, 6, 6)
  end

  -- Draw back fill
  love.graphics.setColor(0.5, 0.5, 0.5, 1)
  love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y)

  -- Draw text if set
  if self.text ~= nil then
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(self.text, self.position.x, self.position.y - 8 + (self.size.y / 2), self.size.x, "center")
  end
end

-- Checks if the mouse is over the button and set state accordingly
function ButtonClass:checkForMouseOver(x, y)

  if not self.active then
    return false
  end

  local isMouseOver = 
    x > self.position.x and
    x < self.position.x + self.size.x and
    y > self.position.y and
    y < self.position.y + self.size.y

  self.mouseOver = isMouseOver and true or false
  return isMouseOver
end

-- Runs event when clicked
function ButtonClass:onClicked()
  self.event(self.owner)
end