io.stdout:setvbuf("no")

offsetX = -25
offsetY = -25


require "card"

--for i = 1, 52 do
--  print(i)
--end


function love.load()
  draggingCard = nil
  screenWidth = 640
  screenHeight = 480
  love.window.setMode(screenWidth, screenHeight)
  love.graphics.setBackgroundColor(0.2, 0.7, 0.2, 1)
  
  cardTable = {}
  
  table.insert(cardTable, CardClass:new(screenWidth/2, screenHeight/2, 50,100, "clove", 5))
  
  --print(cardTable)
end

function love.update(dt)
--something
  if draggingCard then
    local x, y = love.mouse.getPosition()
    draggingCard.position.x = x + offsetX
    draggingCard.position.y = y + offsetY
  end
  
end

function love.draw()
  for i, card in ipairs(cardTable) do
    card:draw()
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then 
    for i, card in ipairs(cardTable) do
      if card:isClicked(x, y) then
        card.selected = true
        draggingCard = card
      end
    end
  end
end

function love.mousereleased(x,y, button)
  if button == 1 and draggingCard then
    print(draggingCard.suit .. draggingCard.number .. "was dropped")
    draggingCard.selected = false
    draggingCard = nil
  end
end
