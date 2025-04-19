--Kenshin Chao
--CMPM 121 - Pickup
-- 4-11-25
io.stdout:setvbuf("no")

require "cardClass"
require "grabber"
require "deck"
require "cardPile"


lastObjectHeld = nil
previousPile = nil

function love.load()
  love.window.setMode(960, 640) 
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  grabber = GrabberClass:new()
  drawPile = CardPile:new(100,180)
  
  deck = DeckClass:new(100,100)
  --print(deck)

  tableau1 = CardPile:new(170,180)
  tableau2 = CardPile:new(240,180)
  tableau3 = CardPile:new(310,180)
  tableau4 = CardPile:new(380,180)
  tableau5 = CardPile:new(450,180)
  tableau6 = CardPile:new(520,180)
  tableau7 = CardPile:new(590,180)
  
  AceClubs = CardPile:new(660,100,"Clubs 1.png")
  AceDiamond = CardPile:new(730,100,"Diamond 1.png")
  AceSpade = CardPile:new(790,100,"Spades 1.png" )
  AceHeart = CardPile:new(850,100,"Hearts 1.png")
  
  AceClubs.ace = true
  AceDiamond.ace = true
  AceSpade.ace = true
  AceHeart.ace = true
  tableaus = {tableau1, tableau2, tableau3, tableau4, tableau5, tableau6, tableau7}
  populateTableaus(tableaus, deck)
  
  
  
  
end

function love.update()
  grabber:update()
  
  checkForMouseMoving()
  if #drawPile.cards > 0 then
    drawPile.cards[#drawPile.cards].isDraggable = true
    --print(drawPile.cards[#drawPile.cards])
    --print(drawPile[#drawPile].isDraggable)
  end

  for _, card in ipairs(drawPile.cards) do
    card:update() -- or card.draw(card)
  end
  
  for i, table in ipairs(tableaus) do
    if #table.cards > 0 then
      table.cards[#table.cards].flipped = false
    end
    
    for _,card in ipairs(table.cards) do
      card:update()
    end
    
  end
  
  
end

function love.draw()
  --for i, card in ipairs(drawPile) do
    --print(i)
  --  if card ~= grabber.heldObject then
    -- card.position.y = deck.position.y + (i + 3 - 1) * 30
    --card.position.x = deck.position.x
  --end
  
  drawPile:draw()
  
  tableau1:draw()
  tableau2:draw()
  tableau3:draw()
  tableau4:draw()
  tableau5:draw()
  tableau6:draw()
  tableau7:draw()
  AceClubs:draw()
  AceDiamond:draw()
  AceHeart:draw()
  AceSpade:draw()
  
  deck:draw()
  
    if grabber.heldObject then
    grabber.heldObject:draw()
  end
  love.graphics.setColor(1,1,1,1)
  --love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " .. 
    --tostring(grabber.currentMousePos.y))
  
end

  

function checkForMouseMoving()
  if grabber.currentMousePos == nil then
    return
  end
  
  
  deck:checkForMouseOver(grabber)
  if deck.state == 1 and grabber.heldObject == nil then
    if love.mouse.isDown(1) then
      grabber.heldObject = deck
      print("deck was clicked on")
      deck:drawThreeCards(drawPile)
    end
  end
  
-- Loop through each tableau and check for mouse over the last card (draggable card)
  for _, tableau in ipairs(tableaus) do
    if #tableau.cards > 0 then
      local topCard = tableau.cards[#tableau.cards]
      topCard:checkForMouseOver(grabber)
      
      -- Only allow the last card to be grabbed
      if topCard.state == 1 and grabber.heldObject == nil then
        topCard.isDraggable = true
        topCard.flipped = false
        if love.mouse.isDown(1) then
          previousPile = tableau
          grabber.heldObject = topCard
          lastObjectHeld = topCard
          topCard.state = 2  -- Set the card's state to "grabbed"
          print("card grabbed from tableau")
        end
      end
    end
  end
  if not love.mouse.isDown(1) then
    objectHeld = grabber.heldObject
  tryDropCardOnPile(grabber.heldObject,tableau1)
  tryDropCardOnPile(grabber.heldObject,tableau2)
  tryDropCardOnPile(grabber.heldObject,tableau3)
  tryDropCardOnPile(grabber.heldObject,tableau4)
  tryDropCardOnPile(grabber.heldObject,tableau5)
  tryDropCardOnPile(grabber.heldObject,tableau6)
  tryDropCardOnPile(grabber.heldObject,tableau7)
  tryDropCardOnPile(grabber.heldObject,AceClubs)
  tryDropCardOnPile(grabber.heldObject,AceDiamond)
  tryDropCardOnPile(grabber.heldObject,AceHeart)
  tryDropCardOnPile(grabber.heldObject,AceSpade)
  
  lastObjectHeld = nil
  end
  
  if #drawPile.cards > 0 then
    local card = drawPile.cards[#drawPile.cards]
    card:checkForMouseOver(grabber)
    if card.state == 1 and grabber.heldObject == nil then
      if love.mouse.isDown(1) then
        --print(drawPile[#drawPile].isDraggable)
        grabber.heldObject = card
        lastObjectHeld = card
        previousPile = drawPile
        card.state = 2
        print("card grabbed")
        --print(card)
    end
  end
  end
  
  
end


function tryDropCardOnPile(card, pile)
  pile:checkForMouseOver(grabber)
  --print("trying to drop card")
  if lastObjectHeld ~= nil then
    --print("grabber isn't nil")
    local card = lastObjectHeld
  if pile.state == 1 then
    if #pile.cards > 0 then --cards exist in pile already
      local topCard = pile.cards[#pile.cards]
      if pile.ace == true then
        if card.number == topCard.number + 1 then
        table.insert(pile.cards, card)
        if previousPile ~= nil then
        table.remove(previousPile.cards, #previousPile.cards)
        end
      end
      elseif card.number == topCard.number - 1 then
        table.insert(pile.cards, card)
        if previousPile ~= nil then
        table.remove(previousPile.cards, #previousPile.cards)
        end
        print("Card added to pile")
      else --is not 1 less.
        print("Must drop one lower")
      end
    else --there is no cards in. #pile.cards = 0
      print("tried to add it")
      if pile.string == "Clubs 1.png" then
        if card.number == 1 and card.suit == "Clubs" then 
          table.insert(pile.cards, card)
          table.remove(previousPile.cards, #previousPile.cards)
        end
        
      elseif pile.string == "Hearts 1.png" then
        if card.number == 1 and card.suit == "Hearts" then 
          table.insert(pile.cards, card)
          table.remove(previousPile.cards, #previousPile.cards)
        end
      
    elseif pile.string == "Spades 1.png" then
      if card.number == 1 and card.suit == "Spades" then 
          table.insert(pile.cards, card)
          table.remove(previousPile.cards, #previousPile.cards)
        end
    
    elseif pile.string == "Diamond 1.png" then
      if card.number == 1 and card.suit == "Diamond" then 
          table.insert(pile.cards, card)
          table.remove(previousPile.cards, #previousPile.cards)
        end
      
      elseif card.number == 13 then
      table.insert(pile.cards, card)
      table.remove(previousPile.cards, #previousPile.cards)
      end
    end
    lastObjectHeld = nil
  end
end
end

function populateTableaus(tableaus, deck)

  local currentTableau = 1
  
  -- Distribute cards to each tableau
  for i = 1, 7 do  -- 7 tableaus
    deck:shuffleDeck()
    for j = 1, i do  -- Tableau 1 gets 1 card, tableau 2 gets 2 cards, etc.
      deck:shuffleDeck()
      if #deck.cards > 0 then
        local card = table.remove(deck.cards)  -- Take the card from the deck
        card.isDraggable = false  -- Cards on tableau can't be dragged initially
        table.insert(tableaus[i].cards, card)  -- Add the card to the tableau
        if j < i then
          card.flipped = true
        end
        
      end
    end
  end
end
