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

function Location:draw(index, staged1, staged2, game)
  local screenWidth = love.graphics.getWidth()
  local totalWidth = 3 * 200  -- 3 locations, each 200px wide
  local startX = (screenWidth - totalWidth) / 2  
  
 
  local x = startX + (index - 1) * 200  -- Spread locations horizontally
  local y = love.graphics.getHeight() / 2 - 50  -- Vertically center the locations (adjust as needed)
  self.x = x
  self.y = y

  local locationHeight = 100  
  love.graphics.setColor(0.85, 0.9, 1)
  love.graphics.rectangle("fill", x, y, 200, locationHeight, 12, 12)  
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", x, y, 200, locationHeight, 12, 12) 

  --name
  love.graphics.setColor(0, 0, 0)
  local prevFont = love.graphics.getFont()
  love.graphics.setFont(love.graphics.newFont(14))
  love.graphics.printf(self.name, x, y + locationHeight / 2 - 40, 200, "center")  
  love.graphics.setFont(prevFont)

 
  local function totalPower(cards)
    local sum = 0
    for _, c in ipairs(cards) do sum = sum + c.power end
    return sum
  end

  local p1Power = totalPower(staged1 or {})
  local p2Power = totalPower(staged2 or {})

  -- Display inside box: top for AI, bottom for Player
  if game.phase == "reveal" then
    love.graphics.printf("OPPONENT: " .. p2Power, x + 10, y + 30, 180, "center")  -- AI power
  else
    love.graphics.printf("OPPONENT: " .. 0, x + 10, y + 30, 180, "center")  -- AI power
  end

  love.graphics.printf("YOU: " .. p1Power, x + 10, y + 70, 180, "center")  -- Player power

  -- Draw cards
  local function drawGrid(cards, playerIndex)
    for i, card in ipairs(cards) do
      local col = (i - 1) % 2
      local row = math.floor((i - 1) / 2)
      local cardX = x + 10 + col * 90
      local cardY = (playerIndex == 1)
        and (y + locationHeight + row * 140 + 5)  -- Positioning below the location
        or  (y + locationHeight - 250 - row * 140)  -- Positioning above for AI

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