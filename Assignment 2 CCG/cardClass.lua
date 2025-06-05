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
  card.effectActivated = false
  card.owner = nil

  return card
end

function Card:draw()
  local w, h = 90, 130  -- Slightly larger card dimensions for better readability

  if self.flipped then
    -- Draw a blank or generic card back with a simple design
    love.graphics.setColor(0.2, 0.2, 0.2)  -- dark gray for the back
    love.graphics.rectangle("fill", self.x, self.y, w, h, 15, 15)  -- Rounded corners for a cleaner look
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", self.x, self.y, w, h, 15, 15)
    return 
  end
  
  local artH = h / 2  -- Top half for art

  local prevFont = love.graphics.getFont()

  -- Card background
  love.graphics.setColor(0.95, 0.95, 0.95)  -- Light gray background for card
  love.graphics.rectangle("fill", self.x, self.y, w, h, 15, 15)

  -- Border
  love.graphics.setColor(0, 0, 0)  -- Black border
  love.graphics.rectangle("line", self.x, self.y, w, h, 15, 15)

  -- Art box (top half)
  love.graphics.setColor(0.9, 0.9, 0.9)  -- Slightly lighter for the art area
  love.graphics.rectangle("fill", self.x + 5, self.y + 5, w - 10, artH - 10)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", self.x + 5, self.y + 5, w - 10, artH - 10)

  -- Cost circle (top-left)
  love.graphics.setColor(1, 1, 0.6)  -- Yellow for cost
  love.graphics.circle("fill", self.x + 12, self.y + 12, 12)  -- Larger circle
  love.graphics.setColor(0, 0, 0)
  love.graphics.circle("line", self.x + 12, self.y + 12, 12)
  love.graphics.setFont(love.graphics.newFont(10))  -- Slightly larger font
  love.graphics.printf(tostring(self.cost), self.x + 2, self.y + 6, 22, "center")

  -- Power circle (top-right)
  love.graphics.setColor(1, 0.6, 0.6)  -- Red for power
  love.graphics.circle("fill", self.x + w - 12, self.y + 12, 12)  -- Larger circle
  love.graphics.setColor(0, 0, 0)
  love.graphics.circle("line", self.x + w - 12, self.y + 12, 12)
  love.graphics.setFont(love.graphics.newFont(10))  -- Slightly larger font
  love.graphics.printf(tostring(self.power), self.x + w - 22, self.y + 6, 22, "center")

  -- Card name (larger font and bold)
  love.graphics.setFont(love.graphics.newFont(14))  -- Increase font size to make it stand out more
  love.graphics.setColor(0, 0, 0)  -- Black for the card name
  love.graphics.printf(self.name, self.x + 5, self.y + artH + 6, w - 10, "center")

  -- Description text (smaller font for the text description)
  love.graphics.setFont(love.graphics.newFont(9))  -- Smaller font for description
  love.graphics.setColor(0, 0, 0)  -- Black for text
  love.graphics.printf(self.text, self.x + 5, self.y + artH + 24, w - 10, "center")

  -- Restore previous font
  love.graphics.setFont(prevFont)
end



function Card:createCardCopy()

  local copy = Card:new(self.name, self.cost, self.power, self.text)


  copy.onReveal = self.onReveal
  copy.onDiscard = self.onDiscard
  copy.onEndTurn = self.onEndTurn
 

  return copy
end

return Card