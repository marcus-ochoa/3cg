
ButtonClass = {}

function ButtonClass:new(xPos, yPos, xSize, ySize, layer, owner, event, args, text)
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
  button.args = args

  UIManager:registerDrawable(button, layer)
  UIManager:registerClickable(button)

  return button
end

function ButtonClass:draw()

  if not self.active then
    return
  end

  -- Draw shadow if mouse over button
  if self.mouseOver then
    love.graphics.setColor(Colors.shadow)
    local offset = 4
    love.graphics.rectangle("fill", self.position.x + offset, self.position.y + offset, self.size.x, self.size.y, 6, 6)
  end

  -- Draw back fill
  love.graphics.setColor(Colors.blue)
  love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)

  -- Draw text if set
  if self.text ~= nil then
    love.graphics.setColor(Colors.white)
    love.graphics.setFont(Fonts.titillium)
    love.graphics.printf(self.text, self.position.x, self.position.y - 15 + (self.size.y / 2), self.size.x, "center")
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
function ButtonClass:click()

  if (self.args == nil) then
    self.event(self.owner)
  else
  
  ---@diagnostic disable-next-line: deprecated
  self.event(self.owner, unpack(self.args))
  end
end