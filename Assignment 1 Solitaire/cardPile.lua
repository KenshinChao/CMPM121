CardPile = {}

require "cardClass"
require "vector"
require "grabber"

PILE_STATE = {
    IDLE = 0,
    MOUSE_OVER = 1
}

--class for tableu and drawpile.
function CardPile:new(xPos, yPos, image)
    local pile = {
        cards = {}
    }
    local metadata = {
        __index = CardPile,
        __tostring = function(self)
            for _, card in ipairs(pile) do
                print(card)
            end
        end
    }
    pile.state = PILE_STATE.IDLE
    pile.string = image
    setmetatable(pile, metadata)
    pile.image = love.graphics.newImage("images/Back Blue 2.png")
    pile.position = Vector(xPos, yPos)
    pile.size = Vector(50, 70)
    pile.isDraggable = false
    pile.ace = false

    if (image ~= nil) then
        pile.image = love.graphics.newImage("images/" .. image)
    end
    return pile
end

function CardPile:draw()
 

    love.graphics.rectangle("fill", self.position.x, self.position.y, 50, 70)
 
    if self.ace == true then
        love.graphics.setColor(1, 1, 1, 0.5) -- Red, Green, Blue, Alpha (opacity)
        love.graphics.draw(self.image, self.position.x, self.position.y, 0, 1 / 2, 1 / 2)
        love.graphics.setColor(1, 1, 1, 1)
    end
    if #self.cards > 0 then
        for i, card in ipairs(self.cards) do
            if card.state == 0 or card.state == 1 then
                card.position.x = self.position.x
                card.position.y = self.position.y + (i - 1) * 20
            end
            card:draw()
        end
    end
end

function CardPile:checkForMouseOver(grabber)
    local mousePos = grabber.currentMousePos
    local isMouseOver =
        mousePos.x > self.position.x and mousePos.x < self.position.x + self.size.x and mousePos.y > self.position.y and
        mousePos.y < self.position.y + self.size.y

    self.state = isMouseOver and PILE_STATE.MOUSE_OVER or PILE_STATE.IDLE
end

function CardPile:acceptCard(card, sourcePile)
    local topCard = self.cards[#self.cards]

    if #self.cards > 0 then
        if self.ace then
            if card.number == topCard.number + 1 and card.suit == topCard.suit then
                table.insert(self.cards, card)
                self:removeCardFromPile(sourcePile, card)
                return true
            end
        elseif card.number == topCard.number - 1 then
            if card.color ~= topCard.color then
              table.insert(self.cards, card)
              self:removeCardFromPile(sourcePile, card)
              return true
          end
        end
    else
        if self.string and card.number == 1 and card.suit .. " 1.png" == self.string then
            table.insert(self.cards, card)
            self:removeCardFromPile(sourcePile, card)
            return true
        elseif card.number == 13 and not self.ace then
            table.insert(self.cards, card)
            self:removeCardFromPile(sourcePile, card)
            return true
        end
    end

    return false
end

function CardPile:removeCardFromPile(pile, card)
    if pile and pile.cards then
        for i = #pile.cards, 1, -1 do
            if pile.cards[i] == card then
                table.remove(pile.cards, i)
                break
            end
        end
    end
end
