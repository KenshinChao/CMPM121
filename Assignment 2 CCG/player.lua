require("cardClass")
Player = {}


function Player:new(name)
  local player = {}
  local metadata = {__index = Player}
  setmetatable(player,metadata)
  player.name = name
  player.deck = {}
  player.hand = {}
  player.discard = {}
  player.stagedPlays = { {}, {}, {} }
  player.points = 0
  player.mana = 0

  for i = 1, 20 do
    local card = Card:new("Basic" .. i, i % 4 + 1, i % 5 + 1, "")
    table.insert(player.deck, card)

    --print(card)
  end

  for _ = 1, 3 do 
    player:drawCard() 
  end
  return player
end

function Player:drawCard()
  if #self.deck > 0 and #self.hand < 7 then
    table.insert(self.hand, table.remove(self.deck, 1))
  end
end

function Player:drawHand(index)
  local y = (index == 1) and 800 or 100
  for i, card in ipairs(self.hand) do
    --print(card)
    if card ~= draggedCard then
    card.x = 100 + (i - 1) * 110
    card.y = y
    card:draw()
    end
  end
end

function Player:stageCard(locationIndex, card)
  if #self.stagedPlays[locationIndex] < 4 --[[ and self.mana >= card.cost --]]then
    table.insert(self.stagedPlays[locationIndex], card)
    self.mana = self.mana - card.cost
    self:removeFromHand(card)
  else
    print("not enough mana to play: ", card.name)
  end

end

function Player:removeFromHand(card)
  for i, c in ipairs(self.hand) do
    if c == card then table.remove(self.hand, i) 
      break 
    end
  end
end

return Player