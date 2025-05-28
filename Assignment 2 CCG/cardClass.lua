Card = {}

function Card:new(name, cost, power, text)
  local card = {}
  local metadata = {
        __index = Card,
        __tostring = function(self)
            return tostring(name) .. tostring(cost) .. tostring(power)
        end
  }

  setmetatable(card, metadata)
  card.name = name  
  card.cost = cost
  card.power = power
  card.text = text or ""
  card.x = 0
  card.y = 0
  card.flipped = false  

  return card
end

function Card:draw()
  local w, h = 70, 100
  
  
  if self.flipped then
    -- Draw a blank or generic card back
    love.graphics.setColor(0.2, 0.2, 0.2)  -- dark gray
    love.graphics.rectangle("fill", self.x, self.y, w, h, 10, 10)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", self.x, self.y, w, h, 10, 10)
    return 
  end
  local artH = h / 2

  local prevFont = love.graphics.getFont()

  -- Card background
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", self.x, self.y, w, h, 10, 10)

  -- Border
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", self.x, self.y, w, h, 10, 10)

  -- Art box (top half)
  love.graphics.setColor(0.95, 0.95, 0.95)
  love.graphics.rectangle("fill", self.x + 5, self.y + 5, w - 10, artH - 10)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", self.x + 5, self.y + 5, w - 10, artH - 10)

  -- Cost circle (top-left)
  love.graphics.setColor(1, 1, 0.6)
  love.graphics.circle("fill", self.x + 12, self.y + 12, 10)
  love.graphics.setColor(0, 0, 0)
  love.graphics.circle("line", self.x + 12, self.y + 12, 10)
  love.graphics.setFont(love.graphics.newFont(8))
  love.graphics.printf(tostring(self.cost), self.x + 2, self.y + 6, 20, "center")

  -- Power circle (top-right)
  love.graphics.setColor(1, 0.8, 0.8)
  love.graphics.circle("fill", self.x + w - 12, self.y + 12, 10)
  love.graphics.setColor(0, 0, 0)
  love.graphics.circle("line", self.x + w - 12, self.y + 12, 10)
  love.graphics.setFont(love.graphics.newFont(8))
  love.graphics.printf(tostring(self.power), self.x + w - 22, self.y + 6, 20, "center")

  -- Card name
  love.graphics.setFont(love.graphics.newFont(9))
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf(self.name, self.x + 5, self.y + artH + 6, w - 10, "center")

  -- Description text
  love.graphics.setFont(love.graphics.newFont(7))
  love.graphics.printf(self.text, self.x + 5, self.y + artH + 24, w - 10, "center")

  -- Restore previous font
  love.graphics.setFont(prevFont)
end
return Card