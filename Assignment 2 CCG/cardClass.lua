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
  
  love.graphics.setColor(0.9, 0.9, 0.9)
  love.graphics.rectangle("fill", self.x, self.y, w, h, 8, 8)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", self.x, self.y, w, h, 8, 8)



  love.graphics.setColor(0, 0, 0)
  love.graphics.printf(self.name, self.x + 4, self.y + 5, w - 8, "center")
  love.graphics.printf("Cost: " .. self.cost, self.x + 4, self.y + 25, w - 8, "center")
  love.graphics.printf("Power: " .. self.power, self.x + 4, self.y + 45, w - 8, "center")
  love.graphics.printf(self.text, self.x + 4, self.y + 65, w - 8, "center")
end


return Card