require("cardClass")
Player = {}

local CardList = require("data.cards_list")

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


function generateDeck()
  local deck = {}
  local cardCounts = {}

  while #deck < 20 do
  local candidate = CardList[math.random(#CardList)]
  cardCounts[candidate.name] = (cardCounts[candidate.name] or 0) + 1

  if cardCounts[candidate.name] <= 2 then
    -- Use the constructor to create a proper Card object
    local card = Card:new(candidate.name, candidate.cost, candidate.power, candidate.text)
    
    
    card.flipped = false
    card.x, card.y = 0, 0
    -- Optional: attach effect if needed
    -- card.effect = candidate.effect

    table.insert(deck, card)
    print(card.name)
    
  end
end
return deck
end


player.deck = generateDeck()

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
    if (self.name == "AI") then
      card.flipped = true
    end
    if card ~= draggedCard then
    card.x = 100 + (i - 1) * 110
    card.y = y
    
    if card and card.draw then
      card:draw()
    else
      print("Warning: card is nil or missing draw method at index " .. tostring(i))
    end
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