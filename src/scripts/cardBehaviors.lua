
CardBehaviors = {
  reveal = {

    function (card)
      local target = Board:getOpposition(card:getOwner())
      target.hand:addPower(-1)
    end,

    function (card)
      local target = card:getOwner()
      target.hand:addPower(1)
    end,

    function (card)
      local target = Board:getOpposition(card:getOwner())
      card:addPower(target.locations[card.container.location]:getNumberOfCards() * 2)
    end,

    function (card)
      Board.player.locations[card.container.location]:setPower(3)
      Board.opponent.locations[card.container.location]:setPower(3)
    end,

    function (card)
      local target = Board:getOpposition(card:getOwner())
      target.locations[card.container.location]:addPower(-1)
    end,
  },

  endTurn = {

    function (card)
      local target = card:getOwner()

      if not target:isWinningAtLocation(card.container.location) then
        card:addPower(-1)
      end
    end,

    function (card)
      if card.power >= 7 then
        card:discard()
      else
        card:addPower(1)
      end
    end,
  },

  discard = {

    function (card)
      local target = card:getOwner()
      for i = 1, 2 do
        local cardCopy = card:getCopy()
        target.hand:addCard(cardCopy)
      end
    end,
  },

  cardPlayedHere = {
    
    function (card, playedCard)
      playedCard:addPower(-1)
    end,

    function (card, playedCard)
      if playedCard:getOwner() == card:getOwner() then
        card:addPower(1)
      end
    end,
  }
}