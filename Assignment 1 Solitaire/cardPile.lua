
CardPile = {}

require "cardClass"
require "vector"
require "grabber"

PILE_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1
}

function CardPile:new(xPos, yPos)
  local pile = {
    cards = {}
    }
  local metadata = {__index = CardPile,
    __tostring = function(self)
      for _,card in ipairs(pile) do
        print(card)
      end
      
  end
  

}
  pile.state = PILE_STATE.IDLE

  setmetatable(pile, metadata)
  pile.image = love.graphics.newImage("images/Back Blue 2.png")
  pile.position = Vector(xPos, yPos)
  pile.size = Vector(50, 70)
  pile.isDraggable = false
  return pile
end



function CardPile:draw()
   --love.graphics.draw(self.image, self.position.x, self.position.y, 0, 1/2, 1/2)
  love.graphics.rectangle("fill", self.position.x, self.position.y, 50, 70)
   love.graphics.print(tostring(self.state), self.position.x + 20, self.position.y - 20)
  if #self.cards > 0 then
  for i,card in ipairs(self.cards) do
    --print(card)
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
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  
  self.state = isMouseOver and PILE_STATE.MOUSE_OVER or PILE_STATE.IDLE
end
