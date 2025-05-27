
CardBehaviors = {
  reveal = {

    function (card)
      local target = card.container.isPlayerOwned and Board.opponent or Board.player
      target.hand:addPower(-1)
    end,

    function (card)
      local target = card.container.isPlayerOwned and Board.Player or Board.opponent
      target.hand:addPower(1)
    end,

    function (card)
      local target = card.container.isPlayerOwned and Board.opponent or Board.player
      card:addPower(target.locations[card.container.location]:getNumberOfCards() * 2)
    end,
  },

  endTurn = {

  },

  discard = {

  },

  cardPlayedHere = {

  }
}