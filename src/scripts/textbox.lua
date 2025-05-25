
TextboxClass = {}

function TextboxClass:new(xPos, yPos, xSize, ySize, text, fillColor)
  local textbox = {}
  local metadata = {__index = TextboxClass}
  setmetatable(textbox, metadata)

  textbox.position = Vector(xPos, yPos)
  textbox.size = Vector(xSize, ySize)
  textbox.active = true;
  textbox.text = text
  textbox.fillColor = fillColor;

  return textbox
end

function TextboxClass:draw()

  if not self.active then
    return
  end

  -- Draw back fill
  love.graphics.setColor(self.fillColor or {0.5, 0.5, 0.5, 1})
  love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y)

  -- Draw text if set
  if self.text ~= nil then
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(self.text, self.position.x, self.position.y - 8 + (self.size.y / 2), self.size.x, "center")
  end
end