
require "vector"

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}
local flipped_img = love.graphics.newImage("images/Back Blue 2.png")


function CardClass:new(xPos, yPos, color, suit, number, isDraggable, flipped)
  local card = {}
  local metadata = {__index = CardClass,
    __tostring = function(self)
      return tostring(color) .. tostring(suit) .. tostring(number)
    end
    
  }
  
  
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(50, 70)
  card.state = CARD_STATE.IDLE
  card.color = color
  card.flipped = flipped
  
  local imgpath = suit .. " " ..  number
  card.image = love.graphics.newImage("images/" .. imgpath .. ".png")
  card.suit = suit
  card.number = number
  card.isDraggable = isDraggable
  return card
end

function CardClass:update()
  
end

function CardClass:draw()
    
  if self.state ~= CARD_STATE.IDLE then
    love.graphics.setColor(0, 0, 0, 0.8) -- color values [0, 1]
    local offset = 4 * (self.state == CARD_STATE.GRABBED and 2 or 1)
    love.graphics.rectangle("fill", self.position.x + offset, self.position.y + offset, self.size.x, self.size.y, 6, 6)
  end
  
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
  
  --love.graphics.print(tostring(self.state), self.position.x + 20, self.position.y - 20)
  if self.flipped == true then
    love.graphics.draw(flipped_img,self.position.x, self.position.y, 0, 1/2, 1/2)
  else
    love.graphics.draw(self.image, self.position.x, self.position.y, 0, 1/2, 1/2)
  end
end

function CardClass:checkForMouseOver(grabber)
  if self.state == CARD_STATE.GRABBED or self.flipped == true  then
    return
  end
    
  local mousePos = grabber.currentMousePos
  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  
  self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
end