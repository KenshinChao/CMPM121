Location = {}

function Location:new(name)
  local location = {}
  local metadata = {__index = Location}
  setmetatable(location, metadata)
  location.name = name
  location.slots = { [1] = {}, [2] = {} }
  location.x = 0
  location.y = 0
  return location
end

function Location:draw(index, staged1, staged2)
  local screenWidth = love.graphics.getWidth()
  local screenHeight = love.graphics.getHeight()
  local totalLocations = 3

  local locationWidth = 150
  local locationHeight = 100
  local spacing = (screenWidth - totalLocations * locationWidth) / (totalLocations + 1)

  local x = spacing * index + locationWidth * (index - 1)
  local y = screenHeight / 2 - locationHeight / 2

  self.x = x
  self.y = y

  -- Draw location box
  love.graphics.setColor(0.85, 0.9, 1)
  love.graphics.rectangle("fill", x, y, locationWidth, locationHeight, 10, 10)
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", x, y, locationWidth, locationHeight, 10, 10)
  love.graphics.printf(self.name, x, y + 5, locationWidth, "center")
  local function drawGrid(cards, playerIndex)
    for i, card in ipairs(cards) do
      local col = (i - 1) % 2
      local row = math.floor((i - 1) / 2)
      local cardWidth = 70
      local cardHeight = 100
      local cardX = x + 5 + col * (cardWidth + 5)
      local cardY

      if playerIndex == 1 then
        -- Player cards closer just below the location box
        cardY = y + locationHeight + 5 + row * (cardHeight + 5)
      else
        -- AI cards closer just above the location box
        cardY = y - cardHeight - 5 - row * (cardHeight + 5)
      end

      card.x = cardX
      card.y = cardY
      card:draw()
    end
  end

  drawGrid(staged1 or {}, 1)
  drawGrid(staged2 or {}, 2)
end

function Location:isInside(mx, my)
  return mx > self.x and mx < self.x + 200 and my > self.y and my < self.y + 150
end

function Location:resolveTurn(staged1, staged2)
  local function totalPower(cards)
    local sum = 0
    for _, c in ipairs(cards) do sum = sum + c.power end
    return sum
  end

  local p1 = totalPower(staged1)
  local p2 = totalPower(staged2)

  local firstToFlip = nil
  if p1 > p2 then firstToFlip = 1
  elseif p2 > p1 then firstToFlip = 2
  else firstToFlip = math.random(1, 2) end

  print("Revealing location:", self.name)
  for i, staged in ipairs({staged1, staged2}) do
    local who = (i == firstToFlip) and "Flipping First" or "Flipping Second"
    for _, card in ipairs(staged) do
      print(who .. ": " .. card.name .. " (" .. card.power .. ")")
    end
    self.slots[i] = staged
  end

  return p1, p2
end

return Location