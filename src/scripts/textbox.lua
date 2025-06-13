
TextboxClass = {}

function TextboxClass:new(xPos, yPos, xSize, ySize, layer, text, fillEnabled, fillColor, rounded, font, yOffset)
  local textbox = {}
  local metadata = {__index = TextboxClass}
  setmetatable(textbox, metadata)

  textbox.position = Vector(xPos, yPos)
  textbox.size = Vector(xSize, ySize)
  textbox.active = true
  textbox.text = text
  textbox.fillEnabled = fillEnabled
  textbox.fillColor = fillColor or Colors.gray
  textbox.rounded = rounded or false
  textbox.font = font or Fonts.titilliumLarge
  textbox.yOffset = yOffset or -8

  UIManager:registerDrawable(textbox, layer)

  return textbox
end

function TextboxClass:draw()

  if not self.active then
    return
  end

  -- Draws back fill if set
  if self.fillEnabled then
    love.graphics.setColor(self.fillColor)
    if self.rounded then
      love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
    else
      love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y)
    end
  end

  -- Draw text if set
  if self.text ~= nil then
    love.graphics.setColor(Colors.white)
    love.graphics.setFont(self.font)
    love.graphics.printf(self.text, self.position.x, self.position.y + self.yOffset + (self.size.y / 2), self.size.x, "center")
  end
end