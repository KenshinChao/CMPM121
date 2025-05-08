--Kenshin Chao
--CMPM 121 - Pickup
-- 4-11-25
io.stdout:setvbuf("no")

require "cardClass"
require "grabber"
require "deck"
require "cardPile"

resetButton = {
    x = 20,
    y = 20,
    width = 100,
    height = 40,
    label = "Reset"
}



function love.load()
    love.window.setMode(960, 640)
    love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
    
    grabber = GrabberClass:new()
    drawPile = CardPile:new(100, 180)
    deck = DeckClass:new(100, 100)
    
    tableau1 = CardPile:new(170, 180)
    tableau2 = CardPile:new(240, 180)
    tableau3 = CardPile:new(310, 180)
    tableau4 = CardPile:new(380, 180)
    tableau5 = CardPile:new(450, 180)
    tableau6 = CardPile:new(520, 180)
    tableau7 = CardPile:new(590, 180)

    AceClubs   = CardPile:new(660, 100, "Clubs 1.png")
    AceDiamond = CardPile:new(730, 100, "Diamond 1.png")
    AceSpade   = CardPile:new(790, 100, "Spades 1.png")
    AceHeart   = CardPile:new(850, 100, "Hearts 1.png")

    for _, pile in ipairs({AceClubs, AceDiamond, AceSpade, AceHeart}) do
        pile.ace = true
    end

    tableaus = {tableau1, tableau2, tableau3, tableau4, tableau5, tableau6, tableau7}
    acePiles = {AceClubs, AceDiamond, AceSpade, AceHeart}

    populateTableaus(tableaus, deck)
end

function love.update()
    grabber:update(deck, drawPile, tableaus, acePiles)


    if #drawPile.cards > 0 then
        drawPile.cards[#drawPile.cards].isDraggable = true
    end


    for _, pile in ipairs(drawPile) do
        for _, card in ipairs(pile.cards) do
            card:update()
        end
    end

    for _, pile in ipairs(tableaus) do
        for _, card in ipairs(pile.cards) do
            card:update()
        end
    end
    
   
    
    
end

function love.draw()
    drawPile:draw()
    for _, tableau in ipairs(tableaus) do
        tableau:draw()
    end
    for _, ace in ipairs(acePiles) do
        ace:draw()
    end
    deck:draw()

  if grabber.heldObject then
    if type(grabber.heldObject) == "table" and grabber.heldObject[1] and grabber.heldObject[1].draw then
        for _, card in ipairs(grabber.heldObject) do
            card:draw()
        end
    elseif grabber.heldObject.draw then
        grabber.heldObject:draw()
    end
end
    
        
    love.graphics.setColor(0.2, 0.2, 0.2, 1) 
    love.graphics.rectangle("fill", resetButton.x, resetButton.y, resetButton.width, resetButton.height, 6, 6)

    love.graphics.setColor(1, 1, 1, 1) 
    love.graphics.printf(
        resetButton.label,
        resetButton.x,
        resetButton.y + 10,
        resetButton.width,
        "center"
    )

   if checkWinCondition() == true then
    local message = "YOU WIN!"
    local winFont = love.graphics.newFont(48)

    local originalFont = love.graphics.getFont()


    love.graphics.setFont(winFont)

    local textWidth = winFont:getWidth(message)
    local textHeight = winFont:getHeight()

    local boxWidth = textWidth + 40
    local boxHeight = textHeight + 30

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local boxX = (screenWidth - boxWidth) / 2
    local boxY = (screenHeight - boxHeight) / 2


    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", boxX, boxY, boxWidth, boxHeight, 12, 12)

    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(message, boxX, boxY + 10, boxWidth, "center")


    love.graphics.setFont(originalFont)
    end
end

function love.mousepressed(x, y, button) --check for reset button
    if button == 1 then
        if x >= resetButton.x and x <= resetButton.x + resetButton.width and
           y >= resetButton.y and y <= resetButton.y + resetButton.height then
            resetGame()
        end
    end
end

function checkWinCondition()
  local numberOfCompletedFoundations = 0
    for _, acePile in ipairs(acePiles) do
      if #acePile.cards == 13 then
        numberOfCompletedFoundations = numberOfCompletedFoundations + 1
      end
    end
    if numberOfCompletedFoundations == 4 then
      print("you win!")
      return true
    end
  return false
end




function populateTableaus(tableaus, deck)
    for i = 1, 7 do
        deck:shuffleDeck()
        for j = 1, i do
            if #deck.cards > 0 then
                local card = table.remove(deck.cards)
                card.isDraggable = false
                table.insert(tableaus[i].cards, card)
                if j < i then
                    card.flipped = true
                end
            end
        end
    end
end

function resetGame()
    -- Reset piles
    drawPile.cards = {}

    for _, pile in ipairs(tableaus) do
        pile.cards = {}
    end

    for _, pile in ipairs(acePiles) do
        pile.cards = {}
    end

    deck = DeckClass:new(100, 100)
    print(deck)
  
    
    populateTableaus(tableaus,deck)
end
  