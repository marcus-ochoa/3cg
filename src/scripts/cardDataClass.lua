
CardDataClass = {}

function CardDataClass:new(id, name, cost, power, text)
  local card = {}
  local metadata = {__index = CardDataClass}
  setmetatable(card, metadata)

  card.id = id
  card.name = name
  card.text = text
  card.cost = cost
  card.power = power

  return card
end