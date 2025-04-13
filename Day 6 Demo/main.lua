--Kenshin Chao
--CMPM 121 - Pickup
-- 4-11-25
io.stdout:setvbuf("no")

require "cardClass"
require "grabber"

objectHeld = nil

function love.load()
  love.window.setMode(960, 640) 
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  grabber = GrabberClass:new()
  cardTable = {}
  
  table.insert(cardTable, CardClass:new(100,100))
  
   table.insert(cardTable, CardClass:new(150,150))
  
  
  
end

function love.update()
  grabber:update()
  
  checkForMouseMoving()
  
   for _, card in ipairs(cardTable) do
    card:update() -- or card.draw(card)
  end
end

function love.draw()
  for _, card in ipairs(cardTable) do
    card:draw() -- or card.draw(card)
  end
  
  love.graphics.setColor(1,1,1,1)
  love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " .. 
    tostring(grabber.currentMousePos.y))

end

  

function checkForMouseMoving()
  if grabber.currentMousePos == nil then
    return
  end
  for _, card in ipairs(cardTable) do
    card:checkForMouseOver(grabber)
    if card.state == 1 and grabber.heldObject == nil then
      if love.mouse.isDown(1) then
        grabber.heldObject = card
        print("card grabbed: ")
        
      end
    end
    
  end
  
  
end
