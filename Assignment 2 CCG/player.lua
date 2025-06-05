require("cardClass")
local json = require("dkjson")
io.stdout:setvbuf("no")

Player = {}

function Player:loadCardsFromJSON(filename)
    local file = love.filesystem.read(filename)
    if not file then
        error("Could not read JSON file!")
    end

    local cards, pos, err = json.decode(file, 1, nil)
    
    if err then
        error("Error parsing JSON: " .. err)
    end

    local functionFields = {"onReveal", "onDiscard", "onEndTurn"}
    for _, card in ipairs(cards) do
        for _, field in ipairs(functionFields) do
            if card[field] then
                card[field] = load("return " .. card[field])()
            end
        end
    end

    return cards
end

function Player:new(name)
    local player = {}
    local metadata = {__index = Player}
    setmetatable(player, metadata)
    player.name = name
    player.deck = {}
    player.hand = {}
    player.discard = {}
    player.stagedPlays = { {}, {}, {} }
    player.points = 0
    player.mana = 0

    player.cards = self:loadCardsFromJSON("data/card_list.json")
    print("made cards: ",player.cards[1].name)
    
    player.deck = self:generateDeck(player.cards)

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

function Player:generateDeck(cards)
    local deck = {}
    local cardCounts = {}
    print(cards)

    if #cards == 0 then
        error("The cards table is empty! Cannot generate deck.")
    end

    print("Cards available for deck generation: ", #cards)

    while #deck < 20 do
        local candidate = cards[math.random(#cards)]

        if candidate then
            cardCounts[candidate.name] = (cardCounts[candidate.name] or 0) + 1

            if cardCounts[candidate.name] <= 2 then
                local card = Card:new(candidate.name, candidate.cost, candidate.power, candidate.text)
                card.onReveal = candidate.onReveal
                card.onDiscard = candidate.onDiscard
                card.onEndTurn = candidate.onEndTurn  
                card.owner = self.name
                table.insert(deck, card)
            end
        else
            print("Warning: candidate is nil.")
        end
    end

    return deck
end

function Player:drawHand(index)
    local y = (index == 1) and 800 or 100
    for i, card in ipairs(self.hand) do
        if (self.name == "AI") then
            card.flipped = true
        end
        if card ~= draggedCard then
            card.x = 100 + (i - 1) * 89
            card.y = y

            if card then
                card:draw()
            else
                print("Warning: card is nil or missing draw method at index " .. tostring(i))
            end
        end
    end
end

function Player:drawDiscardPile(index)
    local xStart = 800  
    local y = (index == 1) and 800 or 0

    for i, card in ipairs(self.discard) do
        card.x = xStart + (i - 1) * 11  
        card.y = y
        card:draw()
        card.flipped = false
        local prevFont = love.graphics.getFont()
        love.graphics.setFont(love.graphics.newFont(8))
        love.graphics.setColor(1, 0, 0)
        love.graphics.printf("Discarded", card.x-40, card.y + 40, 110, "center")
        love.graphics.setFont(prevFont)
    end
end

function Player:stageCard(locationIndex, card)
    if not self.stagedPlays[locationIndex] then
        self.stagedPlays[locationIndex] = {}
    end

    if #self.stagedPlays[locationIndex] < 4 then
        table.insert(self.stagedPlays[locationIndex], card)
        self.mana = self.mana - card.cost
        self:removeFromHand(card)
    else
        print("Not enough mana to play: ", card.name)
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
