require("cardClass")
local json = require("dkjson")  -- Assuming dkjson is used to parse JSON
io.stdout:setvbuf("no")

Player = {}

-- Load card data from a JSON file
function Player:loadCardsFromJSON(filename)
    local file = love.filesystem.read(filename)
    if not file then
        error("Could not read JSON file!")
    end

    -- Decode JSON data into a Lua table
    local cards, pos, err = json.decode(file, 1, nil)
    
    if err then
        error("Error parsing JSON: " .. err)
    end

    -- Process each card by converting function fields to Lua functions
    local functionFields = {"onReveal", "onDiscard", "onEndTurn"}
    for _, card in ipairs(cards) do
        -- Process each function-like field
        for _, field in ipairs(functionFields) do
            if card[field] then
                -- Convert the function string to an actual function
                -- Wrap the function in a safer environment
                card[field] = load("return " .. card[field])()
            end
        end
    end

    return cards
end

-- Initialize the player object
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

    -- Load the cards from the JSON file
    player.cards = self:loadCardsFromJSON("data/card_list.json")  -- Assuming cards.json is in the same directory
    print("made cards: ",player.cards[1].name)
    
    -- Generate the deck
    player.deck = self:generateDeck(player.cards)

    -- Draw 3 initial cards
    for _ = 1, 3 do
        player:drawCard()
    end
    
    return player
end

-- Draw a card from the deck
function Player:drawCard()
    if #self.deck > 0 and #self.hand < 7 then
        table.insert(self.hand, table.remove(self.deck, 1))
    end
end

-- Generate the deck from the provided cards table (passed as an argument)
function Player:generateDeck(cards)
    local deck = {}
    local cardCounts = {}
    print(cards)
    -- Check if cards is empty
    if #cards == 0 then
        error("The cards table is empty! Cannot generate deck.")
    end

    -- Debug: Check how many cards are available
    print("Cards available for deck generation: ", #cards)

    while #deck < 20 do
        local candidate = cards[math.random(#cards)]

        -- Check if candidate is valid
        if candidate then
            cardCounts[candidate.name] = (cardCounts[candidate.name] or 0) + 1

            if cardCounts[candidate.name] <= 2 then
                -- Use the constructor to create a proper Card object
                local card = Card:new(candidate.name, candidate.cost, candidate.power, candidate.text)

                -- Assign the functions loaded from JSON
                card.onReveal = candidate.onReveal
                card.onDiscard = candidate.onDiscard
                card.onEndTurn = candidate.onEndTurn

                -- Add the card to the deck
                table.insert(deck, card)
            end
        else
            print("Warning: candidate is nil.")
        end
    end

    return deck
end
-- Draw the player's hand
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

-- Draw the discard pile
function Player:drawDiscardPile(index)
    local xStart = 800  
    local y = (index == 1) and 800 or 0

    for i, card in ipairs(self.discard) do
        card.x = xStart + (i - 1) * 11  
        card.y = y
        card:draw()  -- Draw the card
        card.flipped = false
        local prevFont = love.graphics.getFont()
        love.graphics.setFont(love.graphics.newFont(8))  -- Set font size
        love.graphics.setColor(1, 0, 0)  -- Set text color to red
        love.graphics.printf("Discarded", card.x-40, card.y + 40, 110, "center")
        love.graphics.setFont(prevFont)
    end
end

-- Stage a card to be played
function Player:stageCard(locationIndex, card)
    -- Ensure the location is initialized before accessing it
    if not self.stagedPlays[locationIndex] then
        self.stagedPlays[locationIndex] = {}  -- Initialize it if it's nil
    end

    -- Check if the length of stagedPlays[locationIndex] is less than 4
    if #self.stagedPlays[locationIndex] < 4 then
        table.insert(self.stagedPlays[locationIndex], card)
        self.mana = self.mana - card.cost
        self:removeFromHand(card)
    else
        print("Not enough mana to play: ", card.name)
    end
end

-- Remove a card from hand
function Player:removeFromHand(card)
    for i, c in ipairs(self.hand) do
        if c == card then table.remove(self.hand, i) 
        break 
        end
    end
end

return Player
