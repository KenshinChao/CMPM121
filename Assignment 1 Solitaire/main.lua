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
  
  table.insert(cardTable, CardClass:new(screenWidth/2, screenHeight/2, 50,100, "Hearts", 5))
  
   table.insert(cardTable, CardClass:new(screenWidth/2, screenHeight/2 + 50, 50,100, "Spades", 11))
  
    table.insert(cardTable, CardClass:new(screenWidth/2, screenHeight/2 + 100, 50,100, "Back Blue", 1))
  
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
  if button == 1 and draggingCard == nil then 
    for i, card in ipairs(cardTable) do
      if card:isClicked(x, y) then
        card.selected = true
        draggingCard = card
        table.remove(cardTable,i)
        table.insert(cardTable,card)
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
