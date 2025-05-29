roundStartEffects = {}
roundEndEffects = {}

io.stdout:setvbuf("no")

require "cardClass"
require "game"
require "locationClass"
require "player"

draggedCard = nil

submitButton = {
  x = 700,
  y = 700,
  width = 200,
  height = 50,
  text = "Submit Turn"
}



function love.load()
  
  math.randomseed(os.time())
  local p1 = Player:new("You")
  local p2 = Player:new("AI")
  love.window.setMode(960, 960)
  love.window.setTitle("Marvelous Snap")
  game = Game:new(p1, p2) 
  p1.mana = 1
  p2.mana = 1
  game:startTurn()
  
end

function love.update(dt)
  if game and game.update then
    game:update(dt)
  end
end


function love.mousepressed(x, y, button)
  if button == 1 then
    
    if x > submitButton.x and x < submitButton.x + submitButton.width and
       y > submitButton.y and y < submitButton.y + submitButton.height then

      if game.phase == "player" and game.winner == "" then
        print("game phase: PLAYER")
        game:playerSubmit()
      end
    end
    
    if game.phase == "player" and game.winner == "" then
    for _, card in ipairs(game.players[1].hand) do
      if x > card.x and x < card.x + 100 and y > card.y and y < card.y + 150 then
        draggedCard = card
        --print("draggedCard: " , draggedCard)
        break
      end
      end
    end
  end
end


function love.mousereleased(x, y, button)
  if button == 1 and draggedCard and game.phase == "player" then
    for i, location in ipairs(game.locations) do
      if location:isInside(x, y) and draggedCard.cost <= game.players[1].mana then
        
        game.players[1]:stageCard(i, draggedCard)
        break
      end
    end
    draggedCard = nil
  end
end

function love.mousemoved(x, y, dx, dy)
  if draggedCard then
    draggedCard.x = x - 35
    draggedCard.y = y - 50
  end
end

function love.draw()
  
 love.graphics.clear(1, 1, 1)  -- RGB for white background
 love.graphics.setColor(0, 0, 0)  -- Black text

  -- Submit button
  love.graphics.setColor(0.2, 0.6, 0.9)
  love.graphics.rectangle("fill", submitButton.x, submitButton.y, submitButton.width, submitButton.height, 10)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(submitButton.text, submitButton.x, submitButton.y + 15, submitButton.width, "center")
  game:draw()
   if game.winner ~= "" then
  local winnerMessage = game.winner .. " win!"
    
    love.graphics.setColor(1, 0, 0)  
    local prevFont = love.graphics.getFont()
    love.graphics.setFont(love.graphics.newFont(20)) 
    love.graphics.print(winnerMessage, 480,480,0, 2, 2)
    love.graphics.print("press r to restart!" , 420,520,0, 2, 2)
    love.graphics.setFont(prevFont)
    if love.keyboard.isDown("r") then
      game:restart()
    end
   end
   
 
  if draggedCard then
    draggedCard:draw()
  end

   
end