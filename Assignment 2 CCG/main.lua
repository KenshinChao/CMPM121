roundStartEffects = {}
roundEndEffects = {}

io.stdout:setvbuf("no")

require "cardClass"
require "game"
require "locationClass"
require "player"

draggedCard = nil

submitButton = {
  x = 540,
  y = 200,
  width = 200,
  height = 50,
  text = "Submit Turn"
}


function love.load()
  math.randomseed(os.time())
  local p1 = Player:new("You")
  local p2 = Player:new("AI")
  love.window.setMode(960, 960)
  game = Game:new(p1, p2) 
  
  game:startTurn()
end

function love.mousepressed(x, y, button)
  if button == 1 then
     -- Check if Submit button was clicked
    if x > submitButton.x and x < submitButton.x + submitButton.width and
       y > submitButton.y and y < submitButton.y + submitButton.height then

      if game.phase == "player" then
        print("game phase: PLAYER")
        game:playerSubmit()
      elseif game.phase == "ai" then
        print("game phase: AI")
        game:aiSubmit()
      elseif game.phase == "intermission" then
        
        --nothing
        print("game phase: INTERMISSION")
        game.phase = "reveal"
      elseif game.phase == "reveal" then
        print("game phase: REVEALSTAGE")
        game:RevealStage()
        
      end

      return
    end
    for _, card in ipairs(game.players[1].hand) do
      if x > card.x and x < card.x + 100 and y > card.y and y < card.y + 150 then
        draggedCard = card
        print("draggedCard: " , draggedCard)
        draggedCard.position = ml
        break
      end
    end
  end
end

function love.mousereleased(x, y, button)
  if button == 1 and draggedCard and game.phase == "player" then
    for i, location in ipairs(game.locations) do
      if location:isInside(x, y) then
        print("In location: ",location.name)
        game.players[1]:stageCard(i, draggedCard)
        break
      end
    end
    draggedCard = nil
  end
end

function love.mousemoved(x, y, dx, dy)
  if draggedCard then
    draggedCard.x = x - 50
    draggedCard.y = y - 75
  end
end

function love.draw()
  
 love.graphics.clear(1, 1, 1)  -- RGB for white background
 love.graphics.setColor(0, 0, 0)  -- Black text
  game:draw()
  -- Submit button
  love.graphics.setColor(0.2, 0.6, 0.9)
  love.graphics.rectangle("fill", submitButton.x, submitButton.y, submitButton.width, submitButton.height, 10)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(submitButton.text, submitButton.x, submitButton.y + 15, submitButton.width, "center")
if draggedCard then
  draggedCard:draw()
  end
end