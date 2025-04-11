
require "vector"

CardClass = {}

function CardClass:new(xPos, yPos, width, height, suit, number)
  local card = {}
  local metatable = {__index = CardClass}
  setmetatable(card, metatable)
  card.selected = false
  card.position = Vector(xPos, yPos)
  local imgpath = suit .. " " ..  number
  card.size = Vector(width, height)
  card.suit = suit
  card.number = number
  card.image = love.graphics.newImage("images/" .. imgpath .. ".png")
  
  return card
end

function CardClass:isClicked(mx, my)
  local x = self.position.x
  local y = self.position.y
  local w = self.size.x
  local h = self.size.y
  
  return mx >= x and mx <= x + w and my >= y and my <= y + h
end

function CardClass:draw()
--  if self.selected then
--    love.graphics.setColor(1,1,0)
--  else
--    love.graphics.setColor(1,1,1)
--  end
  --love.graphics.rectangle("fill",self.position.x,self.position.y, self.size.x, self.size.y) 
  love.graphics.draw(self.image, self.position.x, self.position.y, 0, 1/2, 1/2)
--  love.graphics.print(self.suit .. " " .. tostring(self.number), self.position.x + 5, self.position.y + 5)
end
