
CardDataClass = {}

function CardDataClass:new(id, name, cost, power, text, revealBehaviorId, endTurnBehaviorId, discardBehaviorId, cardPlayedHereBehaviorId)
  local card = {}
  local metadata = {__index = CardDataClass}
  setmetatable(card, metadata)

  card.id = id
  card.name = name
  card.text = text
  card.cost = cost
  card.power = power

  card.revealBehavior = (revealBehaviorId < 1) and nil or CardBehaviors.reveal[revealBehaviorId]
  card.endTurnBehavior = (endTurnBehaviorId < 1) and nil or CardBehaviors.endTurn[endTurnBehaviorId]
  card.discardBehavior = (discardBehaviorId < 1) and nil or CardBehaviors.discard[discardBehaviorId]
  card.cardPlayedHereBehavior = (cardPlayedHereBehaviorId < 1) and nil or CardBehaviors.cardPlayedHere[cardPlayedHereBehaviorId]

  return card
end