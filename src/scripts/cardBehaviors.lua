
CardBehaviors = {
  reveal = {

    function (card)
      local target = Board:getSubject(not card.container.isPlayerOwned)
      target.hand:addPower(-1)
    end,

    function (card)
      local target = Board:getSubject(card.container.isPlayerOwned)
      target.hand:addPower(1)
    end,

    function (card)
      local target = Board:getSubject(not card.container.isPlayerOwned)
      card:addPower(target.locations[card.container.location]:getNumberOfCards() * 2)
    end,

    function (card)
      Board.player.locations[card.container.location]:setPower(3)
      Board.opponent.locations[card.container.location]:setPower(3)
    end,

    function (card)
      local target = Board:getSubject(not card.container.isPlayerOwned)
      target.locations[card.container.location]:addPower(-1)
    end,
  },

  endTurn = {

    function (card)
      if not Board:isWinningAtLocation(card.container.isPlayerOwned, card.container.location) then
        card:addPower(-1)
      end
    end,

    function (card)
      if card.power >= 7 then
        Board:discardCard()
      else
        card:addPower(1)
      end
    end,
  },

  discard = {

    function (card)
      local target = Board:getSubject(card.container.isPlayerOwned)
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
      if playedCard.container.isPlayerOwned == card.container.isPlayerOwned then
        card:addPower(1)
      end
    end,
  }
}