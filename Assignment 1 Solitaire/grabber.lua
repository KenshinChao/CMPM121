require "vector"

GrabberClass = {}


function GrabberClass:new()
    local grabber = {}
    local metadata = {__index = GrabberClass}
    setmetatable(grabber, metadata)

    grabber.previousMousePos = nil
    grabber.currentMousePos = nil
    grabber.grabPos = nil
    grabber.heldObject = nil
    grabber.heldObjectOriginalPos = nil
    grabber.heldObjectSourcePile = nil
    

    return grabber
end

function GrabberClass:update(deck, drawPile, tableaus, acePiles)
    self.currentMousePos = Vector(love.mouse.getX(), love.mouse.getY())

    if love.mouse.isDown(1) then
        self:grab(deck, drawPile, tableaus)
    end

    if self.heldObject ~= nil and self.heldObject.isDraggable then
        local x, y =
            self.currentMousePos.x - self.heldObject.size.x / 2,
            self.currentMousePos.y - self.heldObject.size.y / 2
        self.heldObject.position.x, self.heldObject.position.y = x, y
    end

    -- Make last tableau cards draggable
    for _, tableau in ipairs(tableaus) do
        if #tableau.cards > 0 then
            tableau.cards[#tableau.cards].isDraggable = true
        end
    end
end

function GrabberClass:grab(deck, drawPile, tableaus)
    self.grabPos = self.currentMousePos
    print("GRAB - " .. tostring(self.grabPos))

    deck:checkForMouseOver(self)
    if deck.state == 1 and self.heldObject == nil then
        if drawing then return end
        deck:drawThreeCards(drawPile)
        drawing = true
        return
    end

    if #drawPile.cards > 0 then
        local card = drawPile.cards[#drawPile.cards]
        card:checkForMouseOver(self)
        if card.state == 1 and self.heldObject == nil and card.isDraggable then
            self.heldObject = card
            self.heldObjectOriginalPos = Vector(card.position.x, card.position.y)
            self.heldObjectSourcePile = drawPile
            card.state = 2
            return
        end
    end

    for _, tableau in ipairs(tableaus) do
        if #tableau.cards > 0 then
            local topCard = tableau.cards[#tableau.cards]
            topCard:checkForMouseOver(self)
            if topCard.state == 1 and self.heldObject == nil and topCard.isDraggable then
                self.heldObject = topCard
                self.heldObjectOriginalPos = Vector(topCard.position.x, topCard.position.y)
                self.heldObjectSourcePile = tableau
                topCard.state = 2
                return
            end
        end
    end
end

function GrabberClass:release(drawPile, tableaus, acePiles, deck)
    print("RELEASE - ") 
    drawing = false
    if self.heldObject == nil then return end
   
    local card = self.heldObject
    local released = false
  
    local allPiles = {}
    for _, t in ipairs(tableaus) do table.insert(allPiles, t) end
    for _, a in ipairs(acePiles) do table.insert(allPiles, a) end

    for _, pile in ipairs(allPiles) do
        pile:checkForMouseOver(self)
        if pile.state == 1 then
            if pile:acceptCard(card, self.heldObjectSourcePile) then
              released = true
              break
            end
        end
    end

    if not released and self.heldObjectOriginalPos then
        card.position = Vector(self.heldObjectOriginalPos.x, self.heldObjectOriginalPos.y)
    end

    if self.heldObjectSourcePile and #self.heldObjectSourcePile.cards > 0 then
        local lastCard = self.heldObjectSourcePile.cards[#self.heldObjectSourcePile.cards]
        if lastCard.flipped then
            lastCard.flipped = false
        end
    end

    card.state = 0
    self.heldObject = nil
    self.heldObjectOriginalPos = nil
    self.heldObjectSourcePile = nil
    self.grabPos = nil
end


function love.mousereleased(x, y, button)
    if button == 1 then
        grabber:release(drawPile, tableaus, acePiles, deck)
    end
end